{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}

module Database.CSV where

import           Config.Env           (databasePath)
import           Control.Exception    (catch)
import qualified Data.ByteString.Lazy as BL
import           Data.Csv
import qualified Data.Vector          as V
import           Database.Types
import           GHC.Generics

-- Read CSV file with headers
readCSVFile :: FilePath -> IO (Either String (V.Vector User))
readCSVFile path = do
  contents <- BL.readFile path `catch` handleError
  return (snd <$> decodeByName contents)
 where
  handleError :: IOError -> IO BL.ByteString
  handleError _ = return "" -- Return empty ByteString on error

-- Write CSV file with headers
writeCSVFile :: FilePath -> V.Vector User -> IO ()
writeCSVFile path persons =
  do
    BL.writeFile path $ encodeDefaultOrderedByName (V.toList persons)
    `catch` handleError
 where
  handleError :: IOError -> IO ()
  handleError e = putStrLn $ "Error writing file: " ++ show e

-- Example usage function
example :: IO ()
example = do
  -- Create sample data
  let sampleData =
        V.fromList
          [ User "discord_username1" "mc_username2" -- (fromGregorian 2000 1 1)
          , User "discord_username2" "mc_username2" -- (fromGregorian 2000 12 31)
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

-- read CSV without headers
readCSVNoHeaders :: FilePath -> IO (Either String (V.Vector (V.Vector String)))
readCSVNoHeaders path = do
  contents <- BL.readFile path `catch` handleError
  return $ decode NoHeader contents
 where
  handleError :: IOError -> IO BL.ByteString
  handleError _ = return ""

-- write CSV without headers
writeCSVNoHeaders :: FilePath -> V.Vector (V.Vector String) -> IO ()
writeCSVNoHeaders path rows =
  do
    BL.writeFile path $ encode (V.toList $ V.map V.toList rows)
    `catch` handleError
 where
  handleError :: IOError -> IO ()
  handleError e = putStrLn $ "Error writing file: " ++ show e
