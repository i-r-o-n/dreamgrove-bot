import discord
from discord.ext import commands

from matplotlib import pyplot as plt
import numpy as np

from lib.util import statusUtil


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


    # @bot.event
    # async def on_member_update(self, before, after):
    #     print("update")
        

def setup(bot):
    bot.add_cog(General(bot))