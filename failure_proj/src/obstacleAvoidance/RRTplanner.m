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

    function bool =  isNearGoal(elem, goalCoords, threshold )
      euclideanDist = sqrt((elem.value.conf(1,1) - goalCoords.x)^2 +(elem.value.conf(2,1) -goalCoords.y)^2);
      if euclideanDist < threshold
        bool = true;
      else
        bool = false;
      end
    end
  end

  methods
    function self= RRTplanner( env )
      self.env = env;
      self.epsilon = 0.85;
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



    function path = runAlgo(self,agent,obstacles,threshold, treeDrawing)
      initialValue.conf = agent.q;
      initialValue.input = [ 0; 0];
      initialValue.time = agent.clock.curr_t;
      initialValue.burned = false;
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

        orderedNodes = RRTplanner.recSortByNearerChild( currentNodes, posRand);

        qNearFound = false;
        for j=  1:size(orderedNodes,2)
          node = orderedNodes{j};
          if  ~qNearFound && ~node.value.burned
            qNear = node;
            qNearFound= true;
          end
        end
        if ~qNearFound
          path= {};
        else
          children = generatePrimitives(agent,qNear);
          orderedChildren = RRTplanner.recSortByNearerChild(children, posRand);
          qNewFound = false;
          for i = 1:size(orderedChildren,2)
            if ~qNewFound
              qNew = orderedChildren{i};
              if ~collisionCheckAgent(self,qNew,agent.radius, obstacles)
                if ~Node.recNodeBelongs( qNew , qNear.children)
                  addChild(qNear, qNew);
                  if treeDrawing
                    fristCoords = qNear.value.conf(1:2,1)';
                    secondCoords = qNew.value.conf(1:2,1)';
                    drawLine2D(drawer, fristCoords, secondCoords, color);
                  end
                  qNewFound = true;
                end
              end
            end
          end
          if qNewFound
            self.epsilon = self.epsilon - 0.001;
            if RRTplanner.isNearGoal(qNew, self.env.goal.coords, threshold)
              reachedGoal = true;
              path = getPathFromRoot(qNew);
            end
          else
            qNear.value.burned = true;
          end
          stepNum = stepNum +1;
          if reachedGoal
              disp( "GOAL REACHED");
          end
          size(recFindNodes(root),2);

        end
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
