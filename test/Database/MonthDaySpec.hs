module Database.MonthDaySpec where

import           Data.Maybe
import           Database.MonthDay
import           Test.Hspec

spec :: Spec
spec = describe "MonthDay" $ do
  let md1 = fromJust $ monthDay 1 1
  let md2 = fromJust $ monthDay 12 31

  it "formats to string" $ do
    formatMonthDay md1 `shouldBe` "January 1"
    formatMonthDay md2 `shouldBe` "December 31"

  it "formats to string numeric" $ do
    formatMonthDayNumeric md1 `shouldBe` "01-01"
    formatMonthDayNumeric md2 `shouldBe` "12-31"

  it "parses from string" $ do
    parseMonthDay "1-1" `shouldBe` monthDay 1 1
    parseMonthDay "01-01" `shouldBe` monthDay 1 1
    parseMonthDay "12-31" `shouldBe` monthDay 12 31

  it "handles some malformed dates" $ do
    case monthDay 0 0 of
      Just _  -> expectationFailure "Should have failed on malformed data"
      Nothing -> return ()
