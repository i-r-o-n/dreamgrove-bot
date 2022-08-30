import discord
from discord.ext import commands

from lib.util import economyUtil


class Economy(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @commands.command(name="collect", aliases=["coll"])
    @commands.guild_only()
    async def collectIncome(self, ctx):
        embed = discord.Embed(title='\uFEFF', description="collected role income.", color=discord.Color.dark_green)
        
        embed.add_field(name='\uFEFF', value=f"{parsedDate}")

        await ctx.send(content=None, embed=embed)


    @commands.command(name="pay", aliases=['p'])
    @commands.guild_only()
    async def pay(self, ctx, member: discord.Member, amt: float):
        if member.id == ctx.author.id:
            await ctx.send("you cannot pay yourself.")
            #return 0 #do i need this return?
        authorBalance = float(economyUtil.readMoney(member.id))
        if authorBalance < amt:
            await ctx.send("you have insufficient")




    @commands.command(name="balance", aliases=["bal"])
    @commands.guild_only()
    async def balance(self, ctx, member: discord.Member, amt: float):
        pass


    @commands.command(name="leaderboard", aliases=["lb"])
    @commands.guild_only()
    async def leaderboard(self, ctx):
        pass


def setup(bot):
    bot.add_cog(Economy(bot))