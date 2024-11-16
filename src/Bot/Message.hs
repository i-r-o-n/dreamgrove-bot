module Bot.Message where

import qualified Data.Text                     as T
import           Discord
import           Discord.Internal.Rest.Channel (ChannelRequest)
import qualified Discord.Requests              as R
import           Discord.Types

messageStartsWith :: T.Text -> Message -> Bool
messageStartsWith s = (s `T.isPrefixOf`) . T.toLower . messageContent

messageContains :: T.Text -> Message -> Bool
messageContains s = (s `T.isInfixOf`) . T.toLower . messageContent

fromBot :: Message -> Bool
fromBot = userIsBot . messageAuthor

sendMessage :: ChannelId -> T.Text -> ChannelRequest Message
sendMessage = R.CreateMessage

editMessage :: (T.Text -> T.Text) -> Message -> ChannelRequest Message
editMessage f m =
  R.EditMessage
    (messageChannelId m, messageId m)
    (def{R.messageDetailedContent = f $ messageContent m})

-- isPing :: Message -> Bool
-- isPing = ("ping" `T.isPrefixOf`) . T.toLower . messageContent
