
#pragma once

#include <memory>
#include <string>

#include <boost/asio.hpp>

class Server;

struct Connection {
	using pointer = std::shared_ptr<Connection>;
	using byte = char;

	boost::asio::ip::tcp::socket socket;
	std::vector<byte> buffer;

	Connection() = delete;
	Connection(Server* svr);
};