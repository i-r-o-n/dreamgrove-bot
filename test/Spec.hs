import qualified Database.CSVSpec
import qualified Database.MonthDaySpec
import qualified Database.TypesSpec
import qualified Minecraft.UsernameSpec
import           Test.Hspec

main :: IO ()
main = hspec $ do
  Database.CSVSpec.spec
  Database.MonthDaySpec.spec
  Database.TypesSpec.spec
  Minecraft.UsernameSpec.spec
