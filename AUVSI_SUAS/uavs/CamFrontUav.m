classdef CamFrontUav  < CamUav

  methods( Static = true)
    function gammaDot= computeGammaDot()
      syms q1 q2 q3 q5 q7;
      state = [q1;q2;q3;q5;q7];
      gammaFun =  [
                   q1+ q5 * cot(q7)* cos(q3);
                   q2+ q5 * cot(q7)* sin(q3);
                   q5
                  ];
      gammaNabla = jacobian(gammaFun);
      gammaDot = matlabFunction(gammaNabla*state);
    end
  end

  methods
    function self = CamFrontUav(q_0, color, clock )
      self@CamUav(q_0, color, clock )
    end


    function gamma = gamma(self)
      gamma(1,1) = self.q(1,1) + self.q(5,1)*cot(self.q(7,1))*cos(self.q(3,1));
      gamma(2,1) = self.q(2,1) + self.q(5,1)*cot(self.q(7,1))*sin(self.q(3,1));
      gamma(3,1) = self.q(5,1);
    end

    function u = feedBackLin(self,v)
      q3 = self.q(3,1);
      q4 = self.q(4,1);
      q5 = self.q(5,1);
      q6 = self.q(6,1);
      q7 = self.q(7,1);
      q8 = self.q(8,1);

      A(1,1)= q8*(q4*q5*sin(q3)*(cot(q7)^2 + 1) - q6*cos(q3)*(cot(q7)^2 + 1) + 2*q5*q8*cos(q3)*cot(q7)*(cot(q7)^2 + 1)) - q4*(self.vel*sin(q3) + q6*cot(q7)*sin(q3) - q5*q8*sin(q3)*(cot(q7)^2 + 1) + q4*q5*cos(q3)*cot(q7)) - q6*(q8*cos(q3)*(cot(q7)^2 + 1) + q4*cot(q7)*sin(q3));

      A(2,1)= q4*(self.vel*cos(q3) + q6*cos(q3)*cot(q7) - q5*q8*cos(q3)*(cot(q7)^2 + 1) - q4*q5*cot(q7)*sin(q3)) - q6*(q8*sin(q3)*(cot(q7)^2 + 1) - q4*cos(q3)*cot(q7)) - q8*(q6*sin(q3)*(cot(q7)^2 + 1) + q4*q5*cos(q3)*(cot(q7)^2 + 1) - 2*q5*q8*cot(q7)*sin(q3)*(cot(q7)^2 + 1));

      A(3,1)=0;

      B=[
         -(q5*cot(q7)*sin(q3))/self.I, (cos(q3)*cot(q7))/self.m, -(q5*cos(q3)*(cot(q7)^2 + 1))/self.J;
         (q5*cos(q3)*cot(q7))/self.I, (cot(q7)*sin(q3))/self.m, -(q5*sin(q3)*(cot(q7)^2 + 1))/self.J;
         0,                 1/self.m,                               0;
      ];

      u = B\( -A - gammaDot(self) + v ) ;
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

  end
end
