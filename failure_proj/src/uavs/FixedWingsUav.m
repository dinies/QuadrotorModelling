classdef FixedWingsUav < Uav
  properties
    h
    radius
    coords
    v_max
    u_phi_max
    primitives
  end

  methods
    function self = FixedWingsUav (q_0, h , color, clock, v_max, u_phi_max, radius)
      self@Uav(q_0, color, clock )
      self.h= h;
      self.v_max = v_max;
      self.u_phi_max = u_phi_max;
      self.primitives = [
                         v_max, 0;
                         v_max, u_phi_max;
                         v_max, -u_phi_max
      ];
      self.coords.x = q_0(1,1);
      self.coords.y = q_0(2,1);
      self.coords.z = 0;
      self.radius = radius;
    end


    function q_dot= transitionModel( self, u)

      % q :  x  ,  y ,  psi  ,  phi

      v = u(1,1);
      u_phi = u(2,1);

      q3 = self.q(3,1);
      q4 = self.q(4,1);

      q_dot= [
              v* cos(q3);
              v* sin(q3);
              - self.g*tan(q4)/v;
              u_phi;
      ];
    end

    function updateState(self, q_dot)
      new_t= self.clock.curr_t+self.clock.delta_t;
      for i= 1:size(self.q,1)
        integral = ode45( @(t, unused) q_dot(i,1) , [ self.clock.curr_t new_t], self.q(i,1));
        self.q(i,1)= deval( integral, new_t);
      end
      self.coords.x = self.q(1,1);
      self.coords.y = self.q(2,1);
    end

    function  data = doAction(self, primitives, stepNum)
      u = primitives(stepNum,:)';
      q_dot= transitionModel(self, u);
      updateState(self, q_dot);
      data.state= self.q;
    end




    function setUavState(self, conf, time)
      self.q = conf;
      self.coords.x = conf(1,1);
      self.coords.y = conf(2,1);
      self.clock.curr_t = time;
    end


    function res = generatePrimitives(self,node)
      currConf = node.value.conf;
      currTime = node.value.time;
      res = {};
      for i = 1:size(self.primitives,1)
        setUavState(self,currConf,currTime );
        currInput = self.primitives(i,:)';
        newQDot = transitionModel(self, currInput );
        updateState(self, newQDot);
        newConf = self.q;
        tick(self.clock);
        struct.conf = newConf;
        struct.pastInput = currInput;
        struct.time = self.clock.curr_t;
        struct.burned = false;
        elem  = Node( struct );
        res = Node.addInTail(elem, res);
      end
    end





    function draw(self)
      drawer = Drawer();
      scale = 1.8;

      vertices = [
                  - 1.0*scale, 1.6*scale, -0.2*scale ;
                  - 1.0*scale, -1.6*scale, -0.2*scale ;
                  3.5*scale, 0, -0.2*scale ;
                  0, 0 , 0.8*scale
      ];


      rotPsi= [
                  cos(self.q(3,1)) , -sin(self.q(3,1)), 0;
                  sin(self.q(3,1)) , cos(self.q(3,1)),  0;
                  0     ,     0     ,     1      ;
      ];

      transl = [ self.q(1,1);self.q(2,1);self.h];
      for i = 1:size(vertices,1)
        newVertex = rotPsi*vertices(i,:)';
        vertices(i,:)= (newVertex+transl)';
      end

      oppositeColor = 1 - self.color;

      d1= drawLine3D(drawer, vertices(1,:) , vertices(2,:), oppositeColor);
      d2= drawLine3D(drawer, vertices(2,:) , vertices(3,:), oppositeColor);
      d3= drawLine3D(drawer, vertices(3,:) , vertices(1,:), oppositeColor);
      d4= drawLine3D(drawer, vertices(1,:) , vertices(4,:), self.color);
      d5= drawLine3D(drawer, vertices(2,:) , vertices(4,:), self.color);
      d6= drawLine3D(drawer, vertices(3,:) , vertices(4,:), self.color);

      self.drawing= [ d1;d2;d3;d4;d5;d6];

      scatter3( self.q(1,1), self.q(2,1), self.h, 3 ,[0.8,0.2,0.2]);
    end

    function drawStatistics(self, data)

      figure('Name','State')

      ax1 = subplot(2,2,1);
      plot(data(:,5),data(:,1), '-o');
      title(ax1,'x axis');

      ax2 = subplot(2,2,2);
      plot(data(:,5),data(:,2), '-o');
      title(ax2,'y axis');

      ax3 = subplot(2,2,3);
      plot(data(:,5),data(:,3), '-o');
      title(ax3,'psi');

      ax4 = subplot(2,2,4);
      plot(data(:,5),data(:,4), '-o');
      title(ax4,'phi');

    end
  end
end
