
#pragma once

#include <memory>
#include <string>

#include <boost/asio.hpp>

class Server;

struct Connection {
	using pointer = std::shared_ptr<Connection>;
	using byte = char;
	using buffer_type = std::vector<byte>;
	using socket_type = boost::asio::ip::tcp::socket;

	socket_type socket;
	buffer_type buffer;

	Connection() = delete;
	Connection(boost::asio::io_context& io);
};