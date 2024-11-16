{-# LANGUAGE DeriveGeneric #-}

module Database.Types where

import           Data.Csv
import           Database.MonthDay  (MonthDay)
import           GHC.Generics
import           Minecraft.Username (MinecraftUsername, minecraftUsername)

data User = User
  { discord   :: !String
  , minecraft :: !MinecraftUsername
  , birthday  :: !MonthDay
  }
  deriving (Generic, Show, Eq)

user :: String -> String -> MonthDay -> Either String User
user discord minecraft birthday = do
  mc <- minecraftUsername minecraft
  Right $ User discord mc birthday

-- for CSV conversion
instance FromNamedRecord User
instance ToNamedRecord User
instance DefaultOrdered User
