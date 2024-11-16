{-# LANGUAGE OverloadedStrings #-}

module Bot.Handlers where

import           Control.Monad    (void, when)
import qualified Data.Text        as T

import           Bot.Scheduler
import           UnliftIO         (liftIO)

import           Discord
import qualified Discord.Requests as R
import           Discord.Types

import           Bot.Message      (editMessage, fromBot, messageStartsWith,
                                   sendMessage)

-- If the start handler throws an exception, discord-haskell will gracefully shutdown
-- Use place to execute commands you know you want to complete
startHandler :: GuildId -> ChannelId -> DiscordHandler ()
startHandler serverid channelid = do
  liftIO $ putStrLn "Started ping-pong bot"

  let activity =
        (mkActivity "with leefs" ActivityTypeStreaming)
          { activityUrl = Nothing
          , activityState = Just "Growing a tree..."
          }
  let opts =
        UpdateStatusOpts
          { updateStatusOptsSince = Nothing
          , updateStatusOptsActivities = [activity]
          , updateStatusOptsNewStatus = UpdateStatusOnline
          , updateStatusOptsAFK = False
          }
  sendCommand (UpdateStatus opts)

  void $ restCall $ R.CreateMessage channelid "Hello! I will reply to pings with pongs"

-- If an event handler throws an exception, discord-haskell will continue to run
eventHandler :: Event -> DiscordHandler ()
eventHandler event = case event of
  MessageCreate m -> when (not (fromBot m) && messageStartsWith "ping" m) $ do
    void $ restCall (R.CreateReaction (messageChannelId m, messageId m) "eyes")
    delaySeconds 2

    -- Send "Pong" message
    Right m' <- restCall (sendMessage (messageChannelId m) "Pong")
    -- Edit message to "Pong!"
    void $ restCall (editMessage (<> "!") m')

    latency <- getGatewayLatency
    mLatency <- measureLatency

    let opts :: R.MessageDetailedOpts
        opts =
          def
            { R.messageDetailedContent = "Here's the current gateway latency: " <> (T.pack . show) [latency, mLatency]
            , R.messageDetailedTTS = False
            , R.messageDetailedAllowedMentions =
                Just
                  def
                    { R.mentionEveryone = False
                    , R.mentionRepliedUser = False
                    }
            , R.messageDetailedReference =
                Just def{referenceMessageId = Just $ messageId m}
            }
    void $ restCall (R.CreateMessageDetailed (messageChannelId m) opts)
  _ -> return ()
