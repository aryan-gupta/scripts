
#pragma once

class Connection;
class Server;
class TorrentClient;

struct ip_addr {
	using byte = unsigned char;

	byte b1;
	byte b2;
	byte b3;
	byte b4;
};

ip_addr parse_ip(std::string_view sv);
bool operator== (ip_addr a, ip_addr b);
bool operator!= (ip_addr a, ip_addr b);

void print_boost_error(const boost::system::error_code& error);