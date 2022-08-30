from discord.ext import commands

class Error(commands.Cog):
    def __init__(self, bot):
        self.bot = bot


    @commands.Cog.listener()
    async def on_command_error(self, ctx, error):
        if isinstance(error, commands.MissingRequiredArgument):
            await ctx.send('**`ERROR`** - Generic | Missing Required Argument')
        if isinstance(error, commands.CommandNotFound):
            await ctx.send('**`ERROR`** - Generic | Command Not Found')
        if isinstance(error, commands.BadArgument):
            await ctx.send('**`ERROR`** - Generic | Bad Argument')



def setup(bot):
    bot.add_cog(Error(bot))