function struct = parseJsonToStruct( json)
       % PARSEJSONTOSTRUCT this func will return a customised function that will
       % contain all the useful informations received from the judges server
       % organised in a struct which will have the fields described above.
       % STRUCT MISSION : TODO
       % STRUCT OBSTACLES : TODO


  decoded = jsondecode( j1 );
  struct = -1; %TODO

end

%{
  %% example json

HTTP/1.1 200 OK
Content-Type: application/json

{
 "moving_obstacles": [
                      {
                       "altitude_msl": 189.56748784643966,
                       "latitude": 38.141826869853645,
                       "longitude": -76.43199876559223,
                       "sphere_radius": 150.0
                      },
                      {
                       "altitude_msl": 250.0,
                       "latitude": 38.14923628783763,
                       "longitude": -76.43238529543882,
                       "sphere_radius": 150.0
                      }
 ],
 "stationary_obstacles": [
                          {
                           "cylinder_height": 750.0,
                           "cylinder_radius": 300.0,
                           "latitude": 38.140578,
                           "longitude": -76.428997
                          },
                          {
                           "cylinder_height": 400.0,
                           "cylinder_radius": 100.0,
                           "latitude": 38.149156,
                           "longitude": -76.430622
                          }
 ]
}

HTTP/1.1 200 OK
Content-Type: application/json

[
    {
        "id": 1,
        "active": true,
        "air_drop_pos": {
            "latitude": 38.141833,
            "longitude": -76.425263
        },
        "fly_zones": [
            {
                "altitude_msl_max": 200.0,
                "altitude_msl_min": 100.0,
                "boundary_pts": [
                    {
                        "latitude": 38.142544,
                        "longitude": -76.434088,
                        "order": 1
                    },
                    {
                        "latitude": 38.141833,
                        "longitude": -76.425263,
                        "order": 2
                    },
                    {
                        "latitude": 38.144678,
                        "longitude": -76.427995,
                        "order": 3
                    }
                ]
            }
        ],
        "home_pos": {
            "latitude": 38.14792,
            "longitude": -76.427995
        },
        "mission_waypoints": [
            {
                "altitude_msl": 200.0,
                "latitude": 38.142544,
                "longitude": -76.434088,
                "order": 1
            }
        ],
        "off_axis_odlc_pos": {
            "latitude": 38.142544,
            "longitude": -76.434088
        },
        "emergent_last_known_pos": {
            "latitude": 38.145823,
            "longitude": -76.422396
        },
        "search_grid_points": [
            {
                "altitude_msl": 200.0,
                "latitude": 38.142544,
                "longitude": -76.434088,
                "order": 1
            }
        ]
    }
]
%}
