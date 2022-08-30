import json
from json import JSONDecodeError
import requests
import datetime

from typing import List

class User:

    def getUUID(self, ign) -> str:
        try:
            return json.loads(requests.get(
                f"https://api.mojang.com/users/profiles/minecraft/{ign}"
                ).text)["id"]
        except (JSONDecodeError, json.JSONDecodeError, KeyError):
            return None


    def getPastNames(self, uuid) -> List[str]:
        response = json.loads(requests.get(
            f"https://api.mojang.com/user/profiles/{uuid}/names"
            ).text)
        names = []
        names_len = len(response)
        while names_len >= 0:
            try:
                time_unix = int(response[names_len-1]["changedToAt"])
                timestamp = datetime.datetime.fromtimestamp(round(time_unix/1000,0))
                timestamp = timestamp.strftime("%Y-%m-%d %H:%M:%S")
            except KeyError:			#other line lenghts =
                timestamp = "first:             "
            date_name = str(timestamp + ' - ' + response[names_len-1]["name"])
            names.append(date_name)
            names_len -= 1
        return names
