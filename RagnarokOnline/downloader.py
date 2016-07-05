from urllib2 import urlopen, URLError, HTTPError
import os

patchlist = "http://twcdn.gnjoy.com.tw/ragnarok/patchinfo/patch2.txt"
patchfile = "http://twcdn.gnjoy.com.tw/ragnarok/patchfile/"

patchlistData = urlopen(patchlist).readlines()
listedList = []
unlistedList = []
for dataItem in patchlistData:
	dataItem = dataItem.strip()
	if '//' in dataItem:
		unlistedList.append(dataItem.split(' ')[1])
	else:
		listedList.append(dataItem.split(' ')[1])

		
#Listed list
listedPath = os.path.join(os.path.dirname(os.path.abspath(__file__)), "listed")
if not os.path.exists("listed"):
	os.makedirs("listed")
	
	
for item in listedList:
	localPath = os.path.join(listedPath, item)
	if os.path.isfile(localPath):
		print "[-] File Existed: " + item
		continue
	try:
		file = urlopen(patchfile + item)
		print "[+] Downloading listed file: " + item
		with open(localPath, "wb") as localFile:
			localFile.write(file.read())
	except HTTPError, e:
		if e.code == 404:
			print "[x] File Not Found!! " + item
	except URLError, e:
		print "URL Error:", e.reason, item

		
#Listed list
unlistedPath = os.path.join(os.path.dirname(os.path.abspath(__file__)), "unlisted")
if not os.path.exists("unlisted"):
	os.makedirs("unlisted")
	
for item in unlistedList:
	localPath = os.path.join(unlistedPath, item)
	if os.path.isfile(localPath):
		print "[-] File Existed: " + item
		continue
	try:
		file = urlopen(patchfile + item)
		print "[+] Downloading unlisted file: " + item
		with open(os.path.join(unlistedPath, item), "wb") as localFile:
			localFile.write(file.read())
	except HTTPError, e:
		if e.code == 404:
			print "[x] File Not Found!! " + item
	except URLError, e:
		print "URL Error:", e.reason, item
