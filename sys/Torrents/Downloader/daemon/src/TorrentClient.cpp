
#include <iostream>

#include <libtorrent/magnet_uri.hpp>
#include <libtorrent/error_code.hpp>
#include <libtorrent/alert_types.hpp>
#include <libtorrent/alert.hpp>
#include <libtorrent/announce_entry.hpp>

#include "TorrentClient.hpp"
#include "Server.hpp"

namespace {
	using opt_magnet = Server::opt_msg_type;
	// static constexpr std::string_view SAVE_LOC = "~/Downloads/Torrents";
	static constexpr std::string_view SAVE_LOC = "./";
	static constexpr std::string_view IP_TORRENT_LINK = "magnet:?xt=urn:btih:4754d57a842abd32eed19e29d49db44e5ab33424&dn=checkmyiptorrent&tr=http%3A%2F%2F34.204.227.31%2Fcheckmytorrentipaddress.php";
}

TorrentClient::TorrentClient(std::shared_ptr<Server> svr)
	: mSvr{ svr }
	, mSession{ get_settings() }
	, mTorrents{  }
	, mIPChecker{  }
	, mKill{ false }
	, mThread{ &TorrentClient::run, this }
	{
	mSession.add_dht_node(std::make_pair("router.utorrent.com", 6881));
	mSession.add_dht_node(std::make_pair("router.bittorrent.com", 6881));
	mSession.add_dht_node(std::make_pair("dht.transmissionbt.com", 6881));
	mSession.add_dht_node(std::make_pair("dht.aelitis.com", 6881));

	// Add our IP checker torrent. This will allow us to check our torrent IP
	mIPChecker = add_magnet(IP_TORRENT_LINK);
}

// return the name of a torrent status enum
char const* TorrentClient::state(lt::torrent_status::state_t s) {
	switch(s) {
		case lt::torrent_status::checking_files: return "checking";
		case lt::torrent_status::downloading_metadata: return "dl metadata";
		case lt::torrent_status::downloading: return "downloading";
		case lt::torrent_status::finished: return "finished";
		case lt::torrent_status::seeding: return "seeding";
		case lt::torrent_status::allocating: return "allocating";
		case lt::torrent_status::checking_resume_data: return "checking resume";
		default: return "<>";
	}
}

[[maybe_unused]]
lt::torrent_handle TorrentClient::add_magnet(std::string_view magnet) {
	lt::error_code ec;

	// @todo there is no conversion between std::string_view to lt::string_view { aka boost::string_view }
	// so we must use .data() here
	lt::add_torrent_params param = lt::parse_magnet_uri(magnet.data(), ec);
	param.save_path = SAVE_LOC;

	if (ec) {
		print_boost_error(ec);
		std::terminate();
	}

	lt::torrent_handle handle = mSession.add_torrent(param, ec);

	if (ec) {
		print_boost_error(ec);
		std::terminate();
	}

	return handle;
}


void TorrentClient::check_ip() {
	// Get the ip from the ip checker, the first tracker and first endpoint should have our
	// IP message.
	auto trackers = mIPChecker.trackers();
	for (auto& t : trackers) {
		for (auto& e : t.endpoints) {
			auto& message = e.message;
			if (    message[0] == 'I'
				and message[1] == 'P'
				and message[2] == ':'
			) {
				std::cout << "Out IP is: " << message.substr(4) << std::endl;
			}
		}
	}
}


void TorrentClient::run() {
	while (!mKill.load(std::memory_order_relaxed)) {
		// Check if there are anymore torrents to queue up
		for (opt_magnet link = mSvr->try_pop_message(); link.has_value(); link = mSvr->try_pop_message()) {
			lt::torrent_handle handle = add_magnet(link.value());
			mTorrents.push_back(std::move(handle));
		}

		check_ip();

		// Get any alerts and pop them
		std::vector<lt::alert*> alerts;
		mSession.pop_alerts(&alerts);

		// Process alerts
		for (auto a : alerts) {
			if (auto status = lt::alert_cast<lt::state_update_alert>(a)) {
				for (auto& s : status->status) {
					std::cout << s.name << std::endl;
					std::cout << "\r" << state(s.state) << " "
					<< (s.download_payload_rate / 1000) << " kB/s "
					<< (s.total_done / 1000) << " kB ("
					<< (s.progress_ppm / 10000) << "%) downloaded";
					std::cout << std::endl;
				}
			}

			if (auto fin = lt::alert_cast<lt::torrent_finished_alert>(a)) {
				auto handle = fin->handle;
				std::cout << "Torrent Done" << std::endl;
			}

			if (lt::alert_cast<lt::torrent_error_alert>(a)) {
				std::cout << "Torrent Error" << std::endl;
			}
		}

		mSession.post_torrent_updates();
		std::this_thread::sleep_for(std::chrono::seconds{ 5 });
	}
}


lt::settings_pack TorrentClient::get_settings() {
	lt::settings_pack p;
	p.set_int(
		  lt::settings_pack::alert_mask
		, lt::alert::status_notification
		| lt::alert::error_notification
		| lt::alert::storage_notification
	);
	return p;
}


void TorrentClient::stop() {
	mKill.store(true, std::memory_order_relaxed);
}