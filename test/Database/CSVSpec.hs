{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Database.CSVSpec where

import           Control.Exception  (SomeException, catch)
import           Data.Maybe
import qualified Data.Vector        as V
import           Database.CSV
import           Database.MonthDay
import           Database.Types     (User (..), user)
import           Minecraft.Username
import           System.Directory   (removeFile)
import           Test.Hspec

cleanup :: FilePath -> IO ()
cleanup file = removeFile file `catch` \(_ :: SomeException) -> return ()

spec :: Spec
spec = describe "CSV Operations" $ do
  let testFile = "test.csv"
  let testUsers = case sequence
        [ user "Discord 1" "Minecraft1" (fromJust $ monthDay 12 31)
        , user "Discord 2" "Minecraft2" (fromJust $ monthDay 1 15)
        ] of
        Right users -> V.fromList users
        Left err    -> error err

  after (\_ -> cleanup testFile) $ do
    it "writes and reads users correctly" $ do
      writeCSVFile testFile testUsers

      result <- readCSVFile testFile
      result `shouldBe` Right testUsers

    it "handles empty file correctly" $ do
      writeCSVFile testFile V.empty

      result <- readCSVFile testFile
      result `shouldBe` Right V.empty

    it "preserves all user fields" $ do
      writeCSVFile testFile testUsers
      result <- readCSVFile testFile
      case result of
        Right users -> do
          let firstUser = V.head users
          discord firstUser `shouldBe` "Discord 1"
          let (MinecraftUsername minecraftUser) = minecraft firstUser
          minecraftUser `shouldBe` "Minecraft1"
          birthday firstUser `shouldBe` fromJust (monthDay 12 31)
        Left err -> expectationFailure $ "Failed to read CSV: " ++ err

    it "handles malformed CSV data" $ do
      writeFile testFile "bad,csv,data\nwithout,proper,columns"
      result <- readCSVFile testFile
      case result of
        Left _  -> return ()
        Right _ -> expectationFailure "Should have failed on malformed data"

    it "handles missing file gracefully" $ do
      result <- readCSVFile "nonexistent.csv"
      case result of
        Left _  -> return ()
        Right _ -> expectationFailure "Should have failed on missing file"
