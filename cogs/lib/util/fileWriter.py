import json
import os



def fileDirectory(fileName: str) -> str:
    return f"lib/data/{fileName}.json"

def fileLocation(fileName: str) -> str:
    return f"{os.getcwd()}/{fileDirectory(fileName)}"


def write(data: dict, fileDir: str) -> None:
    with open(fileLocation(fileDir), "w") as outFile:
        json.dump(data, outFile)


def read(fileDir: str) -> dict:
    with open(fileLocation(fileDir), 'r') as openFile:
        return json.load(openFile)

