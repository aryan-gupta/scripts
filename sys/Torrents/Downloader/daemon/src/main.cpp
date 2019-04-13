
#include <string_view>
#include <string>
#include <memory>
#include <iostream>

#include <boost/system/error_code.hpp>

#include "main.hpp"
#include "Server.hpp"
#include "TorrentClient.hpp"

int main() {
	std::cout << "Starting server" << std::endl;
	std::shared_ptr<Server> svr{ new Server{  } };

	std::cout << "Starting torrent downloader" << std::endl;
	std::unique_ptr<TorrentClient> clnt{ new TorrentClient{ svr } };

	for (bool quit = false; !quit;) {
		char reply{  };
		// std::cout << "::";
		std::cout.flush();
		std::cin >> reply;

		switch(std::tolower(reply)) {
			case 'q': quit = true;
			case 's': std::cout << svr->get_size() << std::endl;
		}
	}

	return EXIT_SUCCESS;
}


void print_boost_error(const boost::system::error_code& error) {
	std::cerr << "[E] Type: " << error.category().name() << std::endl;
	std::cerr << "[E] Value: " << error.value() << std::endl;
	std::cerr << "[E] Messsage: " << error.message() << std::endl;
}


ip_addr parse_ip(std::string_view sv) {
	std::string_view::pointer str = sv.data();
	char* begin;
	ip_addr ip;
	ip.b1 = std::strtol(str, &begin, 10);
	ip.b2 = std::strtol(++begin, &begin, 10);
	ip.b3 = std::strtol(++begin, &begin, 10);
	ip.b4 = std::strtol(++begin, &begin, 10);
	return ip;
}


bool operator== (ip_addr a, ip_addr b) {
	return a.b1 == b.b1 and a.b2 == b.b2 and a.b3 == b.b3 and a.b4 == b.b4;
}


bool operator!= (ip_addr a, ip_addr b) {
	return !operator==(a, b);
}