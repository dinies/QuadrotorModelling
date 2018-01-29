classdef QuadRotor < handle
  properties
    q;
    delta_t;
    stateDim;
    M;
    I;
    d;
    g;
    t;
    vertices= zeros(6,3);
    lines_drawn= zeros(5,1);
    y;
  end
%              1 2 3  4    5    6  7  8  9   10  11   12 13 14
% State q = (  x y z phi theta psi dx dy dz zeta ksi  p  q  r );
  methods
    function self = QuadRotor( M, I, d,delta_t, q_0 )
      self.M = M;
      self.I = I;
      self.d= d; % distance of the center of mass from the rotors
      self.g = +9.81;
      self.q = q_0;
      self.delta_t = delta_t;
      self.stateDim = size(self.q , 1);
      self.y = zeros(6,1);
      self.t = 0;

    end
    function f = fFun(self)
      s_phi = sin(self.q(4,1));
      c_phi = cos(self.q(4,1));
      s_theta = sin(self.q(5,1));
      c_theta = cos(self.q(5,1));
      s_psi = sin(self.q(6,1));
      c_psi = cos(self.q(6,1));
      zeta = self.q(10);
      ksi = self.q(11);

      f = zeros(self.stateDim, 1);
      f(1,1)= self.q(7,1);
      f(2,1)= self.q(8,1);
      f(3,1)= self.q(9,1);
      f(4,1)= self.q(12,1);
      f(5,1)= self.q(13,1);
      f(6,1)= self.q(14,1);

      f(7,1)= -( c_psi*s_theta*c_phi + s_psi*s_phi) * zeta / self.M;
      f(8,1)= -( s_psi*s_theta*c_phi - c_psi*s_phi) * zeta / self.M;
      f(9,1)= -( c_theta*c_phi * zeta / self.M) + self.g;

      f(10,1)= ksi;
      f(11,1)= 0;

      f(12,1)= ( self.I(2,1) - self.I(3,1))* self.q(13,1)*self.q(14,1)/ self.I(1,1);
      f(13,1)= ( self.I(3,1) - self.I(1,1))* self.q(12,1)*self.q(14,1)/ self.I(2,1);
      f(14,1)= ( self.I(1,1) - self.I(2,1))* self.q(12,1)*self.q(13,1)/ self.I(3,1);

    end
    function g = gFun(self)

      g = zeros(self.stateDim, 4);
      g(11,1)= 1;
      g(12,2)= self.d/self.I(1,1);
      g(13,3)= self.d/self.I(2,1);
      g(14,4)= 1/self.I(3,1);

    end
    function q_dot = plantEvolution(self, u)

      %u_plant = u(self.t);

      q_dot = fFun(self) + gFun(self) * u;

      self.y = [self.q(1,1), self.q(2,1), self.q(3,1), self.q(4,1), self.q(5,1), self.q(6,1)]';

    end
    function updateState(self, q_dot )
      new_t= self.t+self.delta_t;

      for i= 1:self.stateDim
        integral = ode45( @(t, unused) q_dot(i,1) , [ self.t new_t], self.q(i,1));
        self.q(i,1)= deval( integral, new_t);
      end
    end

    function openLoop(self, u, tot_t , timeTraj )
      numOfSteps= tot_t / self.delta_t;
      data = zeros( numOfSteps , self.stateDim + 11);
      self.t= 0;

      figure('Name','World representation'),hold on;
      az = 135;
      el = 45;
      view(az, el);
      axis([-500 500 -500 500 -500 1500 ]);
      title('world'), xlabel('x'), ylabel('y'), zlabel('z')
      draw(self);



      for i= 1:numOfSteps

        eval = u(self.t);
        if self.t <= timeTraj
          curr_u = zeros(4,1);
          curr_u(1,1)= eval(3,1);
        end

        oldPos = self.q(1:3,1);
        q_dot = plantEvolution(self, curr_u);
        updateState(self, q_dot);
        newPos = self.q(1:3,1);
        data(i , 1:self.stateDim)= self.q;
        data(i, self.stateDim+1) = self.t;
        data(i, self.stateDim+2:self.stateDim+5)= curr_u';
        data(i, self.stateDim+6:self.stateDim+8)= q_dot(7:9,1)';
        data(i, self.stateDim+9:self.stateDim+11)= q_dot(12:14,1)';


        self.t = self.t + self.delta_t;
        del_lines_drawn(self);
        compute_vertices(self);
        draw(self);

        line( [oldPos(1,1),newPos(1,1) ],[oldPos(2,1),newPos(2,1) ],[oldPos(3,1),newPos(3,1) ],'LineWidth', 2,'Color',[0.1,0.9,0.2]);
        pause(0.0001);
      end
      draw_statistics( self, data, 0 , false);
    end




    function closedLoop(self, tot_t , trajPlanners, gains)
      numOfSteps = tot_t / self.delta_t;
      data = zeros( numOfSteps, self.stateDim + 15);
      self.t= 0;
     self.y = [self.q(1,1), self.q(2,1), self.q(3,1), self.q(4,1), self.q(5,1), self.q(6,1)]';


      for j= 1:size(trajPlanners,1)
        references(j,1)= getReferences( trajPlanners(j,1));
      end
      plotTrajectory(trajPlanners(3,1), references(3,1));
      % stub references
      %references =  zeros(4,5,numOfSteps);
      controller= PID( gains, numOfSteps );
      FBlin = FeedbackLinearizator( self.M, self.I);

      DiffBlock_x = DifferentiatorBlock(self.delta_t, 3 );
      DiffBlock_y = DifferentiatorBlock(self.delta_t, 3 );
      DiffBlock_z = DifferentiatorBlock(self.delta_t, 3 );
      DiffBlock_psi = DifferentiatorBlock(self.delta_t, 1 );

      figure('Name','World representation'),hold on;
      az = 135;
      el = 45;
      view(az, el);
      axis([-550 550 -550 550 -2550 2550 ]);
      title('world'), xlabel('x'), ylabel('y'), zlabel('z')
      draw(self);

      for i= 1:numOfSteps


        outputDeriv_xyz= [
        differentiate( DiffBlock_x, self.y(1,1))';
        differentiate( DiffBlock_y, self.y(2,1))';
        differentiate( DiffBlock_z, self.y(3,1))';
        ];
        outputDeriv_psi= differentiate( DiffBlock_psi, self.y(6,1));

        stateDiff = [ self.y(1:3,1), outputDeriv_xyz;
                      self.y(6,1), [ outputDeriv_psi 0 0];
                    ];

        referenceMat = extractCurrRefs(self, references, i);

        v_input = computeInput( controller, referenceMat, stateDiff , i);

        curr_u = computeInput( FBlin, v_input, self.q );

        oldPos = self.q(1:3,1);
        q_dot = plantEvolution(self, curr_u);
        updateState(self, q_dot);
        newPos = self.q(1:3,1);
        data(i , 1:self.stateDim)= self.q;
        data(i, self.stateDim+1) = self.t;
        data(i, self.stateDim+2:self.stateDim+5)= curr_u';
        data(i, self.stateDim+6:self.stateDim+8)= q_dot(7:9,1)';
        data(i, self.stateDim+9:self.stateDim+11)= q_dot(12:14,1)';
        data(i, self.stateDim+12:self.stateDim+15)= v_input';


        self.t = self.t + self.delta_t;
        del_lines_drawn(self);
        compute_vertices(self);
        draw(self);

        line( [oldPos(1,1),newPos(1,1) ],[oldPos(2,1),newPos(2,1) ],[oldPos(3,1),newPos(3,1) ],'LineWidth', 2,'Color',[0.1,0.9,0.2]);
        pause(0.0001);
      end
      draw_statistics( self, data, controller.errors , true);
    end

    function  ref = extractCurrRefs(~, refs, iterNum)
      ref = zeros( size(refs,1), 5);
      for i = 1:size(refs,1)
        ref(i,:) = [
                    refs(i,1).positions(iterNum);
                    refs(i,1).velocities(iterNum);
                    refs(i,1).accelerations(iterNum);
                    refs(i,1).jerks(iterNum);
                    refs(i,1).snaps(iterNum)
        ]';
      end
    end

    function draw_statistics(self, data, error, flag_error)
      figure('Name','Pose')

      ax1 = subplot(2,3,1);
      plot(data(:,self.stateDim+1),data(:,1), '-o');
      title(ax1,'x axis');

      ax2 = subplot(2,3,2);
      plot(data(:,self.stateDim+1),data(:,2), '-o');
      title(ax2,'y axis');

      ax3 = subplot(2,3,3);
      plot(data(:,self.stateDim+1),data(:,3), '-o');
      title(ax3,'z axis');

      ax4 = subplot(2,3,4);
      plot(data(:,self.stateDim+1),data(:,4), '-o');
      title(ax4,'phi (roll)');

      ax5 = subplot(2,3,5);
      plot(data(:,self.stateDim+1),data(:,5), 'r-o');
      title(ax5,'theta (pitch)');

      ax6 = subplot(2,3,6);
      plot(data(:,self.stateDim+1),data(:,6), 'r-o');
      title(ax6,'psi (yaw)');

      figure('Name','Velocities')

      ax1 = subplot(2,3,1);
      plot(data(:,self.stateDim+1),data(:,7), '-o');
      title(ax1,'x axis');

      ax2 = subplot(2,3,2);
      plot(data(:,self.stateDim+1),data(:,8), '-o');
      title(ax2,'y axis');

      ax3 = subplot(2,3,3);
      plot(data(:,self.stateDim+1),data(:,9), '-o');
      title(ax3,'z axis');

      ax4 = subplot(2,3,4);
      plot(data(:,self.stateDim+1),data(:,12), '-o');
      title(ax4,'phi (roll)');

      ax5 = subplot(2,3,5);
      plot(data(:,self.stateDim+1),data(:,13), 'r-o');
      title(ax5,'theta (pitch)');

      ax6 = subplot(2,3,6);
      plot(data(:,self.stateDim+1),data(:,14), 'r-o');
      title(ax6,'psi (yaw)');


      figure('Name','Accelerations')

      ax1 = subplot(2,3,1);
      plot(data(:,self.stateDim+1),data(:,self.stateDim+6), '-o');
      title(ax1,'x axis');

      ax2 = subplot(2,3,2);
      plot(data(:,self.stateDim+1),data(:,self.stateDim+7), '-o');
      title(ax2,'y axis');

      ax3 = subplot(2,3,3);
      plot(data(:,self.stateDim+1),data(:,self.stateDim+8), '-o');
      title(ax3,'z axis');

      ax4 = subplot(2,3,4);
      plot(data(:,self.stateDim+1),data(:,self.stateDim+9), '-o');
      title(ax4,'phi (roll)');

      ax5 = subplot(2,3,5);
      plot(data(:,self.stateDim+1),data(:,self.stateDim+10), 'r-o');
      title(ax5,'theta (pitch)');

      ax6 = subplot(2,3,6);
      plot(data(:,self.stateDim+1),data(:,self.stateDim+11), 'r-o');
      title(ax6,'psi (yaw)');

      if size(data,2) > self.stateDim+11
        figure('Name','Inputs to feedback linearizator')

        ax1 = subplot(2,2,1);
        plot(data(:,self.stateDim+1),data(:,self.stateDim+12), '-o');
        title(ax1,'v1  (ddddx)');

        ax2 = subplot(2,2,2);
        plot(data(:,self.stateDim+1),data(:,self.stateDim+13), '-o');
        title(ax2,'v2  (ddddy)');

        ax3 = subplot(2,2,3);
        plot(data(:,self.stateDim+1),data(:,self.stateDim+14), '-o');
        title(ax3,'v3  (ddddz)');

        ax4 = subplot(2,2,4);
        plot(data(:,self.stateDim+1),data(:,self.stateDim+15), '-o');
        title(ax4,'v4  (ddpsi)');

      end

      figure('Name','Inputs to the plant')
      ax1 = subplot(2,3,1);
      plot(data(:,self.stateDim+1),data(:,10), '-o');
      title(ax1,'zeta');

      ax2 = subplot(2,3,2);
      plot(data(:,self.stateDim+1),data(:,11), '-o');
      title(ax2,'ksi');

      ax3 = subplot(2,3,3);
      plot(data(:,self.stateDim+1),data(:,self.stateDim+2), '-o');
      title(ax3,'u1  (ddT)');

      ax4 = subplot(2,3,4);
      plot(data(:,self.stateDim+1),data(:,self.stateDim+3), '-o');
      title(ax4,'u2 (tau x)');

      ax5 = subplot(2,3,5);
      plot(data(:,self.stateDim+1),data(:,self.stateDim+4), '-o');
      title(ax5,'u3 (tau y)');

      ax6 = subplot(2,3,6);
      plot(data(:,self.stateDim+1),data(:,self.stateDim+5), '-o');
      title(ax6,'u4 (tau z)');


      if flag_error

        figure('Name','Proportional Error positions')
        ax1 = subplot(2,2,1);
        plot(data(:,self.stateDim+1),reshape( error( 1,1,:),size(data,1),1), 'r-o');
        title(ax1,'x');

        ax2 = subplot(2,2,2);
        plot(data(:,self.stateDim+1),reshape( error( 2,1,:),size(data,1),1), 'r-o');
        title(ax2,'y');

        ax3 = subplot(2,2,3);
        plot(data(:,self.stateDim+1),reshape( error( 3,1,:),size(data,1),1), 'r-o');
        title(ax3,'z');

        ax4 = subplot(2,2,4);
        plot(data(:,self.stateDim+1),reshape( error( 4,1,:),size(data,1),1), 'r-o');
        title(ax4,'psi');


        figure('Name','Proportional Error velocities')
        ax1 = subplot(2,2,1);
        plot(data(:,self.stateDim+1),reshape( error( 1,2,:),size(data,1),1), 'r-o');
        title(ax1,'x');

        ax2 = subplot(2,2,2);
        plot(data(:,self.stateDim+1),reshape( error( 2,2,:),size(data,1),1), 'r-o');
        title(ax2,'y');

        ax3 = subplot(2,2,3);
        plot(data(:,self.stateDim+1),reshape( error( 3,2,:),size(data,1),1), 'r-o');
        title(ax3,'z');

        ax4 = subplot(2,2,4);
        plot(data(:,self.stateDim+1),reshape( error( 4,2,:),size(data,1),1), 'r-o');
        title(ax4,'psi');

        figure('Name','Proportional Error accelerations')
        ax1 = subplot(2,2,1);
        plot(data(:,self.stateDim+1),reshape( error( 1,3,:),size(data,1),1), 'r-o');
        title(ax1,'x');

        ax2 = subplot(2,2,2);
        plot(data(:,self.stateDim+1),reshape( error( 2,3,:),size(data,1),1), 'r-o');
        title(ax2,'y');

        ax3 = subplot(2,2,3);
        plot(data(:,self.stateDim+1),reshape( error( 3,3,:),size(data,1),1), 'r-o');
        title(ax3,'z');

        ax4 = subplot(2,2,4);
        plot(data(:,self.stateDim+1),reshape( error( 4,3,:),size(data,1),1), 'r-o');
        title(ax4,'psi');



        figure('Name','Proportional Error jerks')
        ax1 = subplot(2,2,1);
        plot(data(:,self.stateDim+1),reshape( error( 1,4,:),size(data,1),1), 'r-o');
        title(ax1,'x');

        ax2 = subplot(2,2,2);
        plot(data(:,self.stateDim+1),reshape( error( 2,4,:),size(data,1),1), 'r-o');
        title(ax2,'y');

        ax3 = subplot(2,2,3);
        plot(data(:,self.stateDim+1),reshape( error( 3,4,:),size(data,1),1), 'r-o');
        title(ax3,'z');

        ax4 = subplot(2,2,4);
        plot(data(:,self.stateDim+1),reshape( error( 4,4,:),size(data,1),1), 'r-o');
        title(ax4,'psi');

        figure('Name','Integrative Error position')
        ax1 = subplot(2,2,1);
        plot(data(:,self.stateDim+1),reshape( error( 1,5,:),size(data,1),1), 'r-o');
        title(ax1,'x');

        ax2 = subplot(2,2,2);
        plot(data(:,self.stateDim+1),reshape( error( 2,5,:),size(data,1),1), 'r-o');
        title(ax2,'y');

        ax3 = subplot(2,2,3);
        plot(data(:,self.stateDim+1),reshape( error( 3,5,:),size(data,1),1), 'r-o');
        title(ax3,'z');

        ax4 = subplot(2,2,4);
        plot(data(:,self.stateDim+1),reshape( error( 4,5,:),size(data,1),1), 'r-o');
        title(ax4,'psi');

      end
    end

    function draw(self)
      self.lines_drawn(1,1)= get_line_between_vert(self,1,2);
      self.lines_drawn(2,1)= get_line_between_vert(self,2,3);
      self.lines_drawn(3,1)= get_line_between_vert(self,3,4);
      self.lines_drawn(4,1)= get_line_between_vert(self,4,1);
      self.lines_drawn(5,1)= get_line_between_vert(self,5,6);
    end

    function compute_vertices(self)
	    self.vertices(1,:)= [self.q(1,1)+5,self.q(2,1)-5,self.q(3,1)];
	    self.vertices(2,:)= [self.q(1,1)+5,self.q(2,1)+5,self.q(3,1)];
	    self.vertices(3,:)= [self.q(1,1)-5,self.q(2,1)+5,self.q(3,1)];
	    self.vertices(4,:)= [self.q(1,1)-5,self.q(2,1)-5,self.q(3,1)];
	    self.vertices(5,:)= [self.q(1,1),self.q(2,1),self.q(3,1)+3];
	    self.vertices(6,:)= [self.q(1,1),self.q(2,1),self.q(3,1)-5];

    end

    function l= get_line_between_vert(self, first, second)
      l= line( [ self.vertices(first,1), self.vertices(second,1)],[self.vertices(first,2), self.vertices(second,2)],[ self.vertices(first,3), self.vertices(second,3)],'LineWidth', 2);
    end

    function del_lines_drawn(self)
      for i= 1:size(self.lines_drawn,1)
        delete(self.lines_drawn(i,1));
      end
    end



  end
end
