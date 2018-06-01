from context import src
from src import InteropApi as Api
from src import Utils as U
from scipy.io import matlab as scy
import pprint

api = Api.InteropApi()
obs = api.getObstacles()

dictObs = U.regroupIntoDict(obs, "obst")
U.addMovingObsField(dictObs)
pprint.pprint(dictObs )

path = "../dataFiles/obstacles.mat"
# dictObs= {
#     "one" : 1 ,
#     "five" : 5
# }


file = open(path,'w')
scy.savemat(path, dictObs)
file.close()



