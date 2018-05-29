% 
% relativePath =pwd;
% stringPath = string(relativePath) + "/ApiBridge.py";
% commandStr = "python "+ stringPath;
% [status, commandOut] = system(commajkkndStr);
% if status==0
%   fprintf('squared result is %d\n',commandOut);
% end


% how to import external libraries

% take the reference of the python search PATH
list = py.sys.path;
% append the path to the target module which is found by this passages in python interpreter
% >> import requests    < target module >
% >> import os
% >> path = os.path.dirname( request.__file__)
list.append('/usr/local/lib/python2.7/site-packages'); %arg path


% import callable python functions, be sure that the current matlab folder is the one with the fun
if count(py.sys.path,'') == 0
  insert(py.sys.path,int32(0),'');
end
%mod = py.importlib.import_module('myModule');
mod = py.importlib.import_module('ApiBridge');
                         % useful commands   :
                         % clear workspace and imported modules :  clear classes
                         % reload module :  py.reload(mod)
                                % x =mod.myfunc();

b = mod.ApiBridge();
