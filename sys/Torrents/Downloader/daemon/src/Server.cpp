
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
	, mAcceptor{ mIOcontext, ip::tcp::endpoint{ ip::tcp::v4(), mPORT } }
	, mThread{ [this](){ this->mIOcontext.run(); } }
	// , mQueue{ 32 }
{
	accept();
}


Server::~Server() {
	stop();
}

void Server::stop() {
	if (!mIOcontext.stopped())
		mIOcontext.stop();
	mThread.join();
}


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

	con->buffer.resize(mHEADER_LEN);

	asio::async_read(
		con->socket,
		asio::buffer(con->buffer),
		std::bind(&Server::head_handler, this, con, ph::_1, ph::_2)
	);
}

uint32_t Server::parse_header(const std::vector<char>& data) {
	uint32_t len{  };
	for (short i = 0; i < mHEADER_LEN; ++i) {
		len = (len << 8) + data[i];
	}
	return len;
}

std::vector<char> Server::create_header(uint32_t len) {
	// char buff[sizeof(len)];
	// std::memcpy(buff, &len, sizeof(len));
	// std::vector<char> head{ buff, buff + sizeof(len) };
	std::vector<char> head(4);
	for (int i = 0; i < mHEADER_LEN; ++i) {
		head[3 - i] = (len >> (8 * i)) bitand 0xFF;
	}
	return head;
}

void Server::head_handler(Connection::pointer con, boost_error error, size_t numb) {
	if (error) {
		// For now
		std::terminate();
	}

	// if we are little endian then properly convert big endian data to big endian
	uint32_t len = parse_header(con->buffer);

	con->buffer.resize(len);

	asio::async_read(
		con->socket,
		asio::buffer(con->buffer),
		std::bind(&Server::msg_handler, this, con, ph::_1, ph::_2)
	);
}


void Server::msg_handler(Connection::pointer con, boost_error error, size_t numb) {
	if (error) {
		// For now
		std::terminate();
	}

	// std::string str{ con->buffer.begin(), con->buffer.end() };
	// std::cout << str << std::endl;

	con->buffer.clear();

	auto raw = "Done";
	size_t len = strlen(raw);

	auto head = create_header(len);

	std::back_insert_iterator it{ con->buffer };
	std::move(head.begin(), head.end(), it);
	std::move(raw, raw + len, it);

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
	con->socket.close();
}


void Server::add_magnet(std::string link) {

}


std::optional<std::string> Server::try_pop_magnet() {
	return {  };
}