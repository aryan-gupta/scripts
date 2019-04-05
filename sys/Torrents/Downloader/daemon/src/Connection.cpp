
#include <boost/asio.hpp>

#include "Connection.hpp"
#include "Server.hpp"

namespace ip = boost::asio::ip;
namespace asio = boost::asio;

Connection::Connection(asio::io_context& io)
	: socket{ io }
	, buffer{ }
	{  }