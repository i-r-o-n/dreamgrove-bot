{-# LANGUAGE OverloadedStrings #-}

module Bot.Handlers where

import           Control.Monad     (void)
import           Discord
import           Discord.Types
import           UnliftIO          (liftIO)

import           Bot.Events.Events (pongResponse)
import           Bot.Message       (createMessage)

startHandler :: GuildId -> ChannelId -> DiscordHandler ()
startHandler sid cid = do
  liftIO $ putStrLn "Started dreamgrove bot"

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

  void $ restCall $ createMessage cid "Hello! I am now online"

-- If an event handler throws an exception, discord-haskell will continue to run
eventHandler :: Event -> DiscordHandler ()
eventHandler event = case event of
  MessageCreate m -> pongResponse m
  _               -> return ()
