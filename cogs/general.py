from cmath import cos
import discord
from discord.ext import commands

from matplotlib import pyplot as plt
import numpy as np

from lib.util import birthdayUtil, statusUtil


class General(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

# commands

    @commands.command(name='ping', aliases=['p'])
    @commands.guild_only()
    async def ping(self, ctx):
        ms = (f"Pong! {round(self.bot.latency * 1000)}ms")
        embed = discord.Embed(
            color=discord.Color.blurple(),
            description=ms
        )
        await ctx.trigger_typing()
        await ctx.send(embed=embed)


    @commands.command(name='perms', aliases=["perms_for", "permissions"])
    @commands.guild_only()
    async def check_permissions(self, ctx, *, member: discord.Member=None):
        if not member:
            member = ctx.author
        perms = '\n'.join(perm for perm, value in member.guild_permissions if value)
        embed = discord.Embed(title="Permissions for:", description=ctx.guild.name, color=member.color)
        embed.set_author(icon_url=member.avatar_url, name=str(member))
        embed.add_field(name='\uFEFF', value=perms)
        await ctx.send(content=None, embed=embed)
    

    @commands.command(name='birthday', aliases=['bday', 'bd'])
    @commands.guild_only()
    async def birthday(self, ctx, *, member: discord.Member=None):
        if isinstance(member, commands.BadArgument):
            await ctx.send("I do not understand that argument.")

        if not member:
            member = ctx.author
        embed = discord.Embed(title=f"{member}", description="birthday", color=member.color)
        
        try:
            day = birthdayUtil.readDay(str(member.id))
            embed.add_field(name='\uFEFF', value=day)
        except KeyError:
            embed.add_field(name='\uFEFF', value="could not find a birthday for this user.")

        embed.add_field(name='\uFEFF', value="\nuse the command `birthdayset` to set your birthday.")
        await ctx.send(content=None, embed=embed)


    @commands.command(name='birthdayset', aliases=['bdayset', 'bds'])
    @commands.guild_only()
    async def birthdaySet(self, ctx, *, date: str):
        if isinstance(date, commands.MissingRequiredArgument):
            await ctx.send("your birthdate is a required argument.")
        
        embed = discord.Embed(title=f"{ctx.author}", description="birthday has been set to", color=ctx.author.color)
        
        if date == "remove":
            try:
                birthdayUtil.removeDay(str(ctx.author.id))
                embed.add_field(name='\uFEFF', value=f"removed your birthday from the registry.")
            except KeyError:
                embed.add_field(name='\uFEFF', value=f"could not find your birthday in the registry.")
        else:
            parsedDate = birthdayUtil.parseDate(date)
            embed.add_field(name='\uFEFF', value=f"{parsedDate}")
            birthdayUtil.addDay(ctx.author.id, parsedDate)
            embed.add_field(name='\uFEFF', value=f"use `birthdayset remove` to remove your birthday from the registry.", inline=False)
        await ctx.send(content=None, embed=embed)


    @commands.command(name='statuses', aliases=['sts'])
    @commands.guild_only()
    async def userStatuses(self, ctx):
        statuses: dict = statusUtil.getMemberStatuses(ctx.guild)
        
        data = np.array(list(statuses.values()))
        labels = list(statuses.keys())
        colors = [statusUtil.statusColor(color) for color in statuses.keys()]

        plt.pie(data, labels = labels, colors = colors)
        plt.savefig("statusImg.png", transparent = True)
        plt.close()
        image = discord.File("statusImg.png")
        await ctx.send(file=image)

# listeners

    @commands.Cog.listener()
    async def on_member_join(self, member):
        await member.send(f"Hey {member.mention}!\nplease introduct yourself in the meet-the-members channel in the Dreamgrove discord!")


def setup(bot):
    bot.add_cog(General(bot))