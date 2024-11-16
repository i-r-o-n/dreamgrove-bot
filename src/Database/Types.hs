{-# LANGUAGE DeriveGeneric #-}

module Database.Types where

import           Data.Csv
import           Database.MonthDay  (MonthDay, monthDay)
import           GHC.Generics
import           Minecraft.Username (MinecraftUsername, minecraftUsername)

data User = User
  { discord   :: !String
  , minecraft :: !MinecraftUsername
  , birthday  :: !MonthDay
  }
  deriving (Generic, Show, Eq)

user :: String -> String -> MonthDay -> Either String User
user d m b = do
  mc <- minecraftUsername m
  Right $ User d mc b

user' :: String -> String -> (Int, Int) -> Either String User
user' dc mcUsr (month, day) = do
  mc <- minecraftUsername mcUsr
  bday <- maybe (Left "Invalid birthday date") Right (monthDay month day)
  Right $ User dc mc bday

-- for CSV conversion
instance FromNamedRecord User
instance ToNamedRecord User
instance DefaultOrdered User
