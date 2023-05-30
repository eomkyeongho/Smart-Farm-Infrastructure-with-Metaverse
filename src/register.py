import requests
import random
import json

cseBase = 'http://rpi.lamxke.xyz/Mobius'
aeList = ['sunshineSensor', 'humiditySensor', 'airQualitySensor', 'temperatureSensor', 'CO2Sensor', 'TVOCSensor']
cntMap = {"sunshineSensor" : 'sunshine', "humiditySensor" : 'humidity', "airQualitySensor" : 'airQuality', "temperatureSensor" : 'temperature', "CO2Sensor" : 'CO2', "TVOCSensor" : 'TVOC'}
RIMIN = 10000
RIMAX = 40000

def registAlloneM2MResources():
    for ae in aeList:
        headers = {'X-M2M-Origin': f'HOUSE_10C4_{cntMap[ae]}', 'X-M2M-RI' : f'{random.randrange(RIMIN, RIMAX)}', 'X-M2M-RVI' : '2a', 'Content-Type': 'application/json;ty=2'}
        body = {'m2m:ae': {'rn': f'{ae}', 'api': 'app-sensor', 'rr': 'true'}}
        res = requests.post(cseBase, headers=headers, json=body)
        print(res.text)

        if res.status_code == 201:
            headers = {'X-M2M-Origin': f'{cntMap[ae]}', 'X-M2M-RI' : f'{random.randrange(RIMIN, RIMAX)}', 'X-M2M-RVI' : '2a', 'Content-Type': 'application/json;ty=3'}
            body = {'m2m:cnt': {'rn': f'{cntMap[ae]}'}}
            res = requests.post(f'{cseBase}/{ae}', headers=headers, json=body)
            print(res.text)

def deleteAlloneM2MResources():
    for ae in aeList:
        headers = {'X-M2M-Origin': f'HOUSE_10C4_{cntMap[ae]}', 'X-M2M-RI' : f'{random.randrange(RIMIN, RIMAX)}', 'X-M2M-RVI' : '2a', 'Content-Type': 'application/json;ty=2'}
        res = requests.delete(f'{cseBase}/{ae}', headers=headers)
        print(res.text)

registAlloneM2MResources()
    