module Bot.Message where

import qualified Data.Text     as T
import           Discord.Types

messageContains :: T.Text -> Message -> Bool
messageContains s = (s `T.isPrefixOf`) . T.toLower . messageContent

fromBot :: Message -> Bool
fromBot = userIsBot . messageAuthor

-- isPing :: Message -> Bool
-- isPing = ("ping" `T.isPrefixOf`) . T.toLower . messageContent
