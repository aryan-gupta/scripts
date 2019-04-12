
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