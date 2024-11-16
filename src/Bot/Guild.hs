module Bot.Guild where

import           Config.Env       (getGuildId)
import           Discord
import qualified Discord.Requests as R
import           Discord.Types
import           UnliftIO

getMember :: UserId -> DiscordHandler (Either RestCallErrorCode GuildMember)
getMember uid = do
  gid <- liftIO getGuildId
  restCall $ R.GetGuildMember gid uid

getRoles :: DiscordHandler (Either RestCallErrorCode [Role])
getRoles = do
  gid <- liftIO getGuildId
  restCall $ R.GetGuildRoles gid
