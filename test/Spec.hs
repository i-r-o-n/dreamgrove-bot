{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

import           Control.Exception (SomeException, catch)
import           Database.Types    (User (..))
import           System.Directory  (removeFile)
import           Test.Hspec

cleanup :: FilePath -> IO ()
cleanup file = removeFile file `catch` \(_ :: SomeException) -> return ()

main :: IO ()
main = hspec $ do
  describe "User" $ do
    -- let testUser =
    --       User $
    --         def
    --           { discordUserName = "Discord Name"
    --           , minecraftUserName = "MinecraftName"
    --           }

    let testUser = User "Discord Name" "MinecraftName"

    it "creates user correctly" $ do
      discordUserName testUser `shouldBe` "Discord Name"
      minecraftUserName testUser `shouldBe` "MinecraftName"
