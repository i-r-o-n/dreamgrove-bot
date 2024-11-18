module Config.YAMLSpec where

import           Test.Hspec

spec :: Spec
spec = describe "YAML Config Operations" $ do

{-
example :: IO ()
example = do
  let config =
        Config
          { serverName = "test-server"
          , port = 8080
          , features = ["auth", "logging", "metrics"]
          }

  writeYamlFile "config.yaml" config

  result <- readYamlFile "config.yaml"
  case result of
    Right cfg -> putStrLn $ "Successfully read config: " ++ show cfg
    Left err  -> putStrLn $ "Error reading config: " ++ show err
-}
