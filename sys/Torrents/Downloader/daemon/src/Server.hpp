
#pragma once

#include <atomic>
#include <string>
#include <optional>
#include <mutex>
#include <queue>

#include <boost/asio.hpp>
#include <boost/lockfree/queue.hpp>

#include "Connection.hpp"

/// This server communicates with the tdowndaemon.py script
/// to store magnet links it gets. This server will run on one thread
/// and will store magnet links it gets
class Server {
	using buffer_type = Connection::buffer_type;
	using boost_error = const boost::system::error_code&;
	using connection_ptr = Connection::pointer;
	using unique_lock = std::unique_lock<std::mutex>;

	boost::asio::io_context mIOcontext; //< IO context for IO
	boost::asio::ip::tcp::resolver mResolver;
	boost::asio::ip::tcp::acceptor mAcceptor; //< Acceptor for new incoming connections
	std::mutex mQLock; //< Lock to protect Queue
	std::queue<std::string> mQueue; //< Queue of messages
	std::mutex mIPLock;
	std::string mExtIP;
	std::thread mThread; //< Thread for server

	/// Parsed a header from communication
	static uint32_t parse_header(const buffer_type& data);

	/// Craetes a header for comunication
	static buffer_type create_header(uint32_t len);

	/// Adds a magnet link
	template <typename T> void add_message(T&& link);

	/// Creates a connection
	connection_ptr create_connection();

	/// Async accept a connection
	void start_accept();

	/// Handles a connection and sets up async read header
	void connection_handler(connection_ptr con, boost_error error);

	/// Reads in header and sets up async read message
	void header_handler(connection_ptr con, boost_error error, size_t numb);

	/// Handles a message and async sends reply to close
	void message_handler(connection_ptr con, boost_error error, size_t numb);

	/// Ends the connection to the client
	void end_connection(connection_ptr con, boost_error error);

	void ip_get_addr(std::shared_ptr<boost::asio::deadline_timer> timer, boost_error error);

	void ip_start_connection(boost_error error, boost::asio::ip::tcp::resolver::results_type results);

	void ip_header_handler(connection_ptr con, boost_error error, size_t numb);

	void ip_message_handler(connection_ptr con, boost_error error, size_t numb);

	void ip_update(std::string_view str);

public:
	using opt_msg_type = std::optional<std::string>;
	/// Default c'tor
	Server();

	// Destroys the server
	~Server();

	/// Stops the server
	void stop();

	/// Trys to pop a magnet link from the queue. If the queue is empty, it will
	/// return nothing
	opt_msg_type try_pop_message();

	std::string get_ip();

	size_t get_size();

};