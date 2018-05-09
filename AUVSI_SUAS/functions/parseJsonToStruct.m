


function parseJsonToStruct( json)
  decoded = jsondecode( json );

end



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
