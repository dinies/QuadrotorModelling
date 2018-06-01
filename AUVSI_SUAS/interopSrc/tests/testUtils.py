from context import src
from src import Utils as U
from src import InteropApi as Api
from nose import tools
import pprint
# unttests of the Utility functions


def testAddMovingObsField():

    givenInput = {
        "obst1": {'cylinder_height': 200.0,
            'cylinder_radius': 150.0,
            'latitude': 38.14792,
            'longitude': -76.427995},
        "obst2": {'cylinder_height': 300.0,
            'cylinder_radius': 50.0,
            'latitude': 38.145823,
            'longitude': -76.422396},
        "obst3": {'altitude_msl': 269.59908806491916,
            'latitude': 38.142312665028335,
            'longitude': -76.42518332954758,
            'sphere_radius': 50.0}
    }

    expectedOutput = {
        "obst1": {'cylinder_height': 200.0,
            'cylinder_radius': 150.0,
            'latitude': 38.14792,
            'longitude': -76.427995,
            'stationary':1},
        "obst2": {'cylinder_height': 300.0,
            'cylinder_radius': 50.0,
            'latitude': 38.145823,
            'longitude': -76.422396,
            'stationary':1},
        "obst3": {'altitude_msl': 269.59908806491916,
            'latitude': 38.142312665028335,
            'longitude': -76.42518332954758,
            'sphere_radius': 50.0,
            'stationary':0},
    }

    U.addMovingObsField( givenInput)

    tools.eq_(givenInput, expectedOutput)

def testRegroupIntoDict():

    givenInput = [
        {'cylinder_height': 200.0,
         'cylinder_radius': 150.0,
         'latitude': 38.14792,
         'longitude': -76.427995},
        {'cylinder_height': 300.0,
         'cylinder_radius': 50.0,
         'latitude': 38.145823,
         'longitude': -76.422396},
        {'altitude_msl': 269.59908806491916,
         'latitude': 38.142312665028335,
         'longitude': -76.42518332954758,
         'sphere_radius': 50.0}
    ]
    expected= {
        "obst1": {'cylinder_height': 200.0,
              'cylinder_radius': 150.0,
              'latitude': 38.14792,
              'longitude': -76.427995},
        "obst2": {'cylinder_height': 300.0,
              'cylinder_radius': 50.0,
              'latitude': 38.145823,
              'longitude': -76.422396},
        "obst3": {'altitude_msl': 269.59908806491916,
              'latitude': 38.142312665028335,
              'longitude': -76.42518332954758,
              'sphere_radius': 50.0}
    }

    result = U.regroupIntoDict( givenInput, "obst")

    tools.eq_(result, expected)

def testToDictCleanAlreadyDict():
   dictNone = {
       'mission1': {
           'fly_zones': [{
               'boundary_pts': [{'altitude_msl': None,
                                 'latitude': 38.142544,
                                 'longitude': -76.434088,
                                 'order': 1},
                                {'altitude_msl': None,
                                 'latitude': 38.141833,
                                 'longitude': -76.425263,
                                 'order': 2},
                                {'altitude_msl': None,
                                 'latitude': 38.144678,
                                 'longitude': -76.427995,
                                 'order': 3}]}]
       }
   }

   dictClean = {
       'mission1': {
           'fly_zones': [{
               'boundary_pts': [{'altitude_msl': "Nan",
                                 'latitude': 38.142544,
                                 'longitude': -76.434088,
                                 'order': 1},
                                {'altitude_msl': "Nan",
                                 'latitude': 38.141833,
                                 'longitude': -76.425263,
                                 'order': 2},
                                {'altitude_msl': "Nan",
                                 'latitude': 38.144678,
                                 'longitude': -76.427995,
                                 'order': 3}]}]
       }
   }

   result = U.todictClean(dictNone)

   tools.eq_(result, dictClean)

def testToDictCleanNotYetDict():


    api = Api.InteropApi()
    missionList = api.getMission()

    expectedOutput={
        'mission1': {
            'active': True,
            'air_drop_pos': {'latitude': 38.141833, 'longitude': -76.425263},
            'emergent_last_known_pos': {'latitude': 38.145823,
                                        'longitude': -76.422396},
            'fly_zones': [{'altitude_msl_max': 750.0,
                           'altitude_msl_min': 0.0,
                           'boundary_pts': [{'altitude_msl': 'Nan',
                                             'latitude': 38.142544,
                                             'longitude': -76.434088,
                                             'order': 1},
                                            {'altitude_msl': 'Nan',
                                             'latitude': 38.141833,
                                             'longitude': -76.425263,
                                             'order': 2},
                                            {'altitude_msl': 'Nan',
                                             'latitude': 38.144678,
                                             'longitude': -76.427995,
                                             'order': 3}]}],
            'home_pos': {'latitude': 38.14792, 'longitude': -76.427995},
            'id': 1,
            'mission_waypoints': [{'altitude_msl': 200.0,
                                   'latitude': 38.142544,
                                   'longitude': -76.434088,
                                   'order': 1}],
            'off_axis_odlc_pos': {'latitude': 38.142544,
                                  'longitude': -76.434088},
            'search_grid_points': [{'altitude_msl': 200.0,
                                    'latitude': 38.142544,
                                    'longitude': -76.434088,
                                    'order': 1}]
        }
    }
    result = U.regroupIntoDict(missionList,"mission")

    tools.eq_(result, expectedOutput )



