from cmath import cos
import discord
from typing import List

import pandas as pd

class StatusProportions:
    def __init__(self, online, disturb, offline, idle) -> None:
        self.online = online
        self.disturb = disturb
        self.offline = offline
        self.idle = idle


def getMemberStatuses(guild: discord.Guild) -> List:
    return pd.Series([member.raw_status for member in guild.members]).value_counts().to_dict()


def statusColor(color: str) -> str:
    match color:
        case "online":
            return "#57F287"
        case "offline":
            return "#424549"
        case "idle":
            return "#FEE75C"
        case "dnd":
            return "#ED4245"
        