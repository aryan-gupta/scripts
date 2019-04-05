
#pragma once

#include <memory>
#include <string>

#include <boost/asio.hpp>

class Server;

struct Connection {
	using pointer = std::shared_ptr<Connection>;

	boost::asio::ip::tcp::socket socket;
	std::string buffer;

	Connection() = delete;
	Connection(Server* svr);
};