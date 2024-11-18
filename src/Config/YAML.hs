{-# LANGUAGE OverloadedStrings #-}

module Config.YAML where

import           Config.Types
import           Control.Exception (catch)
import           Data.Yaml



--decodeFile

readFile :: FilePath -> IO (Either ParseException Config)
readFile = decodeFileEither
-- readFile path = decodeFileEither path `catch` handleError
--  where
--   handleError e = return $ Left e

--encodeFile

writeFile :: FilePath -> Config -> IO ()
writeFile = encodeFile


