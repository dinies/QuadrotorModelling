import sys
import os
import requests
import unittest

from interop import AsyncClient
from interop import Client
from interop import InteropError
from interop import Mission
from interop import Odlc
from interop import Telemetry
class InteropApi(object):

    def __init__(self):
        server = os.getenv('TEST_INTEROP_SERVER', 'http://localhost:8000')
        username = os.getenv('TEST_INTEROP_USER', 'testuser')
        password = os.getenv('TEST_INTEROP_USER_PASS', 'testpass')
        admin_username = os.getenv('TEST_INTEROP_ADMIN', 'testadmin')
        admin_password = os.getenv('TEST_INTEROP_ADMIN_PASS', 'testpass')

        self.admin_client = Client(server, admin_username, admin_password)
        self.admin_client.get('/api/clear_cache')
        self.async_client = AsyncClient(server, username, password)


        # stationaryObs
#         self.latitude = float(latitude)
#         self.longitude = float(longitude)
#         self.cylinder_radius = float(cylinder_radius)
#         self.cylinder_height = float(cylinder_height)

        # movingObs
#         self.latitude = float(latitude)
#         self.longitude = float(longitude)
#         self.altitude_msl = float(altitude_msl)
#         self.sphere_radius = float(sphere_radius)


    def getObsta(self):
        async_future = self.async_client.get_obstacles()
        stationary, moving = async_future.result()

        obstacles = self.parseObstacles( stationary[0], moving[1])

        return obstacles



    def getMis(self):
        async_missions = self.async_client.get_missions().result()
        return async_missions



    def parseObstacles(self):
        return -1

    def stubReturn(self):

        dict1 = {
            "one" : 1 ,
            "two" : 2
        }
        dict2 = {
            "one" : 1 ,
            "two" : 2,
            "three" :3
        }
        dict3 = {
            "one" : 1 ,
            "two" : 2
        }
        return [ dict1, dict2, dict3 ]


