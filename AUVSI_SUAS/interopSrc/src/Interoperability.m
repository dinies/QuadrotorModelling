classdef Interoperability < handle
  properties
    api
  end
  methods
    function self = Interoperability( serverUri, usernameTeam, passwordTeam )
      if count(py.sys.path,'/usr/local/lib/python2.7/site-packages') == 0
        list = py.sys.path
        list.append('/usr/local/lib/python2.7/site-packages');
      end
      module = py.importlib.import_module('src.InteropApi');


      self.api = module.InteropApi( serverUri, usernameTeam, passwordTeam);
    end

    function missionStruct = getMissionData(self)
        self.api.getMission();
        missionStruct = load('mission.mat');
    end

    function obstaclesStruct = getObstaclesData(self)
        self.api.getObstacles();
        obstaclesStruct = load('obstacles.mat');
    end
  end
end
