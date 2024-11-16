module Bot.Scheduler where

import           Control.Monad.IO.Class
import           Data.Time.Clock.POSIX  (POSIXTime, getPOSIXTime)
import           UnliftIO.Concurrent

newtype Timestamp = Timestamp POSIXTime
  deriving (Eq, Show, Ord)

schedule :: Timestamp -> IO ()
schedule = _

getCurrentTimestamp :: IO Timestamp
getCurrentTimestamp = Timestamp <$> getPOSIXTime

delaySeconds :: (MonadIO m) => Int -> m ()
delaySeconds x = threadDelay (x * (10 ^ (6 :: Int))) -- microseconds

-- TODO: implement an async action caller by timestamp,
-- store scheduled actions in persistent db in case bot goes down
