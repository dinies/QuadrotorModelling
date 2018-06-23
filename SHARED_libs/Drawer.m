classdef Drawer < handle
  properties
  end
  methods

    function self= Drawer()
    end

    function drawing = drawCircle2D(~, x, y, r,color)
      resolution = 360;
      delta = 2*pi/resolution;

      points = zeros(resolution,2);
      index =1;
      for i = 0.0:delta:2*pi
        p_x= r*cos(i);
        p_y= r*sin(i);
        points(index,:) = [p_x,p_y];
        index = index + 1;
      end
      points(:,1)= points(:,1) + x;
      points(:,2)= points(:,2) + y;
      drawing = plot(points(:,1),points(:,2),'Color',color,'LineWidth', 2);
    end

    function drawing = drawCircle3D(~, x, y, z, r,color)
      resolution = 360;
      delta = 2*pi/resolution;

      points = zeros(resolution,2);
      index =1;
      for i = 0.0:delta:2*pi
        p_x= r*cos(i);
        p_y= r*sin(i);
        points(index,:) = [p_x,p_y];
        index = index + 1;
      end
      points(:,1)= points(:,1) + x;
      points(:,2)= points(:,2) + y;
      points(:,3)= z;
      drawing = plot3(points(:,1),points(:,2),points(:,3),'Color',color,'LineWidth', 2);
    end

    function drawing = drawRectangle2D(self, points ,color)
      l1= drawLine2D(self, points(1,:), points(2,:), color);
      l2= drawLine2D(self, points(2,:), points(3,:), color);
      l3= drawLine2D(self, points(3,:), points(4,:), color);
      l4= drawLine2D(self, points(4,:), points(1,:), color);
      drawing = [ l1 ; l2 ; l3 ; l4];
    end
    function drawing= drawLine2D(~, first, second, color)
      drawing= line( [ first(1,1), second(1,1)],[ first(1,2), second(1,2)], 'Color', color , 'LineWidth',3);
    end

    function drawing= drawLine3D(~, first, second, color)
      drawing= line( [ first(1,1), second(1,1)],[ first(1,2), second(1,2)],[ first(1,3), second(1,3)], 'Color', color , 'LineWidth',2);
    end

    function drawing = drawSphere3D(~,xCoord,yCoord,zCoord,size,color)
      [X,Y,Z] = sphere();
      x = [0.5*X(:); 0.75*X(:); X(:)];
      y = [0.5*Y(:); 0.75*Y(:); Y(:)];
      z = [0.5*Z(:); 0.75*Z(:); Z(:)];
                                %TODO  add color and size to the representation
      drawing= scatter3(x + xCoord,y + yCoord,z+zCoord, size, color);
    end


    function drawing = drawArrow(self,start,edge,headWidth,color)
      headEdgeAngle = 30*pi/180;
      headShaft = headWidth/ ( 2* sin( headEdgeAngle/2));

      lengthArrow = sqrt((edge(1,1)-start(1,1))^2+(edge(1,2)-start(1,2))^2+(edge(1,3)-start(1,3))^2);
      scaleHead = 100*headShaft/lengthArrow;
      scaleTail = 100- scaleHead;
      baseHeadPoint = (start' + scaleTail*( edge'-start')/100)';
      l1 = self.drawLine3D( start,baseHeadPoint,color);
      theta = atan2( edge(1,2)-start(1,2),edge(1,1)-start(1,1));
      sideDisplacement = [cos( theta - pi/2)*headWidth/2; sin(theta - pi/2)*headWidth/2; 0 ];
      rightPoint =  (baseHeadPoint' + sideDisplacement)';
      leftPoint =  (baseHeadPoint' - sideDisplacement)';
      l2 = self.drawLine3D( leftPoint,rightPoint,color);
      l3 = self.drawLine3D( rightPoint,edge,color);
      l4 = self.drawLine3D( edge,leftPoint,color);
      drawing = [ l1 ; l2 ; l3 ; l4];
    end

    function drawing = drawArc(self,pivot, edgePoint, swipeAngleCounterClockWise, color)
      resolution = round(abs(swipeAngleCounterClockWise)* 360/pi);
      if resolution > 720
        resolution = 720;
      end

      delta_theta = swipeAngleCounterClockWise/resolution;

      points = zeros(3,resolution);
      theta_0 = atan2( edgePoint(1,2)-pivot(1,2),edgePoint(1,1)-pivot(1,1)) - pi/2;

      arcRadius= sqrt((edgePoint(1,1)-pivot(1,1))^2+(edgePoint(1,2)-pivot(1,2))^2+(edgePoint(1,3)-pivot(1,3))^2);
      point_0 = [ 0; arcRadius; 0 ];


      rotTheta_0 = [
                  cos(theta_0) ,  -sin(theta_0), 0;
                  sin(theta_0) , cos(theta_0),  0;
                  0     ,     0     ,     1      ;
      ];

      rotDeltaTheta = [
                  cos(delta_theta) ,  -sin(delta_theta), 0;
                  sin(delta_theta) , cos(delta_theta),  0;
                  0     ,     0     ,     1      ;
      ];

      points(:,1)= rotTheta_0 * point_0;
      theta_curr = theta_0 + delta_theta;
      for i = 2:resolution
        points(:,i) = rotDeltaTheta* points(:,i-1);
        theta_curr = theta_curr + delta_theta;
     end

      points = points + pivot';
      drawing = plot3(points(1,:)',points(2,:)',points(3,:)','Color',color,'LineWidth', 2);
    end

    function drawing = drawCurvedArrow(self,pivot,edgePoint,swipeAngleCounterClockWise,headWidth,color)
      l1 = self.drawArc(pivot,edgePoint,swipeAngleCounterClockWise,color);
      arcRadius= sqrt((edgePoint(1,1)-pivot(1,1))^2+(edgePoint(1,2)-pivot(1,2))^2+(edgePoint(1,3)-pivot(1,3))^2);
      point_0= [ 0; arcRadius; 0 ];

      theta_0 = atan2( edgePoint(1,2)-pivot(1,2),edgePoint(1,1)-pivot(1,1)) - pi/2;
      finalTheta = theta_0 + swipeAngleCounterClockWise;

      rotFinalTheta = [
                    cos(finalTheta) ,  -sin(finalTheta), 0;
                    sin(finalTheta) , cos(finalTheta),  0;
                    0     ,     0     ,     1      ;
      ];

      endingPointArc = (rotFinalTheta * point_0) + pivot';
      sideDisplacement = [cos(finalTheta-pi/2)*headWidth/2; sin(finalTheta-pi/2)*headWidth/2; 0 ];
      rightPoint =  (endingPointArc + sideDisplacement)';
      leftPoint =  (endingPointArc - sideDisplacement)';
      lengthArrowHead = headWidth*5/2;

      if swipeAngleCounterClockWise > 0
        endingPointHead = endingPointArc - [ lengthArrowHead*cos(finalTheta);lengthArrowHead*sin(finalTheta); 0];
      else
        endingPointHead = endingPointArc + [ lengthArrowHead*cos(finalTheta);lengthArrowHead*sin(finalTheta); 0];
      end
      l2 = self.drawLine3D( leftPoint,rightPoint,color);
      l3 = self.drawLine3D( rightPoint,endingPointHead',color);
      l4 = self.drawLine3D( endingPointHead',leftPoint,color);
      drawing = [ l1 ; l2 ; l3 ; l4];

    end
  end
end


















