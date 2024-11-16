{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

import           Control.Exception  (SomeException, catch)
import           Data.Either
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

main :: IO ()
main = hspec $ do
  describe "MinecraftUsername" $ do
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

  describe "User" $ do
    let minecraftUser = case minecraftUsername "MinecraftName" of
          Right name -> name
          Left err   -> error err

    let testUser = User "Discord Name" minecraftUser (fromJust $ monthDay 12 31)

    it "creates user correctly" $ do
      discord testUser `shouldBe` "Discord Name"
      let (MinecraftUsername minecraftUser) = minecraft testUser
      minecraftUser `shouldBe` "MinecraftName"
      birthday testUser `shouldBe` fromJust (monthDay 12 31)

  describe "CSV Operations" $ do
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

{-
-- Example usage function
example :: IO ()
example = do
  -- Create sample data
  let sampleData =
        V.fromList
          [ User "discord_username1" "mc_username2" (fromJust $ monthDay 1 1)
          , User "discord_username2" "mc_username2" (fromJust $ monthDay 12 31)
          ]

  -- Write to file
  writeCSVFile databasePath sampleData
  putStrLn "Written to people.csv"

  -- Read from file
  -- result <- readCSVFile databasePath
  -- case result of
  --   Right d -> do
  --     putStrLn "Successfully read database:"
  --     V.mapM_ print d
  --   Left err -> putStrLn $ "Error reading CSV: " ++ err

  readCSVFile databasePath >>= \case
    Right d -> do
      putStrLn "Successfully read database:"
      V.mapM_ print d
    Left err -> putStrLn $ "Error reading CSV: " ++ err

      -}
