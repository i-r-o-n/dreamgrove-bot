{-# LANGUAGE LambdaCase #-}

module Bot.Users.Roles where

import           Bot.Guild
import           Discord
import qualified Discord.Requests as R
import           Discord.Types

-- get users roles

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

-- Get member roles for a user in a guild
-- getMemberRoles' :: GuildId -> UserId -> DiscordHandler [RoleId]
-- getMemberRoles' gid uid = do
--   result <- restCall $ R.GetGuildMember gid uid
--   case result of
--     Left _       -> pure []
--     Right member -> pure $ memberRoles member

getFullMemberRoles :: UserId -> DiscordHandler [Role]
getFullMemberRoles uid = do
  member <- getMember uid
  roles <- getRoles
  case (member, roles) of
    (Right m, Right rs) -> pure $ filter (\r -> roleId r `elem` memberRoles m) rs
    _ -> pure []

-- getFullMemberRoles :: GuildId -> UserId -> DiscordHandler [Role]
-- getFullMemberRoles gid uid = do
--   memberResult <- restCall $ R.GetGuildMember gid uid
--   guildResult <- restCall $ R.GetGuildRoles gid
--   case (memberResult, guildResult) of
--     (Right member, Right roles) ->
--       pure $ filter (\r -> roleId r `elem` memberRoles member) roles
--     _ -> pure []
