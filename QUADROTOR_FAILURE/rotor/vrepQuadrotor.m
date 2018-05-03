classdef vrepQuadrotor < handle
  properties
    q;
    delta_t;
    stateDim;
    M;
    I;
    d;
    g;
    clock;
    vertices= zeros(6,3);
    lines_drawn= zeros(5,1);
    y;
    drag;
  end

  methods( Static = true)
    function  ref = extractCurrRefs(refs, iterNum)
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
  end

                %              1 2 3  4    5    6  7  8  9   10  11   12 13 14
                % State q = (  x y z phi theta psi dx dy dz zeta ksi  p  q  r );

  methods
    function self = vrepQuadrotor( M, I, d,delta_t, q_0 )
      self.M = M;
      self.I = I;
      self.d= d; % distance of the center of mass from the rotors
      self.g = -9.81;
      self.q = q_0;
      self.delta_t = delta_t;
      self.stateDim = size(self.q , 1);
      self.y = self.q(1:6,1);
      self.drag = 2.4*10^-3;
      self.clock = Clock(delta_t);

    end

    function vRepLoop(self, tot_t, trajPlanners, gains)

      numOfSteps = tot_t / self.delta_t;
      for i= 1:size(trajPlanners,1)
        references(i,1)= getReferences( trajPlanners(i,1));
      end
      controller= PID( gains, numOfSteps );

      FBlin = FeedbackLinearizator( self.M, self.I ,self.d);

      DiffBlock_x = DifferentiatorBlock(self.clock.delta_t, 3 );
      DiffBlock_y = DifferentiatorBlock(self.clock.delta_t, 3 );
      DiffBlock_z = DifferentiatorBlock(self.clock.delta_t, 3 );
      DiffBlock_psi = DifferentiatorBlock(self.clock.delta_t, 1 );
      IntegrBlock_thrust = IntegratorBlock(self.clock.delta_t, 1);
      DoubleIntegrBlock_thrust = IntegratorBlock(self.clock.delta_t, 2);


      data = zeros( numOfSteps, 1+5+5+5+3+4+4+2+4+6);

      vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
      vrep.simxFinish(-1); % just in case, close all opened connections
      clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);
                                %check for connection
      if (clientID>-1)
        disp('Connected to remote API server');

        vrep.simxSynchronous(clientID,true);
        vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot);

        [returnCode,quadBase]=vrep.simxGetObjectHandle(clientID,'Quadricopter_base',vrep.simx_opmode_blocking);
        [returnCode,floor]=vrep.simxGetObjectHandle(clientID,'ResizableFloor_5_25',vrep.simx_opmode_blocking);



        [returnCode,position]=vrep.simxGetObjectPosition(clientID,quadBase,floor,vrep.simx_opmode_streaming);
        [returnCode,orientation]=vrep.simxGetObjectOrientation(clientID,quadBase,floor,vrep.simx_opmode_streaming);
        [returnCode,translationalVel, angularVel]=vrep.simxGetObjectVelocity(clientID,quadBase,vrep.simx_opmode_streaming);

        inputInts=[];
        inputStrings='';
        inputBuffer= [];



        for i=1:numOfSteps

          outputDeriv_xyz= [
                            differentiate( DiffBlock_x, self.y(1,1))';
                            differentiate( DiffBlock_y, self.y(2,1))';
                            differentiate( DiffBlock_z, self.y(3,1))';
          ];
          outputDeriv_psi= differentiate( DiffBlock_psi, self.y(6,1));

          stateDiff = [ self.y(1:3,1), outputDeriv_xyz;
                        self.y(6,1), [ outputDeriv_psi 0 0];
                      ];

          referenceMat = vrepQuadrotor.extractCurrRefs(references, i);
          orderOfInput = [5;5;5;3];

          % v_input : dddddx, dddddy, dddddz, dddpsi
          v_input = computeInput( controller, referenceMat, stateDiff , orderOfInput , i);

          %u_input : ddT , tauX, tauY, tauZ
          u_input = computeInput( FBlin, v_input, self.q );
          currThrust =[ DoubleIntegrBlock_thrust.integrate( u_input(1,1)), IntegrBlock_thrust.integrate( u_input(1,1))];
          u = [ currThrust(1,1) ; u_input(2:4,1)];
          %thrusts : f1 , f2 , f3 , f4
          thrusts = self.mapToThrusts(u );
          inputThrusts =  thrusts';

