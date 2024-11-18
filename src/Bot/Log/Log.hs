module Bot.Log.Log where

import           Bot.Message   (createMessage)
import           Data.Text
import           Discord
import           Discord.Types

newtype LogModule = LogModule
  { logChannelId :: ChannelId
  }

createLoggingModule :: IO ChannelId -> IO LogModule
createLoggingModule getChannelId = LogModule <$> getChannelId

sendLogMessage :: LogModule -> Text -> DiscordHandler (Either RestCallErrorCode Message)
sendLogMessage m t = restCall $ createMessage (logChannelId m) t
