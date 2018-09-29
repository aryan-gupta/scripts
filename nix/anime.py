#!/usr/bin/python

import requests
import urllib
import bs4

anime_urls = [
	  'https://kissanime.ac/Anime/Boku-no-Hero-Academia-3rd-Season.63295/'
	, 'https://kissanime.ac/Anime/Isekai-Maou-to-Shoukan-Shoujo-no-Dorei-Majutsu-Sub/'
]

req = urllib.request.Request(
	'http://kissanime.ac/Anime/Boku-no-Hero-Academia-3rd-Season.63295/',
	data=None,
	headers={
		'authority': 'kissanime.ac',
		'referer': 'https://kissanime.ac/kissanime.html',
		'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.183 Safari/537.36 Vivaldi/1.96.1147.64'
    }
)

current_url = urllib.request.urlopen(req)
print(current_url.read())
soup = BeautifulSoup(current_url.read())

for link in soup.find_all('a'):
	print(link.get('href'))

# curl https://kissanime.ac/ajax/anime/load_episodes_v2\?s\=dlmserver -d 'episode_id=148120'
# {"status":true,"value":"<iframe id=\"frame-player\" class=\"frame-player\" src=\"\/\/www.dailymotion.com\/embed\/video\/x6tngqv?autoplay=1\" frameborder=\"0\" scrolling=\"no\" marginheight=\"0\" marginwidth=\"0\" allowfullscreen=\"\" allow=\"autoplay\"><\/iframe><style type=\"text\/css\">.frame-player{border:none;width:100%;height:552px}<\/style>","embed":true,"html5":false,"type":"","sv":"dlm","download_get":"https:\/\/play.kissanime.ac\/player.php?r=0&k=8913788588fb81efa1f16d6e89d5bbe17fe34d8425fb6cb376baa4cd2f7c2c8b&li=0&tham=1537202960&lt=fb&qlt=720p&spq=p&prv=&key=baaf48df4a1a4b1360db1aff6007c40b"}%

server = "dlmserver"
# server = "fserver"
# server = "oserver"

# Base link and request data
episode_url = 'https://kissanime.ac/ajax/anime/load_episodes_v2?s=' + server
payload = 'episode_id=148120'
headers = {'content-type': 'application/x-www-form-urlencoded'}
r = requests.post(episode_url, data=payload, headers=headers)
res_json = r.json()

if not res_json["embed"]:
	print(res_json["value"])
else:
	res_str = res_json["value"]

	# Clean up response
	start_str = r'src="'
	end_str   = r'"'

	# Find start string but dont include it in the substring
	start = res_str.find(start_str) + len(start_str)
	end   = res_str.find(end_str, start)

	link = res_str[start:end]

	print(link)