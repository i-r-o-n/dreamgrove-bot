{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Config.Types where

import qualified Data.Text    as T
import           Data.Yaml
import           GHC.Generics

data Config = Config
  { serverName :: T.Text
  , port       :: Int
  , features   :: [T.Text]
  }
  deriving (Show, Generic)

instance FromJSON Config
instance ToJSON Config
