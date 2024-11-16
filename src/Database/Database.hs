module Database.Database where

import           Config.Env     (databasePath)
import qualified Data.Vector    as V
import           Database.CSV
import           Database.Types (User)

write :: User -> IO ()
write user = writeCSVFile databasePath (V.singleton user)

read :: IO [User]
read = do
  out <- readCSVFile databasePath
  case out of
    Left _      -> error "missing users database"
    Right users -> return $ V.toList users
