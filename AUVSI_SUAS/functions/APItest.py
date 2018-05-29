import os
import requests
import unittest

from interop import AsyncClient
from interop import Client
from interop import InteropError
from interop import Mission
from interop import Odlc
from interop import Telemetry


# client = interop.Client(url='http://172.17.0.1:8000', username='testuser',password='testpass')
# missions = client.get_missions()
# print(missions)

# stationary_obstacles, moving_obstacles = client.get_obstacles()

# print(stationary_obstacles, moving_obstacles)

server = os.getenv('TEST_INTEROP_SERVER', 'http://localhost:8000')
username = os.getenv('TEST_INTEROP_USER', 'testuser')
password = os.getenv('TEST_INTEROP_USER_PASS', 'testpass')
admin_username = os.getenv('TEST_INTEROP_ADMIN', 'testadmin')
admin_password = os.getenv('TEST_INTEROP_ADMIN_PASS', 'testpass')


"""Create a logged in Client."""
# Create an admin client to clear cache.
admin_client = Client(server, admin_username, admin_password)
admin_client.get('/api/clear_cache')

# Test rest with non-admin clients.
client = Client(server, username, password)
async_client = AsyncClient(server, username, password)

"""Test getting missions."""
missions = client.get_missions()
async_missions = async_client.get_missions().result()

# # Check one mission returned.
# self.assertEqual(1, len(missions))
# self.assertEqual(1, len(async_missions))
# # Check a few fields.
# self.assertTrue(missions[0].active)
# self.assertTrue(async_missions[0].active)
# self.assertEqual(1, missions[0].id)
# self.assertEqual(1, async_missions[0].id)
# self.assertEqual(38.14792, missions[0].home_pos.latitude)
# self.assertEqual(38.14792, async_missions[0].home_pos.latitude)


admin_client.get('/api/clear_cache')

"""Test getting obstacles."""
stationary, moving = client.get_obstacles()
async_future = async_client.get_obstacles()
async_stationary, async_moving = async_future.result()

# # No exceptions is a good sign, let's see if the data matches the fixture.
# self.assertEqual(2, len(stationary))
# self.assertEqual(2, len(async_stationary))
# self.assertEqual(1, len(moving))
# self.assertEqual(1, len(async_moving))

# # Lat, lon, and altitude of the moving obstacles change, so we don't
# # check those.
# self.assertEqual(50, moving[0].sphere_radius)
# self.assertEqual(50, async_moving[0].sphere_radius)

# radii = [o.cylinder_radius for o in stationary]
# async_radii = [o.cylinder_radius for o in async_stationary]
# self.assertIn(50, radii)
# self.assertIn(50, async_radii)
# self.assertIn(150, radii)
# self.assertIn(150, async_radii)

# heights = [o.cylinder_height for o in stationary]
# async_heights = [o.cylinder_height for o in async_stationary]
# self.assertIn(300, async_heights)
# self.assertIn(200, async_heights)

print( missions)


