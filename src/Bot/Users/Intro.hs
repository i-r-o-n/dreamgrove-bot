module Bot.Users.Intro where

import           Discord.Types

-- get users messages in introductions channel

hasIntro :: UserId -> IO Bool
hasIntro = _

-- NOTE: might need special mention user permissions in message
requestIntroMessage :: String -> String
requestIntroMessage user = "Hello " ++ user ++ ", please introduce yourself in the introductions channel."
