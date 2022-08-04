import discord
from discord.ext import commands

from .lib.util import birthdayUtil

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
        if not member:
            member = ctx.author
        embed = discord.Embed(title=f"{member}'s Birthday", description='\uFEFF', color=member.color)
        try:
            day = birthdayUtil.readDay(member)
            embed.add_field(name='\uFEFF', value=day)
        except KeyError:
            embed.add_field(name='\uFEFF', value="could not find a birthday for this user.")
        await ctx.send(content=None, embed=embed)

# listeners

    @commands.Cog.listener()
    async def on_member_join(self, member):
        await member.send(f"Hey {member.mention}!\nplease introduct yourself in the meet-the-members channel in the Dreamgrove discord!")


def setup(bot):
    bot.add_cog(General(bot))