
#pragma once

#include <atomic>
#include <string>
#include <optional>

#include <boost/asio.hpp>
#include <boost/lockfree/queue.hpp>

#include "Connection.hpp"

/// This server communicates with the tdowndaemon.py script
/// to store magnet links it gets. This server will run on one thread
/// and will store magnet links it gets
class Server {
	static constexpr unsigned short mPORT = 29628;

	using boost_error = const boost::system::error_code&;

	boost::asio::io_context mIOcontext;
	boost::asio::ip::tcp::acceptor mAcceptor;
	// boost::lockfree::queue<std::string> mQueue;

	static uint32_t parse_header(const std::vector<char>& data);
	static std::vector<char> create_header(uint32_t len);

public:
	/// Default c'tor
	Server();

	void run();

	/// Return a ref to the io_context
	boost::asio::io_context& get_context();

	/// Returns the port this server is listening to
	unsigned short get_port();

	/// Creates a connection
	Connection::pointer create_connection();

	/// Async accept a connection
	void accept();

	/// Handles a connection
	void connection_handler(Connection::pointer con, boost_error error);

	///
	void head_handler(Connection::pointer con, boost_error error, size_t numb);

	/// Handles a message
	void msg_handler(Connection::pointer con, boost_error error, size_t numb);

	/// Ends the connection to the client
	void end_connection(Connection::pointer con, boost_error error);

	/// Adds a magnet link
	void add_magnet(std::string link);

	/// Trys to pop a magnet link from the queue. If the queue is empty, it will
	/// return nothing
	std::optional<std::string> try_pop_magnet();

};