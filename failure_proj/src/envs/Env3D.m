classdef Env3D < Env

  methods
    function self = Env3D( length, delta_t, agent, clock )
      self@Env( length, delta_t )

      self.start= Position(self.unitaryDim*2,self.unitaryDim*2,self.unitaryDim*2, self.unitaryDim, self.colors.green);

      self.goal = Position(length - self.unitaryDim*2,length - self.unitaryDim*2,length - self.unitaryDim*2,self.unitaryDim, self.colors.red);

      self.agent = agent;
      self.clock = clock;

      self.vertices= [
                      0,0,0;
                      0,length,0;
                      length,length,0;
                      length, 0, 0;
                      0,0,length;
                      0,length,length;
                      length,length,length;
                      length, 0, length;
      ];
      self.borders= [
                     self.vertices(1,:), self.vertices(2,:);
                     self.vertices(2,:), self.vertices(3,:);
                     self.vertices(3,:), self.vertices(4,:);
                     self.vertices(4,:), self.vertices(1,:);

                     self.vertices(2,:), self.vertices(3,:);
                     self.vertices(3,:), self.vertices(7,:);
                     self.vertices(7,:), self.vertices(6,:);
                     self.vertices(6,:), self.vertices(2,:);

                     self.vertices(3,:), self.vertices(4,:);
                     self.vertices(4,:), self.vertices(8,:);
                     self.vertices(8,:), self.vertices(7,:);
                     self.vertices(7,:), self.vertices(3,:);

                     self.vertices(4,:), self.vertices(1,:);
                     self.vertices(1,:), self.vertices(5,:);
                     self.vertices(5,:), self.vertices(8,:);
                     self.vertices(8,:), self.vertices(4,:);

                     self.vertices(1,:), self.vertices(2,:);
                     self.vertices(2,:), self.vertices(6,:);
                     self.vertices(6,:), self.vertices(5,:);
                     self.vertices(5,:), self.vertices(1,:);

                     self.vertices(5,:), self.vertices(6,:);
                     self.vertices(6,:), self.vertices(7,:);
                     self.vertices(7,:), self.vertices(8,:);
                     self.vertices(8,:), self.vertices(5,:);
      ];

    end

    function setMission(self, start, goal)
      self.start.coords.x = start(1,1);
      self.start.coords.y = start(2,1);
      self.start.coords.z = start(3,1);

      self.agent.q(1:2,1)= start(1:2,1);

      self.goal.coords.x = goal(1,1);
      self.goal.coords.y = goal(2,1);
      self.goal.coords.z = goal(3,1);
    end

    function runSimulation( self, planners, timeTot)

      frame= self.length* 0.05;
      minAxis= 0 - frame;
      maxAxis= self.length + frame;
      figure('Name','Environment'),hold on;
      axis([minAxis maxAxis minAxis maxAxis minAxis maxAxis]);
      title('world'), xlabel('x'), ylabel('y'), zlabel('z')
      grid on
      az = 20;
      el = 45;
      view(az, el);

     % for i= 1:size(self.borders,1)
     %   first=  self.borders(i,1:3);
     %   second=  self.borders(i,4:6);
     %   drawLine3D(self.drawer,first,second,self.colors.black);
     % end


      for i = 1:size(planners,1)
        references(i,1)= getReferences(planners(i,1));
      end

      numSteps = timeTot/self.clock.delta_t;
      data = zeros(numSteps, self.agent.dimState + 1 + self.agent.dimRef + self.agent.dimInput);
      draw(self);
      pause(0.5);
      for j = 1:numSteps
        deleteDrawing(self.agent);

        agentData=  doAction(self.agent, references, j);
        draw(self.agent);

        agentStateDim = size( agentData.state,1);
        data(j, 1:agentStateDim)= agentData.state';
        data(j, agentStateDim+1) = self.clock.curr_t;
        data(j, agentStateDim+2:agentStateDim+2+size(agentData.v,1)-1)= agentData.v';
        data(j, agentStateDim+2+size(agentData.v,1):agentStateDim+2+size(agentData.v,1)+size(agentData.u)-1)= agentData.u';


        pause(0.03);
        tick(self.clock);

      end
      drawStatistics( self, data);
    end
    function draw(self)

      draw3D(self.start);
      draw(self.agent);
      draw3D(self.goal);

    end
    function drawStatistics( self, data)
      drawStatistics( self.agent, data)
    end
  end
end

