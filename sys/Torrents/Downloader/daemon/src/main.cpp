
#include <string_view>
#include <string>
#include <memory>
#include <iostream>

#include <boost/system/error_code.hpp>

#include "Server.hpp"
#include "main.hpp"

int main() {
	std::shared_ptr<Server> svr{ new Server{  } };
	svr->run();

	return EXIT_SUCCESS;
}


void print_boost_error(const boost::system::error_code& error) {
	std::cerr << "[E] Type: " << error.category().name() << std::endl;
	std::cerr << "[E] Value: " << error.value() << std::endl;
	std::cerr << "[E] Messsage: " << error.message() << std::endl;
}