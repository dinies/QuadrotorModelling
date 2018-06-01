classdef Interoperability < handle
  properties
    api
  end
  methods
    function self = Interoperability()
      if count(py.sys.path,'/usr/local/lib/python2.7/site-packages') == 0
        list = py.sys.path
        list.append('/usr/local/lib/python2.7/site-packages');
      end

      module = py.importlib.import_module('InteropApi');
      self.api = module.InteropApi(); %TODO give the url and user and password to the constructor in py
    end

    function missionData =  getMissionData(self)
      rawMissionData = self.api.getMission();
      rawStruct = rawMissionData{:}
      missionData = rawMissionData; %TODO
    end

    function obstaclesData = getObstaclesData(self)
      rawObstaclesData = self.api.getObstacles();
      obstaclesData = rawObstaclesData; %TODO
    end
  end
end
