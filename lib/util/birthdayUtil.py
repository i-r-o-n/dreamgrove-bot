import discord

import datetime
import dateutil.parser

import sys
from pprint import pprint

#sys.path.append("c:\\Users\\alexa\\OneDrive\\Documents\\Coding\\python\\Dreamgrove Bot")

from lib.util.fileWriter import FileWriter


fileName = "birthdays"


def parseDate(dateInput: str) -> datetime.datetime:
    return dateutil.parser.parse(dateInput)


def addDay(user: discord.Member.id, date: datetime.datetime) -> None:
    data = FileWriter.read(fileName)
    data[str(user)] = int(datetime.datetime.timestamp(date))
    FileWriter.write(data, fileName)


def removeDay(user: discord.Member.id) -> None:
    data = FileWriter.read(fileName)
    data.pop(str(user))
    FileWriter.write(data, fileName)


def readDay(user: discord.Member.id) -> str:
    return str(datetime.date.fromtimestamp(FileWriter.read(fileName)[str(user)]).strftime("%A %d. %B %Y"))
