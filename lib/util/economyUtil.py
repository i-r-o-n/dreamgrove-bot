import discord

from lib.util.fileWriter import FileWriter

fileName = "economy"


def addRoleMoney(role: discord.Role, amt: float) -> None:
    for user in role.members:
        addMoney(user, amt)


def addMoney(user: discord.Member.id, amt: float) -> None:
    data = FileWriter.read(fileName)
    data[str(user)] += amt
    FileWriter.write(data, fileName)


def removeMoney(user: discord.Member.id, amt: float) -> None:
    data = FileWriter.read(fileName)
    data[str(user)] -= amt
    FileWriter.write(data, fileName)


def readMoney(user: discord.Member.id) -> str:
    return FileWriter.read(fileName)[str(user)]