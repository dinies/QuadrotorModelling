import interop
client = interop.Client(url='http://172.17.0.1:8000', username='testuser',password='testpass')
missions = client.get_missions()
print missions

stationary_obstacles, moving_obstacles = client.get_obstacles()

print stationary_obstacles, moving_obstacles