%also remeber that the thrusts have to be reoriented accordingly to the pose of the quandrotor so we have to compute rotation matrices R(phi,theta,psi) and apply them to the thrust vectors (maybe is better to send vectors already rotated to vrep internal functions)
          [returnCode,~,~,~,~]=vrep.simxCallScriptFunction(clientID,'Quadricopter',vrep.sim_scripttype_childscript,'actuateQuadrotor',inputInts,inputThrusts,inputStrings,inputBuffer,vrep.simx_opmode_blocking);

          vrep.simxSynchronousTrigger(clientID);
          % get the nominal output ( after that we should remove this information since it may not be directly observable and try to use an extimate from a filtering of measurements of sensors such as IMU)
          [returnCode,position]=vrep.simxGetObjectPosition(clientID,quadBase,floor,vrep.simx_opmode_buffer);
          [returnCode,orientation]=vrep.simxGetObjectOrientation(clientID,quadBase,floor,vrep.simx_opmode_buffer);
          [returnCode,translationalVel, angularVel]=vrep.simxGetObjectVelocity(clientID,quadBase,vrep.simx_opmode_buffer);


          data(i, :)= [self.clock.curr_t,referenceMat(1,:),referenceMat(2,:),referenceMat(3,:),referenceMat(4,1:3),v_input',u_input',currThrust,inputThrusts,self.y'];


          % TODO     change this real values into extimations with a filter like kalman etc
          self.y = [position, orientation]';

                % State q = (  x y z phi theta psi dx dy dz zeta ksi  p  q  r );
          self.q = [ position, orientation,translationalVel, currThrust, angularVel]';

          self.clock.tick();


        end
        vrep.simxStopSimulation(clientID,vrep.simx_opmode_blocking);

        vrep.simxFinish(clientID);

        self.draw_stats_vrep(data,controller)
      end
      vrep.delete(); % call the destructor!
    end


                    %input u : T, tauX, tauY, tauZ   --> output : T1, T2, T3, T4
    function res = mapToThrusts(self, u )

      M = [
           1,1,1,1;
           0, -self.d, 0, self.d;
           -self.d, 0, self.d,0;
           self.drag,-self.drag,self.drag,-self.drag
      ];
      res = inv(M)*u;
    end



    function draw_stats_vrep(~,data,controller)
      orange =[0.88,0.45,0.02];
      green=[0.66,0.88,0.02];
      turquoise=[0.02,0.88,0.88];
      blue=[0.02,0.45,0.88];
      violet= [0.45, 0.02,0.88];
      red = [ 0.88, 0.02, 0.02];

      %data : t, 5refsX, 5refsY, 5refsZ, 3refsPsi, 4fromController, 4fromFBlin, 2fromIntegratorThrust, 4FromThrustMap, 6fromOutputPlant
      %       1 , 2 : 6, 7 : 11, 12 : 16, 17 : 19 , 20 : 23         , 24 : 27 ,    28  :  29      ,     30  : 33 ,       34  :   39
      figure('Name','Inputs and outputs','pos',[10 10 1900 1200]),hold on;

      ax1 = subplot(3,3,1);hold on
      plot(data(:,1),data(:,2),'Color', orange);
      plot(data(:,1),data(:,7),'Color', green);
      plot(data(:,1),data(:,12),'Color', turquoise);
      plot(data(:,1),data(:,17),'Color', blue);
      title(ax1,'input positions from references');
      legend('x','y','z','psi','Location','southwest')


      ax2 = subplot(3,3,2);hold on
      plot(data(:,1),data(:,3),'Color', orange);
      plot(data(:,1),data(:,8),'Color', green);
      plot(data(:,1),data(:,13),'Color', turquoise);
      plot(data(:,1),data(:,18),'Color', blue);
      title(ax2,'input velocities from references');
      legend('dx','dy','dz','dpsi','Location','southwest')

      ax3 = subplot(3,3,3);hold on
      plot(data(:,1),data(:,4),'Color', orange);
      plot(data(:,1),data(:,9),'Color', green);
      plot(data(:,1),data(:,14),'Color', turquoise);
      plot(data(:,1),data(:,19),'Color', blue);
      title(ax3,'input accelerations from references');
      legend('ddx','ddy','ddz','ddpsi','Location','southwest')

      ax4 = subplot(3,3,4);hold on
      plot(data(:,1),data(:,5),'Color', orange);
      plot(data(:,1),data(:,10),'Color', green);
      plot(data(:,1),data(:,15),'Color', turquoise);
      title(ax4,'input jerks from references');
      legend('dddx','dddy','dddz','Location','southwest')

      ax5 = subplot(3,3,5);hold on
      plot(data(:,1),data(:,6),'Color', orange);
      plot(data(:,1),data(:,11),'Color', green);
      plot(data(:,1),data(:,16),'Color', turquoise);
      title(ax5,'input snaps from references');
      legend('ddddx','ddddy','ddddz','Location','southwest')

      ax6 = subplot(3,3,6);hold on
      plot(data(:,1),data(:,20),'Color', orange);
      plot(data(:,1),data(:,21),'Color', green);
      plot(data(:,1),data(:,22),'Color', turquoise);
      plot(data(:,1),data(:,23),'Color', blue);
      title(ax6,'output from controller');
      legend('ddddx','ddddy','ddddz','ddpsi','Location','southwest')

      ax7 = subplot(3,3,7);hold on
      plot(data(:,1),data(:,24),'Color', orange);
      plot(data(:,1),data(:,28),'Color', green);
      plot(data(:,1),data(:,29),'Color', turquoise);
      plot(data(:,1),data(:,25),'Color', blue);
      plot(data(:,1),data(:,26),'Color', violet);
      plot(data(:,1),data(:,27),'Color', red);
      title(ax7,'output from feedback linearization');
      legend('ddT','dT','T','tauX','tauY','tauZ','Location','southwest')

      ax8 = subplot(3,3,8);hold on
      plot(data(:,1),data(:,30),'Color', orange);
      plot(data(:,1),data(:,31),'Color', green);
      plot(data(:,1),data(:,32),'Color', turquoise);
      plot(data(:,1),data(:,33),'Color', blue);
      title(ax8,'output thrust map');
      legend('f1','f2','f3','f4','Location','southwest')

      ax9 = subplot(3,3,9);hold on
      plot(data(:,1),data(:,34),'Color', orange);
      plot(data(:,1),data(:,35),'Color', green);
      plot(data(:,1),data(:,36),'Color', turquoise);
      plot(data(:,1),data(:,37),'Color', blue);
      plot(data(:,1),data(:,38),'Color', violet);
      plot(data(:,1),data(:,39),'Color', red);
      title(ax9,'output plant');
      legend('x','y','z','phi','theta','psi','Location','southwest')


      figure('Name','Controller Errors','pos',[10 10 1900 1200]),hold on;

      error = controller.errors;

      ax1 = subplot(2,3,1);hold on
      plot(data(:,1),reshape( error( 1,1,:),size(data,1),1),'Color', red );
      plot(data(:,1),reshape( error( 2,1,:),size(data,1),1),'Color', green);
      plot(data(:,1),reshape( error( 3,1,:),size(data,1),1),'Color', blue );
      plot(data(:,1),reshape( error( 4,1,:),size(data,1),1),'Color', orange);
      title(ax1,'prop on position');
      legend('x','y','z','psi','Location','southwest')


      ax2 = subplot(2,3,2);hold on
      plot(data(:,1),reshape( error( 1,2,:),size(data,1),1),'Color', red );
      plot(data(:,1),reshape( error( 2,2,:),size(data,1),1),'Color', green);
      plot(data(:,1),reshape( error( 3,2,:),size(data,1),1),'Color', blue );
      plot(data(:,1),reshape( error( 4,2,:),size(data,1),1),'Color', orange);
      title(ax2,'prop on velocities');
      legend('dx','dy','dz','dpsi','Location','southwest')


      ax3 = subplot(2,3,3);hold on
      plot(data(:,1),reshape( error( 1,3,:),size(data,1),1),'Color', red );
      plot(data(:,1),reshape( error( 2,3,:),size(data,1),1),'Color', green);
      plot(data(:,1),reshape( error( 3,3,:),size(data,1),1),'Color', blue );
      plot(data(:,1),reshape( error( 4,3,:),size(data,1),1),'Color', orange);
      title(ax3,'prop on accelerations');
      legend('ddx','ddy','ddz','ddpsi','Location','southwest')

      ax4 = subplot(2,3,4);hold on
      plot(data(:,1),reshape( error( 1,4,:),size(data,1),1),'Color', red );
      plot(data(:,1),reshape( error( 2,4,:),size(data,1),1),'Color', green);
      plot(data(:,1),reshape( error( 3,4,:),size(data,1),1),'Color', blue );
      title(ax4,'prop on jerks');
      legend('dddx','dddy','dddz','Location','southwest')



      ax5 = subplot(2,3,5);hold on
      plot(data(:,1),reshape( error( 1,5,:),size(data,1),1),'Color', red );
      plot(data(:,1),reshape( error( 2,5,:),size(data,1),1),'Color', green);
      plot(data(:,1),reshape( error( 3,5,:),size(data,1),1),'Color', blue );
      title(ax5,'integrative on position');
      legend('ddddx','ddddy','ddddz','Location','southwest')
    end
  end
end

