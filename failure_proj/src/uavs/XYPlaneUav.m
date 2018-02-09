classdef XYPlaneUav  < Uav
  properties
    h

  end

  methods


    function self = XYPlaneUav(q_0, h , color, clock )

      self@Uav(q_0, color, clock )
      self.h= h;


    end

    function q_dot= transitionModel( self, u)

      u_ksi = u(1,1);
      u_phi = u(2,1);

      q3 = self.q(3,1);
      q4 = self.q(4,1);
      q5 = self.q(5,1);
      q6 = self.q(6,1);

      q_dot= [
              q5* cos(q3);
              q5* sin(q3);
              - self.g*tan(q4)/q5;
              u_phi;
              q6;
              u_ksi;
      ];

    end

    function u = feedBackLin(self,ref)
      q3 = self.q(3,1);
      q4 = self.q(4,1);
      q5 = self.q(5,1);
      q6 = self.q(6,1);
      grav = self.g;

      A =[
          (grav*tan(q4)*(q6*sin(q3) - grav*cos(q3)*tan(q4)))/q5;
          -(grav*tan(q4)*(q6*cos(q3) + grav*sin(q3)*tan(q4)))/q5
      ];
      B =[
          grav*sin(q3)*(tan(q4)^2 + 1), cos(q3)/self.I;
          -grav*cos(q3)*(tan(q4)^2 + 1), sin(q3)/self.I
      ];

      u = B\ref - B\A ;
    end


    function ref = chooseReference(self,polys)
                               %TODO think to something more robust
                               %      ref = [ self(1,1); self.q(2,1) ] + 0.01*f;

      poly_x= polys(1,1);
      poly_x= poly_x{:};
      poly_y= polys(1,2);
      poly_y= poly_y{:};
      refs(1,:)= poly_x( self.clock.curr_t)';
      refs(2,:)= poly_y( self.clock.curr_t)';
      ref = [ refs(1,1); refs(2,1)];

    end

    function draw(self)
      drawer = Drawer();
      scale = 0.8;

      vertices = [
                  - 1.0*scale, 0.6*scale, -0.2*scale ;
                  - 1.0*scale, -0.6*scale, -0.2*scale ;
                  3.5*scale, 0, -0.2*scale ;
                  0, 0 , 0.8*scale
      ];


      rotTheta = [
                  cos(self.q(3,1)) , -sin(self.q(3,1)), 0;
                  sin(self.q(3,1)) , cos(self.q(3,1)),  0;
                  0     ,     0     ,     1      ;
      ];

      transl = [ self.q(1,1);self.q(2,1);self.h];
      for i = 1:size(vertices,1)
        newVertex = rotTheta*vertices(i,:)';
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

      ax1 = subplot(2,3,1);
      plot(data(:,7),data(:,1), '-o');
      title(ax1,'x axis');

      ax2 = subplot(2,3,2);
      plot(data(:,7),data(:,2), '-o');
      title(ax2,'y axis');

      ax3 = subplot(2,3,3);
      plot(data(:,7),data(:,3), '-o');
      title(ax3,'psi');

      ax4 = subplot(2,3,4);
      plot(data(:,7),data(:,4), '-o');
      title(ax4,'phi');

      ax5 = subplot(2,3,5);
      plot(data(:,7),data(:,5), 'r-o');
      title(ax5,'v');

      ax6 = subplot(2,3,6);
      plot(data(:,7),data(:,6), 'r-o');
      title(ax6,'ksi');


      figure('Name','References and Inputs')

      ax1 = subplot(2,2,1);
      plot(data(:,7),data(:,8), '-o');
      title(ax1,'x axis');

      ax2 = subplot(2,2,2);
      plot(data(:,7),data(:,9), '-o');
      title(ax2,'y axis');

      ax3 = subplot(2,2,3);
      plot(data(:,7),data(:,10), '-o');
      title(ax3,'u1');

      ax4 = subplot(2,2,4);
      plot(data(:,7),data(:,11), '-o');
      title(ax4,'u2');


    end
  end
end
