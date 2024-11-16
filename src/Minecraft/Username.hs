{-# LANGUAGE DeriveGeneric #-}

module Minecraft.Username where

import           Data.Char (isAlphaNum)
import           Data.Csv

newtype MinecraftUsername = MinecraftUsername String
  deriving (Show, Eq)

-- Smart constructor for MinecraftUsername
minecraftUsername :: String -> Either String MinecraftUsername
minecraftUsername name
  | length name < 3 =
      Left "Minecraft username must be at least 3 characters"
  | length name > 16 =
      Left "Minecraft username must be no more than 16 characters"
  | not (all isValidChar name) =
      Left "Minecraft username can only contain letters, numbers, and underscore"
  | otherwise =
      Right $ MinecraftUsername name
 where
  isValidChar c = isAlphaNum c || c == '_'

-- CSV conversion for MinecraftUsername
instance FromField MinecraftUsername where
  parseField s = do
    str <- parseField s
    case minecraftUsername str of
      Right username -> pure username
      Left err       -> fail err

instance ToField MinecraftUsername where
  toField (MinecraftUsername s) = toField s
