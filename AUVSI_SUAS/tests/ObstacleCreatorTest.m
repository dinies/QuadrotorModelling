function tests = ObstacleCreatorTest
  tests = functiontests(localfunctions);
end


function testCollisionCheckTrue(~)

  color = [1.0, 0.84, 0.0 ];
  l= 10;
  env = Environment2D( l);
  creator = ObstacleCreator(env, 0);

  assert( size(creator.obstacles,1)== 0);

  obs = Obstacle( 3 , 3 , 2.25, color );
  creator.obstacles = [ creator.obstacles obs];

  assert( size(creator.obstacles,1)== 1);

  coord.x= 6;
  coord.y= 6;
  collision = collisionCheck( creator, coord, 2.25 , size(creator.obstacles,1), env);

  assert( collision == 1);

end


function testCollisionCheckFalse(~)

  color = [1.0, 0.84, 0.0 ];
  l= 10;
  env = Environment2D( l);
  creator = ObstacleCreator(env, 0);

  assert( size(creator.obstacles,1)== 0);

  obs = Obstacle( 3 , 3 , 2, color );
  creator.obstacles = [ creator.obstacles obs];

  assert( size(creator.obstacles,1)== 1);

  coord.x= 6;
  coord.y= 6;
  collision = collisionCheck( creator, coord, 2 , size(creator.obstacles,1), env);

  assert( collision == 0);

end


