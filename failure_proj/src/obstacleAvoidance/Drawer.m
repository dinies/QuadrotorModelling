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
  end
end
