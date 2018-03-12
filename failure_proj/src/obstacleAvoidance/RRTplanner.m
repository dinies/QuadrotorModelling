classdef RRTplanner< handle
  properties
    env
    primitives
    delta_
    epsilon
  end

  methods( Static = true)

    function qNear = chooseNearerConfNode(list, pos)
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
      qNear = currRes;
    end

    function qNearest = nearestNodeNotBurned(list, pos)
      if ~isempty(list)

        currRes= list{1};
        if currRes.value.burned
          qNearest = {};
        else

          euclideanDist = sqrt((currRes.value.conf(1,1) - pos.x)^2 + (currRes.value.conf(2,1) - pos.y)^2);
          for i= 2:size(list,2)
            currNode= list{i};
            currDistance = sqrt((currNode.value.conf(1,1) - pos.x)^2 + (currNode.value.conf(2,1) - pos.y)^2);
            if currDistance < euclideanDist && ~currNode.value.burned
              currRes = currNode;
              euclideanDist = currDistance;
            end
          end
          qNearest = {currRes};
        end
      else
        qNearest = {};
      end
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

    function near =  isNearGoal(elem, goalCoords, threshold )
      i=1;
      near = false;
      while  ~near && i <= size( elem.value.middleConfs,2)
        coords = elem.value.middleConfs(1:2,i);
        euclideanDist = sqrt((coords(1,1) - goalCoords.x)^2 +(coords(2,1) -goalCoords.y)^2);
        near = euclideanDist < threshold;
        i = i + 1;
      end
    end
  end

  methods
    function self= RRTplanner( env )
      self.env = env;
      self.epsilon = 0.5;
    end

    function collision = collisionCheckAgent(self,newNode,radius,obstacles)
      collision = false;
      xCoord= newNode.value.conf(1,1);
      yCoord= newNode.value.conf(2,1);

      range = radius + self.env.unitaryDim/10;
      if xCoord <= range || xCoord >= self.env.length(1,1) - range|| yCoord <= range|| yCoord >= self.env.length(2,1) -range
        collision = true;
      end

      for i=1:size(obstacles,1)
        obstacle= obstacles(i,1);
        distFromObs= sqrt((xCoord - obstacle.coords.x)^2 +(yCoord- obstacle.coords.y)^2);
        if  distFromObs - ( radius + obstacle.radius) <= 0
          collision = true;
        end
      end
    end



    function path = runAlgo(self,agent,obstacles,threshold,delta_s, treeDrawing)
      initialValue.conf = agent.q;
      initialValue.input = [ 0; 0];
      initialValue.time = agent.clock.curr_t;
      initialValue.burned = false;
      initialValue.middleConfs = agent.q;
      root = Node( initialValue);

      if treeDrawing
        color= [0.0, 0.0, 1.0];
        drawer = Drawer();
      end

      stepNum = 0;
      maxNumSteps = 1000;
      reachedGoal = false;
      path= {};

      while ( stepNum < maxNumSteps) && ( ~reachedGoal )

        currentNodes = recFindNodes(root);
        if rand() < self.epsilon
          posRand = generateRandomPosition(self);
        else
          posRand = self.env.goal.coords;
        end

        qNearSingleton = RRTplanner.nearestNodeNotBurned( currentNodes, posRand);

        if isempty(qNearSingleton)
          path= {};
          return;
        else
          qNear = qNearSingleton{:};
          nodesFromPrimitives = generatePrimitives(agent,qNear,delta_s);
          orderedNodesFromPrim = RRTplanner.recSortByNearerChild(nodesFromPrimitives, posRand);
          qNewFound = false;
          i = 1;
          while  ~qNewFound && i <= size(orderedNodesFromPrim,2)
            qNew = orderedNodesFromPrim{i};
            if ~collisionCheckAgent(self,qNew,agent.radius, obstacles) && ~Node.recNodeBelongs( qNew , qNear.children)
              addChild(qNear, qNew);
              if treeDrawing
                for j = 1:size(qNew.value.middleConfs,2)
                  coords = qNew.value.middleConfs(1:2,j);
                  scatter3(coords(1,1), coords(2,1), 0 , agent.radius, agent.color);
                  pause(0.00001);
                end
                scatter3(qNew.value.conf(1,1), qNew.value.conf(2,1), 0 , agent.radius*5, agent.color*0.5);
              end
              qNewFound = true;
              self.epsilon = self.epsilon - 0.01;
              if RRTplanner.isNearGoal(qNew, self.env.goal.coords, threshold)
                reachedGoal = true;
                disp( "GOAL REACHED");
                path = getPathFromRoot(qNew);
              end
            end
            i = i+1;
          end
        end
        if ~qNewFound
          qNear.value.burned = true;
        end
        stepNum = stepNum +1;
      end
    end

    function coords = generateRandomPosition(self)
      length = self.env.length;
      offset= self.env.unitaryDim;
      extension_x= length(1,1) - 2*offset;
      extension_y= length(2,1) - 2*offset;
      coords.x = offset + rand()*extension_x;
      coords.y = offset + rand()*extension_y;
    end
  end
end
