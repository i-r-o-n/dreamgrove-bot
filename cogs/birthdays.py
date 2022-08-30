import discord
from discord.ext import commands

from lib.util import birthdayUtil


class Birthdays(commands.Cog):
    def __init__(self, bot):
        self.bot = bot
    
    
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
        embed = discord.Embed(title=f"{ctx.author}", description="birthday has been set to", color=ctx.author.color)
        
        if date == "remove":
            try:
                birthdayUtil.removeDay(ctx.author.id)
                embed.add_field(name='\uFEFF', value=f"removed your birthday from the registry.")
            except KeyError:
                embed.add_field(name='\uFEFF', value=f"could not find your birthday in the registry.")
        else:
            parsedDate = birthdayUtil.parseDate(date)
            embed.add_field(name='\uFEFF', value=f"{parsedDate}")
            birthdayUtil.addDay(ctx.author.id, parsedDate)
            embed.add_field(name='\uFEFF', value=f"use `birthdayset remove` to remove your birthday from the registry.", inline=False)
        await ctx.send(content=None, embed=embed)

    @birthdaySet.error
    async def birthdaySetError(self, ctx, error):
        if isinstance(error, commands.MissingRequiredArgument):
            await ctx.send("your birthdate is a required argument.")



def setup(bot):
    bot.add_cog(Birthdays(bot))