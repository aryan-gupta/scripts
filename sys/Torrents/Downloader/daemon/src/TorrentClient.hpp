
#pragma once

#include <thread>
#include <atomic>
#include <memory>

#include <libtorrent/session.hpp>
#include <libtorrent/torrent_handle.hpp>
#include <libtorrent/torrent_status.hpp>

#include "main.hpp"

class TorrentClient {
	std::shared_ptr<Server> mSvr;
	lt::session mSession;
	std::vector<lt::torrent_handle> mTorrents;
	std::atomic_bool mKill;
	std::thread mThread;

	void run();

	static lt::settings_pack get_settings();
	static char const* state(lt::torrent_status::state_t s);
	[[maybe_unused]] lt::torrent_handle add_magnet(std::string_view magnet);

public:
	TorrentClient(std::shared_ptr<Server> svr);

	void stop();
};