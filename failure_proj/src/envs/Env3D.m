classdef Env3D < Env

  methods
    function self = Env3D( length, delta_t, agent )
      self@Env( length, delta_t )

      self.start= Position(self.unitaryDim*2,self.unitaryDim*2,self.unitaryDim*2, self.colors.green);

      self.goal = Position(length - self.unitaryDim*2,length - self.unitaryDim*2,length - self.unitaryDim*2,self.unitaryDim, self.colors.red);

      self.agent = agent;

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
                     self.vertices(1,1), self.vertices(2,1);
                     self.vertices(2,1), self.vertices(3,1);
                     self.vertices(3,1), self.vertices(4,1);
                     self.vertices(4,1), self.vertices(1,1);

                     self.vertices(2,1), self.vertices(3,1);
                     self.vertices(3,1), self.vertices(7,1);
                     self.vertices(7,1), self.vertices(6,1);
                     self.vertices(6,1), self.vertices(2,1);

                     self.vertices(3,1), self.vertices(4,1);
                     self.vertices(4,1), self.vertices(8,1);
                     self.vertices(8,1), self.vertices(7,1);
                     self.vertices(7,1), self.vertices(3,1);

                     self.vertices(4,1), self.vertices(1,1);
                     self.vertices(1,1), self.vertices(5,1);
                     self.vertices(5,1), self.vertices(8,1);
                     self.vertices(8,1), self.vertices(4,1);

                     self.vertices(1,1), self.vertices(2,1);
                     self.vertices(2,1), self.vertices(6,1);
                     self.vertices(6,1), self.vertices(5,1);
                     self.vertices(5,1), self.vertices(1,1);

                     self.vertices(5,1), self.vertices(6,1);
                     self.vertices(6,1), self.vertices(7,1);
                     self.vertices(7,1), self.vertices(8,1);
                     self.vertices(8,1), self.vertices(5,1);
      ];

    end

    function setMission(self, start, goal)
      self.start.coords.x = start(1,1);
      self.start.coords.y = start(2,1);
      self.start.coords.z = start(3,1);

      self.agent.q(1:3,1)= start(:,1);

      self.goal.coords.x = goal(1,1);
      self.goal.coords.y = goal(2,1);
      self.goal.coords.z = goal(3,1);
    end

    function runSimulation( self, planner , polynomials, timeTot)

      frame= self.length* 0.05;
      minAxis= 0 - frame;
      maxAxis= self.length + frame;
      figure('Name','Environment'),hold on;
      %axis([minAxis maxAxis minAxis maxAxis ]);
      axis([-100 100  -100 100] -100 100);
      title('world'), xlabel('x'), ylabel('y'), zlabel('z')

      for i= 1:size(self.borders,1)
        first=  self.borders(i,1);
        second=  self.borders(i,2);
        drawLine3d(self.drawer,first,second,self.colors.black);
      end

      numSteps = timeTot/self.clock.delta_t;
      data = zeros(numSteps, self.agent.dimState + 1 + self.agent.dimRef + self.agent.dimInput);
      draw(self);
      pause(0.5);
      index = 1;
      while self.clock.curr_t <= timeTot
        deleteDrawing(self.agent);

        agentData=  doAction(self.agent, planner );
        draw(agent);

        agentStateDim = size( agentData.state,1);
        data(index , 1:agentStateDim)= agentData.state';
        data(index, agentStateDim+1) = self.clock.curr_t;
        data(index, agentStateDim+2:agentStateDim+2+size(agentData.ref,1)-1)= agentData.ref';
        data(index, agentStateDim+2+size(agentData.ref,1):agentStateDim+2+size(agentData.ref,1)+size(agentData.u)-1)= agentData.u';


        pause(0.03);
        tick(self.clock);
        index = index +1;

        scatter3( self.agent.q(1,1), self.agent.q(2,1), self.agent.q(3,1), 8 ,[0.1,0.9,0.2]);
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

