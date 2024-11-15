module Config.Env where

import qualified Data.Text     as T
import qualified Data.Text.IO  as TIO
import           Discord.Types
import           Text.Read     (readMaybe)

getToken :: IO T.Text
getToken = TIO.readFile "./.env/auth-token"

getGuildId :: IO GuildId
getGuildId = do
  gids <- readFile "./.env/guild-id"
  case readMaybe gids of
    Just g  -> pure g
    Nothing -> error "could not read guild id"

getTestChannelId :: IO ChannelId
getTestChannelId = do
  cid <- readFile "./.env/test-channel-id"
  case readMaybe cid of
    Just c  -> pure c
    Nothing -> error "cound not read test channel id"

databasePath :: FilePath
databasePath = "./data/database.csv"
