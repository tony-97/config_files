import shutil
import datetime
import uuid
import base64
import requests
import sqlite3
from bs4 import BeautifulSoup

URL = "https://www.zeepond.com/zeepond/giveaways/enter-a-competition"
HEADERS = {
        "user-agent" :
        "Mozilla/5.0 (X11; Linux x86_64; rv:93.0) Gecko/20100101 Firefox/93.0"
        }

BOOKMARK_FOLDER_TITLE           = "zeepond_giveaways"
GET_FOLDER_ID_QUERY             = "SELECT id FROM moz_bookmarks WHERE title = '%s';" % BOOKMARK_FOLDER_TITLE
CREATE_BOOKMARKS_FOLDER_QUERY   = "INSERT INTO moz_bookmarks (type,parent,title,guid) VALUES (2,2,'%s','%s');"
DELETE_PREVIOUS_BOOKMARKS_QUERY = "DELETE FROM moz_bookmarks WHERE parent = %d;"
CREATE_BOOKMARK_QUERY = "INSERT INTO moz_bookmarks (type,fk,parent,title) VALUES(1,%d,%d,'%s')"

IF_EXISTS_GUID_QUERY = "SELECT * FROM moz_bookmarks WHERE guid = '%s'"

URL_TITLE = "url_created_from_script_for_zeepond_giveaways"
REV_HOST  = "moc.dnopeez.www"
CREATE_URLS_QUERY = "INSERT INTO moz_places (url,title,rev_host) VALUES (?,?,?);"
DELETE_URLS_QUERY = "DELETE FROM moz_places WHERE title = '%s';" % URL_TITLE
GET_ALL_URLS_IDS  = "SELECT id FROM moz_places WHERE title = '%s';" % URL_TITLE

SQLITE_FILE = "/home/tony/.mozilla/firefox/sqr1f3uq.default-release/places.sqlite"

shutil.copy(SQLITE_FILE, SQLITE_FILE + datetime.datetime.now().strftime("%b-%d-%y-%H-%M-%S"))

def create_bookmarks_folder(cursor) :
    guid = base64.urlsafe_b64encode(uuid.uuid1().bytes).rstrip(b'=').decode('ascii')[:12]
    while cursor.execute(IF_EXISTS_GUID_QUERY % guid).fetchone() != None :
        guid = base64.urlsafe_b64encode(uuid.uuid1().bytes).rstrip(b'=').decode('ascii')[:12]
    cursor.execute(CREATE_BOOKMARKS_FOLDER_QUERY % (BOOKMARK_FOLDER_TITLE, guid))

con = sqlite3.connect(SQLITE_FILE)
cur = con.cursor()

#delete all previous giveaways
cur.execute(DELETE_URLS_QUERY)
zeepond_folder = cur.execute(GET_FOLDER_ID_QUERY).fetchone()
#if exists delete all bookmarks from zeepond folder
if not zeepond_folder == None :
    [folder_id] = zeepond_folder
    cur.execute(DELETE_PREVIOUS_BOOKMARKS_QUERY % folder_id)
#if not exists, create
else :
    create_bookmarks_folder(cur)

page = requests.get(URL, headers=HEADERS)
soup = BeautifulSoup(page.content, "html.parser")

giveaways_divs = soup.findAll("div", attrs={ "class": "bv-item-image" })
for giveaway_div in giveaways_divs :
    giveaway_a = giveaway_div.find("a")
    giveaway_url = "https://www.zeepond.com" + giveaway_a["href"]
    cur.execute(CREATE_URLS_QUERY, (giveaway_url, URL_TITLE, REV_HOST))

[parent_id] = cur.execute(GET_FOLDER_ID_QUERY).fetchone()

for [fk] in con.execute(GET_ALL_URLS_IDS) :
    con.execute(CREATE_BOOKMARK_QUERY % (fk, parent_id, URL_TITLE))

con.commit()
con.close()
