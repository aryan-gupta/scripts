from collections import namedtuple

def resloc_parse(uri):
	start, end = (0, 0)
	end = uri.find("@", start)
	left, right = ("", uri) if end == -1 else (uri[start:end], uri[end + 1:]) # favor host/port over user/passwd

	user, passwd = left.split(":") if left.find(":") != -1 else (left, "") # favor the user over passwd
	host, port = right.split(":") if right.find(":") != -1 else (right, "") # favor host over the port

	return user, passwd, host, port

def tail_parse(uri):
	start, end = (len(uri), len(uri))

	# Start parsing in the reverse direction

	start = uri.find("#")
	frag, end = ("", end) if start == -1 else (uri[start + 1:end], start)

	start = uri.find("?")
	query, end = ("", end) if start == -1 else (uri[start + 1:end], start)

	start = uri.find(";")
	param, end = ("", end) if start == -1 else (uri[start + 1:end], start)

	path = uri[:end]

	return path, param, query, frag


def uri_parse(uri):
	# scheme://user:passwd@host:port/path;param?query#frag
	ParsedURI = namedtuple("ParsedURI", "scheme user passwd host port path param query frag ")

	start, end = (0, 0)

	end = uri.find("://", start)
	scheme, start = ("", start) if end == -1 else (uri[start:end], end + 3)

	end = uri.find("/", start)
	resloc, start = (uri[start:], len(uri)) if end == -1 else (uri[start:end], end)

	user, passwd, host, port = resloc_parse(resloc)
	path, param, query, frag = tail_parse(uri[start:])

	return ParsedURI(scheme, user, passwd, host, port, path, param, query, frag)
