#!/usr/bin/env python3
# Author: https://github.com/BallowTK

import json
import os
import sys
import time
from math import floor

import dbus
import requests

session_bus = dbus.SessionBus()


def spotify():
    def connect():
        try:
            spotify_bus = session_bus.get_object("org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2")
            spotify_properties = dbus.Interface(spotify_bus, "org.freedesktop.DBus.Properties")
            return spotify_properties
        except dbus.exceptions.DBusException:
            print("No players found", flush=True)
            return False

    spotify_properties = connect()
    DISCONNECTED = spotify_properties == False
    TIMEOUT = 1.5
    while DISCONNECTED:
        spotify_properties = connect()
        DISCONNECTED = spotify_properties == False
        if DISCONNECTED:
            time.sleep(TIMEOUT)
    return spotify_properties


Control = "spotify"

Cover = "/tmp/cover.png"
bkpCover = os.path.expanduser("~/.config/eww/music.png")


def metadata():
    conn = spotify()
    try:
        return conn.Get("org.mpris.MediaPlayer2.Player", "Metadata")
    except dbus.exceptions.DBusException:
        return False


def trackID():
    trackid = metadata().get("mpris:trackid", "No Track ID")
    if trackid != "No Track ID":
        trackid = trackid.replace("/com/spotify/track/", "")
    return trackid


def status():
    conn = spotify()
    try:
        res = conn.Get("org.mpris.MediaPlayer2.Player", "PlaybackStatus")
        return res
    except dbus.exceptions.DBusException:
        return "No players found"


def cover():
    albumArtUrl = metadata().get("mpris:artUrl")
    if albumArtUrl:
        albumArtUrl = albumArtUrl.replace("open.spotify.com", "i.scdn.co")
        response = requests.get(albumArtUrl)
        if response.status_code == 200:
            with open(Cover, "wb") as f:
                f.write(response.content)
            return Cover
        else:
            return bkpCover


def statusicon():
    if status() == "Playing":
        icon = ""
    elif status() == "Paused":
        icon = ""
    else:
        icon = ""
    print(icon, flush=True)


def position_milli():
    conn = spotify()
    return int(conn.Get("org.mpris.MediaPlayer2.Player", "Position") / 1000)


########################## Lyrics ##########################
def lyrics(numOfLines):
    RANGE = 300
    API = "https://spotify-lyric-api.herokuapp.com"
    while True:
        ACTIVE = status() == "Playing"
        if ACTIVE:
            trackid = trackID()
            if trackid == "No Track ID":
                print(json.dumps(["No Lyrics: trackID not found"]), flush=True)
            lyrics = requests.get(f"{API}/?trackid={trackid}").json()
            if lyrics["error"] == False:
                prevIndex = 0
                prevTitle = ""
                PLAYING = True
                while PLAYING:
                    title = metadata().get("xesam:title")
                    # if the title is different from the previous one, reset PLAYING
                    if title != prevTitle:
                        PLAYING = False
                    prevTitle = title
                    currTimems = position_milli()
                    for i, lyric in enumerate(lyrics["lines"]):
                        if abs(currTimems - int(lyric["startTimeMs"])) < RANGE:
                            if i == len(lyrics["lines"]) - 1:
                                PLAYING = False
                            break
                    # turn the lines into a json list for eww
                    results = json.dumps([lyric["words"] for lyric in lyrics["lines"][i : i + numOfLines]])
                    if (i != prevIndex or prevIndex == 0) and results != json.dumps([""]):
                        prevIndex = i
                        print(results, flush=True)
            else:
                print(json.dumps(["No Lyrics: API Error"]), flush=True)


########################## Main Function ##########################
def main():
    command = sys.argv[1]
    # switch case in python
    match command:
        case "metadata":
            print(metadata())
        case "status":
            while True:
                print(status())
        case "position_milli":
            print(position_milli())
        case "trackID":
            print(trackID())
        case "cover":
            print(cover())
        case "statusicon":
            while True:
                statusicon()
        case "lyrics":
            numOfLines = sys.argv[2] if len(sys.argv) > 2 else 5
            lyrics(int(numOfLines))
        case _:
            print("Usage: python script.py [metadata|status|position_milli|trackID|cover|statusicon|lyrics]")
            sys.exit(1)


if __name__ == "__main__":
    main()
