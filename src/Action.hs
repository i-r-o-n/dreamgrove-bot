module Action where

import           Discord
import qualified Discord.Requests as R
import           Discord.Types

{- | Given the test server and an action operating on a channel id, get the
first text channel of that server and use the action on that channel.
-}
actionWithDefaultChannel :: GuildId -> (ChannelId -> DiscordHandler a) -> DiscordHandler a
actionWithDefaultChannel testserverid f = do
  Right chans <- restCall $ R.GetGuildChannels testserverid
  (f . channelId) (head (filter isTextChannel chans))
 where
  isTextChannel :: Channel -> Bool
  isTextChannel ChannelText{} = True
  isTextChannel _             = False
