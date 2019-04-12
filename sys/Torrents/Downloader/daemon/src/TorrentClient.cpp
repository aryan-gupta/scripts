
#include <iostream>

#include <libtorrent/magnet_uri.hpp>
#include <libtorrent/error_code.hpp>
#include <libtorrent/alert_types.hpp>
#include <libtorrent/alert.hpp>

#include "TorrentClient.hpp"
#include "Server.hpp"

namespace {
	using opt_magnet = Server::opt_msg_type;
	static constexpr std::string_view SAVE_LOC = "~/Downloads/Torrents";
}

TorrentClient::TorrentClient(std::shared_ptr<Server> svr)
	: mSvr{ svr }
{

}

void TorrentClient::run() {
	while (!mKill.load(std::memory_order_relaxed)) {
		lt::error_code ec;

		// Check if there are anymore torrents to queue up
		for (opt_magnet link = mSvr->try_pop_message(); link.has_value(); link = mSvr->try_pop_message()) {
			/// @todo update this for ABI change
			lt::add_torrent_params param;
			lt::parse_magnet_uri(link.value(), param, ec);

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
		for (auto alert : alerts) {
			if (auto fin = lt::alert_cast<lt::torrent_finished_alert>(alert)) {
				auto handle = fin->handle;
				// Do somthing with finished torrents
			}
		}
	}
}