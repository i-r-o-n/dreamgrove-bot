import discord
from discord.ext import commands

from lib.util import economyUtil

currencyLabel = "\U0001F343"

class Economy(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @commands.command(name="collect", aliases=["coll"])
    @commands.guild_only()
    async def collectIncome(self, ctx):
        embed = discord.Embed(title='\uFEFF', description="collected role income.", color=discord.Color.dark_green)
        
        embed.add_field(name='\uFEFF', value="")

        await ctx.send(content=None, embed=embed)


    @commands.command(name="pay", aliases=["transfer"])
    @commands.guild_only()
    async def pay(self, ctx, member: discord.Member, amt: float):
        if member.id == ctx.author.id:
            await ctx.send("you cannot pay yourself.")
            return 0
        try:
            if float(economyUtil.readMoney(ctx.author.id)) < amt:
                await ctx.send("you have insufficient funds.")
                return 0
        except KeyError:
            economyUtil.initializeAccount(ctx.author.id)
            await ctx.send("just opened an account for you.")

        economyUtil.removeMoney(ctx.author.id, amt)

        try:
            economyUtil.addMoney(member.id, amt)
        except KeyError:
            await ctx.send("just opened an account for the recipient.")
            economyUtil.initializeAccount(member.id)
            economyUtil.addMoney(member.id, amt)

        await ctx.send(f"sent {currencyLabel}`{amt}` to {member.mention}.")

    @pay.error
    async def payError(self, ctx, error):
        if isinstance(error, commands.MemberNotFound):
            await ctx.send("could not find that member.")
        if isinstance(error, commands.MissingRequiredArgument):
            await ctx.send("your payment is a required argument.")




    @commands.command(name="balance", aliases=["bal"])
    @commands.guild_only()
    async def balance(self, ctx, member: discord.Member=None):
        if not member:
            member = ctx.author
        embed = discord.Embed(description="**balance:**", color=discord.Color.dark_green())
        try:
            embed.add_field(name='\uFEFF', value=f"{currencyLabel}`{economyUtil.readMoney(member.id)}`")
        except KeyError:
            economyUtil.initializeAccount(member.id)
            embed.add_field(name='\uFEFF', value="just opened an account for you.")
        await ctx.send(content=None, embed=embed)


    @commands.command(name="leaderboard", aliases=["lb"])
    @commands.guild_only()
    async def leaderboard(self, ctx):
        pass


def setup(bot):
    bot.add_cog(Economy(bot))