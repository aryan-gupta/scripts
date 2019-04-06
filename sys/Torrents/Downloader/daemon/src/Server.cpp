
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
	, mQLock{  }
	, mQueue{  }
	, mThread{ [this](){ this->mIOcontext.run(); } }
{ start_accept(); }


Server::~Server()
{ stop(); }


uint32_t Server::parse_header(const buffer_type& data) {
	uint32_t len{  };
	for (short i = 0; i < mHEADER_LEN; ++i) {
		len = (len << 8) + data[i];
	}
	return len;
}


auto Server::create_header(uint32_t len) -> buffer_type {
	// char buff[sizeof(len)];
	// std::memcpy(buff, &len, sizeof(len));
	// buffer_type head{ buff, buff + sizeof(len) };
	buffer_type head(4);
	for (int i = 0; i < mHEADER_LEN; ++i) {
		head[3 - i] = (len >> (8 * i)) bitand 0xFF;
	}
	return head;
}


void Server::stop() {
	if (!mIOcontext.stopped())
		mIOcontext.stop();
	mThread.join();
}


auto Server::create_connection() -> connection_ptr {
	return connection_ptr{ new Connection{ mIOcontext } };
}


void Server::start_accept() {
	connection_ptr con = create_connection();

	mAcceptor.async_accept(
		con->socket,
		std::bind(&Server::connection_handler, this, con, ph::_1)
	);
}


void Server::connection_handler(connection_ptr con, boost_error error) {
	start_accept(); // start new accept while we deal with this connection

	if (error) {
		// For now
		std::terminate();
	}

	con->buffer.resize(mHEADER_LEN);

	asio::async_read(
		con->socket,
		asio::buffer(con->buffer),
		std::bind(&Server::header_handler, this, con, ph::_1, ph::_2)
	);
}

void Server::header_handler(connection_ptr con, boost_error error, size_t numb) {
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
		std::bind(&Server::message_handler, this, con, ph::_1, ph::_2)
	);
}


void Server::message_handler(connection_ptr con, boost_error error, size_t numb) {
	if (error) {
		// For now
		std::terminate();
	}

	std::string link{ con->buffer.begin(), con->buffer.end() };
	add_message(link);

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


void Server::end_connection(connection_ptr con, boost_error error) {
	if (error) {
		// For now
		std::terminate();
	}
	con->socket.close();
}


void Server::add_message(std::string& link) {
	unique_lock lk{ mQLock };
	mQueue.push(link);
}


std::optional<std::string> Server::try_pop_message() {
	unique_lock lk{ mQLock };
	if (mQueue.empty()) {
		return {  };
	} else {
		std::string top = std::move( mQueue.front() );
		mQueue.pop();
		return top;
	}
}


size_t Server::get_size() {
	unique_lock lk{ mQLock };
	return mQueue.size();
}