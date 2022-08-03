import json
import traceback
import os

#os.chdir("..")

import discord
from discord.ext import commands

secrets = json.load(open("secrets.json"))

gameActivity = "dg.help | Official bot of the Dreamgrove discord server!"

initial_extensions = [
    "cogs.general",
    #"cogs.birthday"
]

def getPrefix(bot, message):
    prefixes = ["dg."]
    if not message.guild: 
        return ""
    return commands.when_mentioned_or(*prefixes)(bot, message)


bot = commands.Bot(
    command_prefix = getPrefix, 
    description="Dreamgrove Guild Bot")


if __name__ in "__main__":
    for extension in initial_extensions:
        bot.load_extension(extension)

@bot.event
async def on_ready() -> None:
    print("Logged in as:")
    print(f"user: {bot.user.name}\nid: {bot.user.id}")
    print(f"Discord.py Version: {discord.__version__}")
    await bot.change_presence(activity=discord.Game(name=gameActivity, type=1))
    print("Successfully logged in and booted.")


bot.run(
    secrets["bot_token"],
    bot=True,
    reconnect=True)