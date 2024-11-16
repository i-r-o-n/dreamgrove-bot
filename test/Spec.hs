import qualified Database.CSVSpec
import qualified Database.TypesSpec
import qualified Minecraft.UsernameSpec
import           Test.Hspec

main :: IO ()
main = hspec $ do
  Database.TypesSpec.spec
  Database.CSVSpec.spec
  Minecraft.UsernameSpec.spec
