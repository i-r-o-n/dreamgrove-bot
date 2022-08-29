import datetime
import dateutil.parser

import sys
from pprint import pprint

#sys.path.append("c:\\Users\\alexa\\OneDrive\\Documents\\Coding\\python\\Dreamgrove Bot")

from lib.util.fileWriter import FileWriter


fileName = "birthdays"


def parseDate(dateInput: str) -> datetime.datetime:
    return dateutil.parser.parse(dateInput)


def addDay(name: str, date: datetime.datetime) -> None:
    data = FileWriter.read(fileName)
    # if name in data:
    #     data.update()
    data[name] = int(datetime.datetime.timestamp(date))
    FileWriter.write(data, fileName)

#keyerror here!
def removeDay(name: str) -> None:
    data = FileWriter.read(fileName)
    data.pop(name)
    FileWriter.write(data, fileName)


def readDay(name: str) -> str:
    return str(datetime.date.fromtimestamp(FileWriter.read(fileName)[name]).strftime("%A %d. %B %Y"))


#print(readDay("iron#1337"))