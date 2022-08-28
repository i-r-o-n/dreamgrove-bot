import datetime
import dateutil.parser

import sys
from pprint import pprint

sys.path.append("c:\\Users\\alexa\\OneDrive\\Documents\\Coding\\python\\Dreamgrove Bot")

from lib.util.fileWriter import FileWriter


fileName = "birthdays"


def parseDate(dateInput: str) -> datetime.datetime:
    return dateutil.parser.parse(dateInput)


def addDay(data: dict, name: str, date: int) -> dict:
    data[name] = date
    return data


def removeDay(data: dict, name: str) -> dict:
    data.pop(name)
    return data


def readDay(name: str) -> str:
    return str(datetime.date.fromtimestamp(FileWriter.read(fileName)[name]).strftime("%A %d. %B %Y"))


print(readDay("usernameA"))