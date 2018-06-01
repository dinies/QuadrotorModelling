#TODO    put all this functions as STATIC in the interopAPI class

# creates a file or overwrite it if it already exists
# def touch(path):
#     with f = open(path, 'w'):
#         os.utime(path, None)
#         f = open(path)
#     return f


# regroup a list of elements in a single nested dict, transoforming objects of @istancesName in dicts
def regroupIntoDict( elemList, istancesName):
    unifiedDict = {}
    indexKey = 0
    for ele in elemList:
        indexKey += 1
        name =  istancesName+str(indexKey)
        unifiedDict[name] = todictClean(ele)
    return unifiedDict

# add a key value pair to each elem of the first layer of a dict of
# obstacles to differentiate moving obs from non moving one
def addMovingObsField( obsDict ):
    for (_,v) in obsDict.items():
        if "altitude_msl" in v.keys():
            v["stationary"] = 0
        else:
            v["stationary"] = 1



# recursively transform python objects nested in a dictionary with None
# values subst with  the string "None"
def todictClean(obj,classkey=None):
    if isinstance(obj, dict):
        data = {}
        for (k, v) in obj.items():
            if v is not None :
                data[k] = todictClean(v, classkey)
            else:
                data[k] = "Nan"
        return data
    elif hasattr(obj, "_ast"):
        return todictClean(obj._ast())
    elif hasattr(obj, "__iter__"):
        l = []
        for v in obj:
            if v is not None:
                l.append(todictClean(v, classkey))
        return l
    elif hasattr(obj, "__dict__"):
        data = dict([(key, todictClean(value, classkey))
            for key, value in obj.__dict__.items()
            if not callable(value) and not key.startswith('_')])
        if classkey is not None and hasattr(obj, "__class__"):
            data[classkey] = obj.__class__.__name__
        return data
    else:
        return obj


# recursively transform python objects nested in a dictionary
# def todict(obj, classkey=None):
#     if isinstance(obj, dict):
#         data = {}
#         for (k, v) in obj.items():
#             data[k] = todict(v, classkey)
#         return data
#     elif hasattr(obj, "_ast"):
#         return todict(obj._ast())
#     elif hasattr(obj, "__iter__"):
#         return [todict(v, classkey) for v in obj]
#     elif hasattr(obj, "__dict__"):
#         data = dict([(key, todict(value, classkey)) 
#             for key, value in obj.__dict__.items() 
#             if not callable(value) and not key.startswith('_')])
#         if classkey is not None and hasattr(obj, "__class__"):
#             data[classkey] = obj.__class__.__name__
#         return data
#     else:
#         return obj

