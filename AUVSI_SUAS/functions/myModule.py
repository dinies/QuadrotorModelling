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


def myfunc():
    server = os.getenv('TEST_INTEROP_SERVER', 'http://localhost:8000')
    username = os.getenv('TEST_INTEROP_USER', 'testuser')
    password = os.getenv('TEST_INTEROP_USER_PASS', 'testpass')
    admin_username = os.getenv('TEST_INTEROP_ADMIN', 'testadmin')
    admin_password = os.getenv('TEST_INTEROP_ADMIN_PASS', 'testpass')
    admin_client = Client(server, admin_username, admin_password)
    admin_client.get('/api/clear_cache')
    async_client = AsyncClient(server, username, password)
    async_missions = async_client.get_missions().result()
    return async_missions

