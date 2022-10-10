import discord

from lib.util.fileWriter import FileWriter

fileName = "economy"

balancesDir = "userBalances"

def addRoleMoney(role: discord.Role, amt: float) -> None:
    for user in role.members:
        addMoney(user, amt)


def initializeAccount(user: discord.Member.id) -> None:
    data = FileWriter.read(fileName)
    data[balancesDir][str(user)] = 0
    FileWriter.write(data, fileName)


def addMoney(user: discord.Member.id, amt: float) -> None:
    data = FileWriter.read(fileName)
    data[balancesDir][str(user)] += amt
    FileWriter.write(data, fileName)


def removeMoney(user: discord.Member.id, amt: float) -> None:
    data = FileWriter.read(fileName)
    data[balancesDir][str(user)] -= amt
    FileWriter.write(data, fileName)


def readMoney(user: discord.Member.id) -> str:
    return FileWriter.read(fileName)[balancesDir][str(user)]
    