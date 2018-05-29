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

    def getObsta(self):
        async_future = self.async_client.get_obstacles()
        async_stationary, async_moving = async_future.result()
        return async_stationary, async_moving



    def getMis(self):
        async_missions = self.async_client.get_missions().result()
        return async_missions

