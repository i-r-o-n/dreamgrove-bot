{-# LANGUAGE DeriveGeneric #-}

module Database.Types where

import           Data.Csv
import           GHC.Generics

data User = User
  { discordUserName   :: !String
  , minecraftUserName :: !String
  -- , birthday          :: !Day
  }
  deriving (Generic, Show)

-- for CSV conversion
instance FromNamedRecord User
instance ToNamedRecord User
instance DefaultOrdered User
