module Bot.Commands.Commands where

import           Database.MonthDay (MonthDay)
import           Database.Types    (User (birthday))

-- slash commands:

getUserBirthday :: User -> MonthDay
getUserBirthday = _

setUserBirthday :: User -> MonthDay
setUserBirthday = _
