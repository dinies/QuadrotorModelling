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

    def __init__(self):
        server = os.getenv('TEST_INTEROP_SERVER', 'http://localhost:8000')
        username = os.getenv('TEST_INTEROP_USER', 'testuser')
        password = os.getenv('TEST_INTEROP_USER_PASS', 'testpass')
        admin_username = os.getenv('TEST_INTEROP_ADMIN', 'testadmin')
        admin_password = os.getenv('TEST_INTEROP_ADMIN_PASS', 'testpass')

        self.admin_client = Client(server, admin_username, admin_password)
        self.admin_client.get('/api/clear_cache')
        self.async_client = AsyncClient(server, username, password)

    def getObstacles(self):
        async_future = self.async_client.get_obstacles()
        stationary, moving = async_future.result()

        # obstacles = self.parseObstacles( stationary[0], moving[1])
        obstacles = stationary + moving

        return obstacles

    def getMission(self):
        async_missions = self.async_client.get_missions().result()
        return async_missions


    def parseObstacles(self):
        return -1



