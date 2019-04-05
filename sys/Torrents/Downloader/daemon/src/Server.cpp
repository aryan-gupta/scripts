
#include <iostream>

#include <boost/bind.hpp>
#include <boost/asio.hpp>

#include "Server.hpp"
#include "Connection.hpp"

namespace ip = boost::asio::ip;
namespace asio = boost::asio;
namespace ph = std::placeholders;

Server::Server()
	: mIOcontext{  }
	, mAcceptor{ mIOcontext }
	// , mQueue{ 32 }
{
	accept();
}


void Server::run() {
	mIOcontext.run();
}


// auto Server::header_match(iterator begin, iterator end) -> std::pair<iterator, bool> {
// 	if (std::distance(begin, end) == 4) return std::make_pair(begin, true);
// 	else return std::make_pair(begin, false);
// }


asio::io_context& Server::get_context() {
	return mIOcontext;
}


unsigned short Server::get_port() {
	return mPORT;
}


Connection::pointer Server::create_connection() {
	return Connection::pointer{ new Connection{ this } };
}


void Server::accept() {
	Connection::pointer con = create_connection();
	mAcceptor.async_accept(
		con->socket,
		std::bind(&Server::connection_handler, this, con, ph::_1)
	);
}


void Server::connection_handler(Connection::pointer con, boost_error error) {
	accept(); // start new accept while we deal with this connection

	if (error) {
		// For now
		std::terminate();
	}

	asio::async_read(
		con->socket,
		asio::buffer(con->buffer, 4),
		std::bind(&Server::head_handler, this, con, ph::_1, ph::_2)
	);
}

void Server::head_handler(Connection::pointer con, boost_error error, size_t numb) {
	if (error) {
		// For now
		std::terminate();
	}

	// if we are little endian then properly convert big endian data to big endian
	uint32_t len;
	std::memcpy(con->buffer.data(), &len, 4);

	con->buffer = "";
	con->buffer.reserve(len + 1);

	asio::async_read(
		con->socket,
		asio::buffer(con->buffer, len),
		std::bind(&Server::msg_handler, this, con, ph::_1, ph::_2)
	);
}


void Server::msg_handler(Connection::pointer con, boost_error error, size_t numb) {
	if (error) {
		// For now
		std::terminate();
	}

	std::cout << con->buffer << std::endl;
	con->buffer = "Done";

	asio::async_write(
		con->socket,
		asio::buffer(con->buffer),
		std::bind(&Server::end_connection, this, con, ph::_1)
	);
}


void Server::end_connection(Connection::pointer con, boost_error error) {
	if (error) {
		// For now
		std::terminate();
	}
}


void Server::add_magnet(std::string link) {

}


std::optional<std::string> Server::try_pop_magnet() {
	return {  };
}