from context import src
from src import InteropApi as Api
from src import Utils as U
from scipy.io import matlab as scy
import pprint

api = Api.InteropApi()

missionList = api.getMission()
pprint.pprint( missionList)
missDict = U.regroupIntoDict(missionList,"mission")

# U.cleanDictionary(missDict)

# missDict = {
#     "one" : 1 ,
#     "five" : 5
# }
# TODO  remove None values from the dict     DEBUG here, the regroupIntoDict fun is not working well (test num 4)
pprint.pprint( missDict)

# path = "../dataFiles/mission.mat"

# file = open(path,'w')
# scy.savemat(path, missDict)
# file.close()



