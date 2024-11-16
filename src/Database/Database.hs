module Database.Database where

import           Config.Env         (databasePath)
import           Data.Maybe
import qualified Data.Vector        as V
import           Database.CSV
import           Database.MonthDay
import           Database.Types     (User (User), discord)
import           Minecraft.Username

write :: User -> IO ()
write user = writeCSVFile databasePath (V.singleton user)

append :: User -> IO Bool
append = _

remove :: User -> IO Bool
remove = _

update :: User -> IO Bool
update = _

getDiscord :: String -> IO (Either String User)
getDiscord discordName = do
  users <- Database.Database.read
  pure $ case filter (\user -> discord user == discordName) users of
    [user] -> Right user
    []     -> Left "User not found"
    _      -> Left "Multiple users found"

read :: IO [User]
read = do
  out <- readCSVFile databasePath
  case out of
    Left _      -> error "Missing users database"
    Right users -> return $ V.toList users

testUser :: User
testUser =
  User "Discord Name" minecraftUser (fromJust $ monthDay 12 31)
 where
  minecraftUser = case minecraftUsername "MinecraftName" of
    Right name -> name
    Left err   -> error err
