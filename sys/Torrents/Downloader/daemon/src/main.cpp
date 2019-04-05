
#include <string_view>
#include <string>
#include <memory>
#include <iostream>

#include "Server.hpp"


int main() {
	std::shared_ptr<Server> svr{ new Server{  } };
	svr->run();

	return EXIT_SUCCESS;
}