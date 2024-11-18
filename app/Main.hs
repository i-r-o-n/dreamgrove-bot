{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text.IO  as TIO

import           UnliftIO      (liftIO)
-- import           UnliftIO.Concurrent

import           Discord
import           Discord.Types

import           Bot.Handlers  (eventHandler, startHandler)
import           Config.Env    (getGuildId, getTestChannelId, getToken)

main :: IO ()
main = pingpongExample

-- Replies "pong" to every message that starts with "ping"
pingpongExample :: IO ()
pingpongExample = do
  tok <- getToken
  serverid <- getGuildId
  channelid <- getTestChannelId
  -- logModule <- createLoggingModule cid

  err <-
    runDiscord
      def
        { discordToken = tok
        , discordOnStart = startHandler serverid channelid
        , discordOnEnd = liftIO $ {- threadDelay (round (0.4 * 10 ^ 6)) >> -} putStrLn "Ended"
        , discordOnEvent = eventHandler
        , discordOnLog = TIO.putStrLn {- >> TIO.putStrLn "" -}
        , discordGatewayIntent =
            def
              { gatewayIntentMembers = True
              , gatewayIntentPresences = True
              }
        }

  -- only reached on an unrecoverable error; put normal cleanup code in discordOnEnd
  TIO.putStrLn err
