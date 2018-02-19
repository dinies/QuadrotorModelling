classdef CamUav  < Uav
  properties
    vel
    m
    J
    gammaDotSym
    diffBlocks

  end
  methods( Static = true,Abstract)
    computeGammaDot()
  end
  methods(Abstract)
    gamma(self)
  end

  methods
    function self = CamUav(q_0, color, clock )
      self@Uav(q_0, color, clock )
      self.m = 1;    %[kg]
      self.I = 1.0e-2;     %body             %[kg*m^2]
      self.J = 1.0e-3;     %camera           %[kg*m^2]
      self.vel = 10; % constant velocity on the x-y plane
      self.dimState = size(q_0,1);
      self.dimInput = 3;
      self.dimRef= 3;
      self.gammaDotSym = CamFrontUav.computeGammaDot();
      self.diffBlocks= {
                        DifferentiatorBlock(self.clock.delta_t,1);
                        DifferentiatorBlock(self.clock.delta_t,1);
                        DifferentiatorBlock(self.clock.delta_t,1);
      };
    end


    function gs= gammaState(self)
      gs = [
            self.q(1,1);
            self.q(2,1);
            self.q(3,1);
            self.q(5,1);
            self.q(7,1)
      ];
    end

    function gDot = gammaDot(self)
      q_g = gammaState(self);
      gDot = self.gammaDotSym( q_g(1,1),q_g(2,1),q_g(3,1),q_g(4,1), q_g(5,1));
    end

    function q_dot= transitionModel( self, u)
      q3 = self.q(3,1);
      q4 = self.q(4,1);
      q6 = self.q(6,1);
      q8 = self.q(8,1);

      f= [
          self.vel* cos(q3);
          self.vel* sin(q3);
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

      R = zeros(size(ref,1),1);
      for i = 1:size(ref,1)
        R(i,1)= ref(i,1).positions(stepNum,1);
      end

      v = controller(self,R);
      u= feedBackLin(self, v);

      q_dot= transitionModel(self, u);
      updateState(self, q_dot);


      data.state= self.q;
      data.v = v;
      data.u = u;
    end


    function v = controller(self,R)
      E =  (gamma(self) - R )+ gammaDot(self);

      E_dot= zeros(size(E,1),1);
      for i = 1:size(self.diffBlocks,1)
        diffBlock= self.diffBlocks{i};
        E_dot(i,1)= differentiate(diffBlock ,E(i,1));
      end
      v= E_dot;
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

      figure('Name','v (inputs to feedbacklin)')

      ax1 = subplot(1,3,1);
      plot(data(:,9),data(:,10), '-o');
      title(ax1,'x axis');

      ax2 = subplot(1,3,2);
      plot(data(:,9),data(:,11), '-o');
      title(ax2,'y axis');

      ax3 = subplot(1,3,3);
      plot(data(:,9),data(:,12), '-o');
      title(ax3,'z axis');

      figure('Name','u (inputs to plant)')

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
