{-# LANGUAGE DeriveGeneric #-}

module Database.MonthDay where

import           Data.Csv
import           Data.Time.Calendar
import           Data.Time.Format
import           GHC.Generics       (Generic)
import           Text.Printf        (printf)

-- Day of the year
data MonthDay = MonthDay
  { month :: !Int -- 1-12
  , day   :: !Int -- 1-31
  }
  deriving (Eq, Generic, Show)

-- Compare MonthDays
instance Ord MonthDay where
  compare (MonthDay m1 d1) (MonthDay m2 d2) =
    compare (m1, d1) (m2, d2)

-- For CSV conversion
instance FromField MonthDay where
  parseField s = do
    str <- parseField s
    case parseMonthDay str of
      Just md -> pure md
      Nothing -> fail "Invalid MonthDay format"

instance ToField MonthDay where
  toField = toField . formatMonthDayNumeric

monthDay :: Int -> Int -> Maybe MonthDay
monthDay m d
  | m >= 1
      && m <= 12
      && d >= 1
      && d <= daysInMonth m =
      Just $ MonthDay m d
  | otherwise = Nothing
 where
  daysInMonth :: Int -> Int
  daysInMonth m'
    | m' == 2 = 29
    | m' `elem` [4, 6, 9, 11] = 30
    | otherwise = 31

-- Format MonthDay to String (e.g. "December 31")
formatMonthDay :: MonthDay -> String
formatMonthDay (MonthDay m d) =
  let monthName = formatTime defaultTimeLocale "%B" (fromGregorian 2000 m d)
   in monthName ++ " " ++ show d

-- Format MonthDay to numeric String (e.g. "12-31")
formatMonthDayNumeric :: MonthDay -> String
formatMonthDayNumeric (MonthDay m d) = printf "%02d-%02d" m d

-- Parse from String (e.g. "12-31")
parseMonthDay :: String -> Maybe MonthDay
parseMonthDay str = case break (== '-') str of
  (monthStr, '-' : dayStr) -> do
    m <- readMaybe monthStr
    d <- readMaybe dayStr
    monthDay m d
  _ -> Nothing
 where
  readMaybe :: String -> Maybe Int
  readMaybe s = case reads s of
    [(n, "")] -> Just n
    _         -> Nothing
