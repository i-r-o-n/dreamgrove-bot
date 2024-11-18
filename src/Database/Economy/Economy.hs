module Database.Economy.Economy where

import           Discord.Types

-- add/remove money to user
addToUser :: User -> Int -> IO Bool
addToUser = _

removeFromUser :: User -> Int -> IO Bool
removeFromUser = _

-- add/remove money to role
addToRole :: Role -> Int -> IO Bool
addToRole = _

removeFromRole :: Role -> Int -> IO Bool
removeFromRole = _

