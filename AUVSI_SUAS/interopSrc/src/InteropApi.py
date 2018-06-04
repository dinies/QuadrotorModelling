import sys
import os
import requests
import unittest

from interopLib import AsyncClient
from interopLib import Client
# from interopLib import InteropError
# from interopLib import Mission
# from interopLib import Odlc
# from interopLib import Telemetry
from scipy.io import matlab as scy
class InteropApi(object):

    def __init__(self, uri, user, passW):

        server = os.getenv('TEST_INTEROP_SERVER', uri)
        username = os.getenv('TEST_INTEROP_USER', user)
        password = os.getenv('TEST_INTEROP_USER_PASS', passW)
        self.async_client = AsyncClient(server, username, password)

        # Deprecated code only to flush the cache, it needs admin privileges on the server
        # admin_username = os.getenv('TEST_INTEROP_ADMIN', 'testadmin')
        # admin_password = os.getenv('TEST_INTEROP_ADMIN_PASS', 'testpass')
        # self.admin_client = Client(server, username, password)
        # self.admin_client.get('/api/clear_cache')


    def getObstacles(self):
        async_future = self.async_client.get_obstacles()
        stationary, moving = async_future.result()
        obstacles = stationary + moving
        dictObs = self.regroupIntoDict(obstacles, "obst")
        self.addMovingObsField(dictObs)
        path = "obstacles.mat"
        file = open(path,'w')
        scy.savemat(path, dictObs)
        file.close()

    def getMission(self):
        async_mission_list = self.async_client.get_missions().result()
        missDict = self.regroupIntoDict(async_mission_list,"mission")
        path = "mission.mat"
        file = open(path,'w')
        scy.savemat(path, missDict)
        file.close()

    # regroup a list of elements in a single nested dict, transoforming objects of @istancesName in dicts
    @staticmethod
    def regroupIntoDict( elemList, istancesName):
        unifiedDict = {}
        wrapperDict = {}
        indexKey = 0
        for ele in elemList:
            indexKey += 1
            name =  istancesName+str(indexKey)
            unifiedDict[name] = InteropApi.todictClean(ele)

        generalName = istancesName + 's'
        wrapperDict[generalName] = unifiedDict
        return wrapperDict

    # add a key value pair to each elem of the first layer of a dict of
    # obstacles to differentiate moving obs from non moving one
    @staticmethod
    def addMovingObsField( obsDict ):
        for (_,v) in obsDict.items():
            if "altitude_msl" in v.keys():
                v["stationary"] = 0
            else:
                v["stationary"] = 1


    # recursively transform python objects nested in a dictionary with None
    # values subst with  the string "None"
    @staticmethod
    def todictClean(obj,classkey=None):
        if isinstance(obj, dict):
            data = {}
            for (k, v) in obj.items():
                if v is not None :
                    data[k] = InteropApi.todictClean(v, classkey)
                else:
                    data[k] = "Nan"
            return data
        elif hasattr(obj, "_ast"):
            return InteropApi.todictClean(obj._ast())
        elif hasattr(obj, "__iter__"):
            l = []
            for v in obj:
                if v is not None:
                    l.append(InteropApi.todictClean(v, classkey))
            return l
        elif hasattr(obj, "__dict__"):
            data = dict([(key, InteropApi.todictClean(value, classkey))
                for key, value in obj.__dict__.items()
                if not callable(value) and not key.startswith('_')])
            if classkey is not None and hasattr(obj, "__class__"):
                data[classkey] = obj.__class__.__name__
            return data
        elif obj is None:
            return 'Nan'
        else:
            return obj
