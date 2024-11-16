-- for testing
{-# OPTIONS_GHC -Wno-name-shadowing #-}

module Database.TypesSpec where

import           Data.Maybe
import           Database.MonthDay
import           Database.Types
import           Minecraft.Username
import           Test.Hspec

spec :: Spec
spec = describe "User" $ do
  let minecraftUser = case minecraftUsername "MinecraftName" of
        Right name -> name
        Left err   -> error err

  let testUser = User "Discord Name" minecraftUser (fromJust $ monthDay 12 31)

  it "creates user correctly" $ do
    discord testUser `shouldBe` "Discord Name"
    let (MinecraftUsername minecraftUser) = minecraft testUser
    minecraftUser `shouldBe` "MinecraftName"
    birthday testUser `shouldBe` fromJust (monthDay 12 31)
