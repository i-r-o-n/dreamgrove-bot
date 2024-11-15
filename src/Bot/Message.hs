module Bot.Message where

import qualified Data.Text     as T
import           Discord.Types

messageStartsWith :: T.Text -> Message -> Bool
messageStartsWith s = (s `T.isPrefixOf`) . T.toLower . messageContent

messageContains :: T.Text -> Message -> Bool
messageContains s = (s `T.isInfixOf`) . T.toLower . messageContent

fromBot :: Message -> Bool
fromBot = userIsBot . messageAuthor

-- isPing :: Message -> Bool
-- isPing = ("ping" `T.isPrefixOf`) . T.toLower . messageContent
