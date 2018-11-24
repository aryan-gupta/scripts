from __future__ import print_function
from googleapiclient.discovery import build
from httplib2 import Http
from apiclient.http import MediaIoBaseDownload
from oauth2client import file, client, tools
# from io import BytesIO
import io
# from PIL import Image

# Download the file with id and save it as name using the service
def download_file(service, name, id):
	request = service.files().get_media(fileId=id)
	fh = io.BytesIO()
	downloader = MediaIoBaseDownload(fh, request)
	done = False
	while done is False:
		status, done = downloader.next_chunk()
		print ("Download %d%%." % int(status.progress() * 100))
	with open(name, "wb") as f:
		f.write(fh.getvalue());

def get_service():
	# FULL DRIVE ACCESS SCOPE https://developers.google.com/identity/protocols/googlescopes
	SCOPES = 'https://www.googleapis.com/auth/drive'
	store = file.Storage('token.json')
	creds = store.get()
	if not creds or creds.invalid:
		flow = client.flow_from_clientsecrets('credentials.json', SCOPES)
		creds = tools.run_flow(flow, store)
	return build('drive', 'v3', http=creds.authorize(Http()))
	
		
def main():
	service = get_service()

	GOOGLE_PHOTOS_ID = '1k6oKs2XDERzXjx025lySeyd7PbKr5_z77GkLcG-1vas'
	
	# Get Google Photos folder ID
	response = service.files().list(
		q = "name = 'Google Photos' and mimeType = 'application/vnd.google-apps.folder'",
		spaces = 'drive',
		fields = 'files(id, name)'
	).execute()
	
	for f in response.get('files', []):
		if f.get('id') != GOOGLE_PHOTOS_ID:
			raise FileNotFoundError('[E] Could not find Google Photos folder')
	
	# Iterate over files and Download
	page_token = None
	while True:
		filesToBU = service.files().list(
			q = "'1k6oKs2XDERzXjx025lySeyd7PbKr5_z77GkLcG-1vas' in parents and modifiedTime > '2018-11-20T12:00:00'",
			spaces = 'drive',
			orderBy = 'modifiedTime desc',
			fields = 'nextPageToken, files(id, name)',
			pageToken = page_token
		).execute()
		
		for f in filesToBU.get('files', []):
			download_file(service, f.get('name'), f.get('id')) # Download
			
		page_token = filesToBU.get('nextPageToken', None)
		if page_token is None:
			break

if __name__ == '__main__':
	main()