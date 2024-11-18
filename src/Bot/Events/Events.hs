{-# LANGUAGE OverloadedStrings #-}

module Bot.Events.Events where

import           Bot.Message
import           Bot.Scheduler
import           Control.Monad    (void, when)
import           Data.Text        as T
import           Discord
import qualified Discord.Requests as R
import           Discord.Types

pongResponse :: Message -> DiscordHandler ()
pongResponse m = when (not (fromBot m) && messageStartsWith "ping" m) $ do
  void $ restCall (R.CreateReaction (messageChannelId m, messageId m) "eyes")
  delaySeconds 2

  -- Send "Pong" message
  Right m' <- restCall (createMessage (messageChannelId m) "Pong")
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
