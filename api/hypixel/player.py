import json
import requests

with open("secrets.json") as file:
    secrets = json.load(file)


class Key:

    hypixelKey = secrets["hypixel_key"]

    def getKeyInfo(self, key: str) -> dict:
        response = json.loads(requests.get(f"https://api.hypixel.net/key?key={key}").text)
        try:
            if response["success"] == "True":
                data = response["record"]
                return {
                    "owner": data['owner'], 
                    "totalQueries": data['totalQueries'], 
                    "pastMinute": data['queriesInPastMin'], 
                    "queryLimit": data['limit']
                }
            else:
                return {
                    "owner": "",
                    "totalQueries": "",
                    "pastMinute": "",
                    "queryLimit": ""
                }
        except KeyError:
            return {}



class Player:

    def getHypixel(self, uuid: str, hypixelKey = Key.hypixelKey, data : str = "player", idType: str = "uuid") -> json:
        return json.loads(requests.get(
            f"https://api.hypixel.net/{data}?key={hypixelKey}&{idType}={uuid}"
            ).text)