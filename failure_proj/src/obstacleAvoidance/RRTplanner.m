classdef RRTplanner< handle
  properties
    env
    primitives
    delta_
    epsilon
  end

  methods( Static = true)

    function qNear = chooseNearerConf(list, pos)
      currRes= list{1};
      euclideanDist = sqrt((currRes.value.conf(1,1) - pos.x)^2 + (currRes.value.conf(2,1) - pos.y)^2);
      for i= 1:size(list,2)
        currLeaf = list{i};
        currDistance = sqrt((currLeaf.value.conf(1,1) - pos.x)^2 + (currLeaf.value.conf(2,1) - pos.y)^2);
        if currDistance < euclideanDist
          currRes = currLeaf;
          euclideanDist = currDistance;
        end
      end
      qNear = currRes.value.conf;
    end

    function orderedList = insertInCrescentOrder( list, elem, posRand)
      euclideanDist = sqrt((elem.value.conf(1,1) - posRand.x)^2 + (elem.value.conf(2,1) - posRand.y)^2);
      inserted = false;
      for i = 1:size(list,2)
        if ~inserted
          currDist = sqrt((list{i}.value.conf(1,1) - posRand.x)^2 + (list{i}.value.conf(2,1) - posRand.y)^2);
          if euclideanDist < currDist
            inserted = true;
            if i == 1
              orderedList = Node.addInHead( elem, list );
            else
              orderedList = Node.concatLists( {list{1:i-1}}, Node.addInHead( elem,list(i:size(list,2)) ));
            end
          end
        end
      end
      if ~inserted
        orderedList = Node.concatLists( list , {elem});
      end
    end

    function orderedChildren = recSortByNearerChild(children, posRand)
      if size(children,2) == 0
        orderedChildren = {};
      elseif size(children,2) == 1
        orderedChildren = children;
      else
        orderedChildren = RRTplanner.insertInCrescentOrder( RRTplanner.recSortByNearerChild( {children{2:size(children,2)}}, posRand), children{1}, posRand);
      end
    end
  end

  methods
    function self= RRTplanner( env )
      self.env = env;
      self.primitives = [];
      self.epsilon = 0.85;
    end


    function path = runAlgo(self,agent,obstacleCreator)
      initialValue.conf = agent.q;
      initialValue.input = [ 0; 0];
      root = Node( initialValue, {});


      stepNum = 0;
      maxNumSteps = 1000;
      reachedGoal = false;
      treeStart = root;

      while (( stepNum < maxNumSteps) || ( ~reachedGoal ))

        currentLeaves = findLeaves(root);

        if rand() < self.epsilon
          posRand = generateRandPos(self);
          qNear = chooseNearerConf(currentLeaves, posRand);
        else
          qNear = chooseNearerConf(currentLeaves, self.env.goalPos.coords);
        end

        children = generatePrimitives(agent,qNear);
        orderedChildren = recSortByNearerChild(children, posRand);
        qNewFound = false;
        for i = 1:size(orderedChildren,2)
          if ~qNewFound
            qNew = orderedChildren{i};
            if ~collisionCheck(obstacleCreator,qNew.value.conf(1:2,1),agent.radius,size(obstacleCreator.obstacles,1),self.env)
              addChild(qNew, qNear);
              qNewFound = true;
            end
          end
        end 
        if qNewFound
          self.epsilon = self.epsilon - 0.001;
        end
        
        path = {};
      end
    end

    function generateRandomPosition(self)
      length = self.env.length;
      offset= self.env.unitaryDim;
      extension_x= length(1,1) - 2*offset;
      extension_y= length(2,1) - 2*offset;
      coords.x = offset + rand()*extension_x;
      coords.y = offset + rand()*extension_y;
    end
  end
end
