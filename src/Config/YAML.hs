{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Config.YAML where

import           Control.Exception (catch)
import qualified Data.Text         as T
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

readYamlFile :: FilePath -> IO (Either ParseException Config)
readYamlFile path = decodeFileEither path `catch` handleError
 where
  handleError e = return $ Left e

writeYamlFile :: FilePath -> Config -> IO ()
writeYamlFile = encodeFile

example :: IO ()
example = do
  -- Create sample config
  let config =
        Config
          { serverName = "test-server"
          , port = 8080
          , features = ["auth", "logging", "metrics"]
          }

  -- Write to file
  writeYamlFile "config.yaml" config

  -- Read from file
  result <- readYamlFile "config.yaml"
  case result of
    Right cfg -> putStrLn $ "Successfully read config: " ++ show cfg
    Left err  -> putStrLn $ "Error reading config: " ++ show err
