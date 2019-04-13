
#include <iostream>

#include <boost/bind.hpp>
#include <boost/asio.hpp>

#include "Server.hpp"
#include "Connection.hpp"
#include "main.hpp"

namespace ip = boost::asio::ip;
namespace asio = boost::asio;
namespace ph = std::placeholders;


namespace {
	static constexpr unsigned short gPORT = 29628;
	static constexpr size_t gHEADER_LEN = 4;
	const Connection::buffer_type gFIN = { 0, 0, 0, 3, 'F', 'I', 'N' };
	const constexpr std::string_view gIPSERVER = "home.theguptaempire.net";
	const constexpr std::string_view gIPSVRPORT = "29630";
}


Server::Server()
	: mIOcontext{  }
	, mResolver{ mIOcontext }
	, mAcceptor{ mIOcontext, ip::tcp::endpoint{ ip::tcp::v4(), gPORT } }
	, mQLock{  }
	, mQueue{  }
	, mIPLock{  }
	, mExtIP{  }
	, mThread{ [this](){ this->mIOcontext.run(); } }
{
	start_accept();
	std::shared_ptr<asio::deadline_timer> timer { new asio::deadline_timer{ mIOcontext } };
	timer->expires_from_now(boost::posix_time::seconds{ 1 });
	timer->async_wait(std::bind(
		&Server::ip_get_addr,
		this,
		timer,
		ph::_1
	));
	// This is going to be temp for debug
	using namespace std::string_literals;
	this->add_message("magnet:?xt=urn:btih:c466035da5de7b04df065831e87ac368456e7fbe&dn=kali-linux-light-2019-1a-armhf-img-xz"s);
}


Server::~Server()
{ stop(); }


void Server::ip_get_addr(std::shared_ptr<asio::deadline_timer> timer, boost_error error) {
	timer->expires_from_now(boost::posix_time::seconds{ 30 });
	timer->async_wait( std::bind(
		&Server::ip_get_addr,
		this,
		timer,
		ph::_1
	));

	mResolver.async_resolve(
		gIPSERVER, gIPSVRPORT,
		std::bind(
			&Server::ip_start_connection,
			this,
			ph::_1,
			ph::_2
		)
	);
}


void Server::ip_start_connection(boost_error error, ip::tcp::resolver::results_type results) {
	connection_ptr con = create_connection();
	asio::connect(con->socket, results);

	con->buffer.resize(gHEADER_LEN);

	asio::async_read(
		con->socket,
		asio::buffer(con->buffer),
		std::bind(&Server::ip_header_handler, this, con, ph::_1, ph::_2)
	);
}


void Server::ip_header_handler(connection_ptr con, boost_error error, size_t numb) {
	if (error) {
		print_boost_error(error);
		std::terminate();
	}

	// if we are little endian then properly convert big endian data to big endian
	uint32_t len = parse_header(con->buffer);

	con->buffer.resize(len);

	asio::async_read(
		con->socket,
		asio::buffer(con->buffer),
		std::bind(&Server::ip_message_handler, this, con, ph::_1, ph::_2)
	);
}


void Server::ip_message_handler(connection_ptr con, boost_error error, size_t numb) {
	if (error) {
		print_boost_error(error);
		std::terminate();
	}

	std::string ip{ con->buffer.begin(), con->buffer.end() };
	ip_update(ip);

	con->socket.close();
}


void Server::ip_update(std::string_view str) {
	unique_lock lk{ mIPLock };
	mExtIP = str;
}


std::string Server::get_ip() {
	unique_lock lk{ mIPLock };
	return mExtIP;
}


uint32_t Server::parse_header(const buffer_type& data) {
	uint32_t len{  };
	for (size_t i = 0; i < gHEADER_LEN; ++i) {
		len = (len << 8) + data[i];
	}
	return len;
}


auto Server::create_header(uint32_t len) -> buffer_type {
	buffer_type head( gHEADER_LEN );
	for (size_t i = 0; i < gHEADER_LEN; ++i) {
		head[3 - i] = (len >> (8 * i)) bitand 0xFF;
	}
	return head;
}


void Server::stop() {
	if (!mIOcontext.stopped())
		mIOcontext.stop();
	if (mThread.joinable())
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
		print_boost_error(error);
		std::terminate();
	}

	con->buffer.resize(gHEADER_LEN);

	asio::async_read(
		con->socket,
		asio::buffer(con->buffer),
		std::bind(&Server::header_handler, this, con, ph::_1, ph::_2)
	);
}

void Server::header_handler(connection_ptr con, boost_error error, size_t numb) {
	if (error) {
		print_boost_error(error);
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
		print_boost_error(error);
		std::terminate();
	}

	std::string link{ con->buffer.begin(), con->buffer.end() };
	add_message(link);

	con->buffer = gFIN;

	asio::async_write(
		con->socket,
		asio::buffer(con->buffer),
		std::bind(&Server::end_connection, this, con, ph::_1)
	);
}


void Server::end_connection(connection_ptr con, boost_error error) {
	if (error) {
		print_boost_error(error);
		std::terminate();
	}
	con->socket.close();
}


template <typename T>
void Server::add_message(T&& link) {
	unique_lock lk{ mQLock };
	mQueue.push(std::forward<T>(link));
}

template void Server::add_message<std::string>(std::string&&);
template void Server::add_message<std::string const&>(std::string const&);


auto Server::try_pop_message() -> opt_msg_type {
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