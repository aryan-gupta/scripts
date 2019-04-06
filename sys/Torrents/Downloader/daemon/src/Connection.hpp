
#pragma once

#include <memory>
#include <string>

#include <boost/asio.hpp>

class Server;

struct Connection {
	// https://www.boost.org/doc/libs/1_69_0/doc/html/boost_asio/overview/cpp2011/move_handlers.html
	// ^ According to that, all handlers must be copy constructable, meaning that we have to have
	// pointer be a shared_ptr or the bind object wont be able to be copyable.
	using pointer = std::shared_ptr<Connection>;
	using byte = char;
	using buffer_type = std::vector<byte>;
	using socket_type = boost::asio::ip::tcp::socket;

	socket_type socket;
	buffer_type buffer;

	Connection() = delete;
	Connection(boost::asio::io_context& io);
};