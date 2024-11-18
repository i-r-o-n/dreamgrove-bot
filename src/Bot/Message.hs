{-# LANGUAGE OverloadedStrings #-}

module Bot.Message where

import           Data.Text
import           Discord
import           Discord.Internal.Rest.Channel (ChannelRequest)
import qualified Discord.Requests              as R
import           Discord.Types

messageStartsWith :: Text -> Message -> Bool
messageStartsWith s = (s `isPrefixOf`) . toLower . messageContent

messageContains :: Text -> Message -> Bool
messageContains s = (s `isInfixOf`) . toLower . messageContent

fromBot :: Message -> Bool
fromBot = userIsBot . messageAuthor

createMessage :: ChannelId -> Text -> ChannelRequest Message
createMessage = R.CreateMessage

editMessage :: (Text -> Text) -> Message -> ChannelRequest Message
editMessage f m =
  R.EditMessage
    (messageChannelId m, messageId m)
    (def{R.messageDetailedContent = f $ messageContent m})

pingUserMessage :: ChannelId -> (Text -> Text) -> UserId -> ChannelRequest Message
pingUserMessage cid f uid = R.CreateMessage cid $ pingUser f uid

pingUser :: (Text -> Text) -> UserId -> Text
pingUser f uid = f $ "<@" <> pack (show uid) <> ">"

-- pingUserPrepend :: Text -> UserId -> Text
-- pingUserPrepend t = pingUser (<> t)
--
-- pingUserAppend :: Text -> UserId -> Text
-- pingUserAppend t = pingUser (t <>)

-- isPing :: Message -> Bool
-- isPing = ("ping" `isPrefixOf`) . toLower . messageContent
