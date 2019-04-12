
#include <iostream>

#include <libtorrent/magnet_uri.hpp>
#include <libtorrent/error_code.hpp>
#include <libtorrent/alert_types.hpp>
#include <libtorrent/alert.hpp>

#include "TorrentClient.hpp"
#include "Server.hpp"

namespace {
	using opt_magnet = Server::opt_msg_type;
	// static constexpr std::string_view SAVE_LOC = "~/Downloads/Torrents";
	static constexpr std::string_view SAVE_LOC = "./";
}

TorrentClient::TorrentClient(std::shared_ptr<Server> svr)
	: mSvr{ svr }
	, mSession{ get_settings() }
	, mTorrents{  }
	, mKill{ false }
	, mThread{ &TorrentClient::run, this }
	{
	mSession.add_dht_node(std::make_pair("router.utorrent.com", 6881));
	mSession.add_dht_node(std::make_pair("router.bittorrent.com", 6881));
	mSession.add_dht_node(std::make_pair("dht.transmissionbt.com", 6881));
	mSession.add_dht_node(std::make_pair("dht.aelitis.com", 6881));
}

}

void TorrentClient::run() {
	while (!mKill.load(std::memory_order_relaxed)) {
		lt::error_code ec;

		// Check if there are anymore torrents to queue up
		for (opt_magnet link = mSvr->try_pop_message(); link.has_value(); link = mSvr->try_pop_message()) {
			lt::add_torrent_params param = lt::parse_magnet_uri(link.value(), ec);
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

			mTorrents.push_back(std::move(handle));
		}

		// Get any alerts and pop them
		std::vector<lt::alert*> alerts;
		mSession.pop_alerts(&alerts);

		// Process alerts
		for (auto a : alerts) {
			if (auto status = lt::alert_cast<lt::state_update_alert>(a)) {
				for (auto& s : status->status) {
					std::cout << s.name << std::endl;
					std::cout << "\r"/* << state(s.state) */<< " "
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