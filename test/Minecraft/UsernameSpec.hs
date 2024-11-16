module Minecraft.UsernameSpec where

import           Minecraft.Username
import           Test.Hspec

spec :: Spec
spec = describe "MinecraftUsername" $ do
    it "accepts valid usernames" $ do
      minecraftUsername "Player123" `shouldBe` Right (MinecraftUsername "Player123")
      minecraftUsername "Valid_Name" `shouldBe` Right (MinecraftUsername "Valid_Name")
      minecraftUsername "abc" `shouldBe` Right (MinecraftUsername "abc")

    it "rejects too short usernames" $ do
      minecraftUsername "ab"
        `shouldBe` Left "Minecraft username must be at least 3 characters"

    it "rejects too long usernames" $ do
      minecraftUsername "ThisUsernameIsWayTooLong"
        `shouldBe` Left "Minecraft username must be no more than 16 characters"

    it "rejects invalid characters" $ do
      minecraftUsername "Invalid!"
        `shouldBe` Left "Minecraft username can only contain letters, numbers, and underscore"
      minecraftUsername "No Spaces"
        `shouldBe` Left "Minecraft username can only contain letters, numbers, and underscore"
      minecraftUsername "No-Hyphens"
        `shouldBe` Left "Minecraft username can only contain letters, numbers, and underscore"
