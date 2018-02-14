classdef CamFrontUav  < Uav
  properties
    v
    m
    J

  end

  methods


    function self = CamFrontUav(q_0, color, clock )
      self@Uav(q_0, color, clock )
      self.m = 1;    %[kg]
      self.I = 1.0e-2;     %body             %[kg*m^2]
      self.J = 1.0e-3;     %camera           %[kg*m^2]
      self.v = 10; % constant velocity on the x-y plane
      self.dimState = size(q_0,1);
      self.dimInput = 3;
      self.dimRef= 3;
    end

    function q_dot= transitionModel( self, u)
      q3 = self.q(3,1);
      q4 = self.q(4,1);
      q6 = self.q(6,1);
      q8 = self.q(8,1);

      f= [
          self.v* cos(q3);
          self.v* sin(q3);
          q4;
          0;
          q6;
          0;
          q8;
          0
      ];

      g(4,1)= 1/self.I;
      g(6,2)= 1/self.m;
      g(8,3)= 1/self.J;


      q_dot= f + g*u;
    end

    function  data = doAction(self, ref ,stepNum)


      v = controller(self,ref);
      u= feedBackLin(self, v);

      q_dot= transitionModel(self, u);
      updateState(self, q_dot);


      data.state= self.q;
      data.v = v;
      data.u = u;
    end


    function v = controller(self,ref)
      %TODO
      v= 0;
    end


    function u = feedBackLin(self,v)
      q3 = self.q(3,1);
      q4 = self.q(4,1);
      q5 = self.q(5,1);
      q6 = self.q(6,1);
      q7 = self.q(7,1);
      q8 = self.q(8,1);

      A(1,1)= q8*(q4*q5*sin(q3)*(cot(q7)^2 + 1) - q6*cos(q3)*(cot(q7)^2 + 1) + 2*q5*q8*cos(q3)*cot(q7)*(cot(q7)^2 + 1)) - q4*(self.v*sin(q3) + q6*cot(q7)*sin(q3) - q5*q8*sin(q3)*(cot(q7)^2 + 1) + q4*q5*cos(q3)*cot(q7)) - q6*(q8*cos(q3)*(cot(q7)^2 + 1) + q4*cot(q7)*sin(q3));

      A(2,1)= q4*(self.v*cos(q3) + q6*cos(q3)*cot(q7) - q5*q8*cos(q3)*(cot(q7)^2 + 1) - q4*q5*cot(q7)*sin(q3)) - q6*(q8*sin(q3)*(cot(q7)^2 + 1) - q4*cos(q3)*cot(q7)) - q8*(q6*sin(q3)*(cot(q7)^2 + 1) + q4*q5*cos(q3)*(cot(q7)^2 + 1) - 2*q5*q8*cot(q7)*sin(q3)*(cot(q7)^2 + 1));

      A(3,1)=0;

      B=[
         -(q5*cot(q7)*sin(q3))/self.I, (cos(q3)*cot(q7))/self.m, -(q5*cos(q3)*(cot(q7)^2 + 1))/self.J;
         (q5*cos(q3)*cot(q7))/self.I, (cot(q7)*sin(q3))/self.m, -(q5*sin(q3)*(cot(q7)^2 + 1))/self.J;
         0,                 1/self.m,                               0;
      ];

      u = B\v - B\A ;
    end



    function draw(self)
      drawer = Drawer();
      scale = 0.9;

      vertices = [
                  - 1.0*scale, 0.6*scale, -0.2*scale ;
                  - 1.0*scale, -0.6*scale, -0.2*scale ;
                  3.5*scale, 0, -0.2*scale ;
                  0, 0 , 0.8*scale
                  5*scale, 0, 0 ;
      ];
      transl = [ self.q(1,1);self.q(2,1);self.q(5,1)];



      rotTheta = [
             cos(self.q(3,1)) , -sin(self.q(3,1)), 0;
             sin(self.q(3,1)) , cos(self.q(3,1)),  0;
             0     ,     0     ,     1      ;
      ];

      rotPhi= [
               cos(self.q(7,1))  ,    0    ,  sin(self.q(7,1));
               0                 ,    1    ,       0          ;
               - sin(self.q(7,1)),    0    ,  cos(self.q(7,1));
      ];

      for i = 1:size(vertices,1)-1
        newVertex = rotTheta*vertices(i,:)';
        vertices(i,:)= (newVertex+transl)';
      end
      newCamEnd = rotTheta*rotPhi* vertices( size(vertices, 1),:)';
      vertices(size(vertices,1),:) = (newCamEnd+transl)';



      oppositeColor = 1 - self.color;

      d1= drawLine3D(drawer, vertices(1,:) , vertices(2,:), oppositeColor);
      d2= drawLine3D(drawer, vertices(2,:) , vertices(3,:), oppositeColor);
      d3= drawLine3D(drawer, vertices(3,:) , vertices(1,:), oppositeColor);
      d4= drawLine3D(drawer, vertices(1,:) , vertices(4,:), self.color);
      d5= drawLine3D(drawer, vertices(2,:) , vertices(4,:), self.color);
      d6= drawLine3D(drawer, vertices(3,:) , vertices(4,:), self.color);
      d7= drawLine3D(drawer, transl' , vertices(5,:), self.color);

      self.drawing= [ d1;d2;d3;d4;d5;d6;d7];

      scatter3( self.q(1,1), self.q(2,1), self.q(5,1), 3 ,[0.8,0.2,0.8]);
    end

    function drawStatistics(~, data)
      figure('Name','State')

      ax1 = subplot(2,4,1);
      plot(data(:,9),data(:,1), '-o');
      title(ax1,'x axis');

      ax2 = subplot(2,4,2);
      plot(data(:,9),data(:,2), '-o');
      title(ax2,'y axis');

      ax3 = subplot(2,4,3);
      plot(data(:,9),data(:,3), '-o');
      title(ax3,'theta');

      ax4 = subplot(2,4,4);
      plot(data(:,9),data(:,4), '-o');
      title(ax4,'omega');

      ax5 = subplot(2,4,5);
      plot(data(:,9),data(:,5), 'r-o');
      title(ax5,'z axis');

      ax6 = subplot(2,4,6);
      plot(data(:,9),data(:,6), 'r-o');
      title(ax6,'vel z axis');

      ax7 = subplot(2,4,7);
      plot(data(:,9),data(:,7), 'r-o');
      title(ax7,'phi');

      ax8 = subplot(2,4,8);
      plot(data(:,9),data(:,8), 'r-o');
      title(ax8,'vel phi');

      figure('Name','References')

      ax1 = subplot(1,3,1);
      plot(data(:,9),data(:,10), '-o');
      title(ax1,'x axis');

      ax2 = subplot(1,3,2);
      plot(data(:,9),data(:,11), '-o');
      title(ax2,'y axis');

      ax3 = subplot(1,3,3);
      plot(data(:,9),data(:,12), '-o');
      title(ax3,'z axis');

      figure('Name','Inputs')

      ax1 = subplot(1,3,1);
      plot(data(:,9),data(:,13), '-o');
      title(ax1,'u1');

      ax2 = subplot(1,3,2);
      plot(data(:,9),data(:,14), '-o');
      title(ax2,'u2');

      ax3 = subplot(1,3,3);
      plot(data(:,9),data(:,15), '-o');
      title(ax3,'u3');

    end
  end
end
