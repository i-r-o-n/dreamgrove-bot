{-# LANGUAGE LambdaCase #-}

module Bot.Users.Roles where

import           Bot.Guild
import           Discord
import           Discord.Types

hasAgeRole :: UserId -> Bool
hasAgeRole = _

hasPronounRole :: UserId -> Bool
hasPronounRole = _

hasContactRole :: UserId -> Bool
hasContactRole = _

getMemberRoles :: UserId -> DiscordHandler [RoleId]
getMemberRoles uid = do
  getMember uid >>= \case
    Left _ -> pure [] -- Return no roles if member not found
    Right member -> pure $ memberRoles member

getFullMemberRoles :: UserId -> DiscordHandler [Role]
getFullMemberRoles uid = do
  member <- getMember uid
  roles <- getRoles
  case (member, roles) of
    (Right m, Right rs) -> pure $ filter (\r -> roleId r `elem` memberRoles m) rs
    _ -> pure []
