classdef Drawer < handle
  properties
  end
  methods

    function self= Drawer()
    end



    function drawing = drawCircle2D(~, x, y, r,color)
      resolution = 720;
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
    function drawing = drawRectangle2D(self, points ,color)
      l1= drawLine2d(self, points(1,:), points(2,:), color);
      l2= drawLine2d(self, points(2,:), points(3,:), color);
      l3= drawLine2d(self, points(3,:), points(4,:), color);
      l4= drawLine2d(self, points(4,:), points(1,:), color);
      drawing = [ l1 ; l2 ; l3 ; l4];
    end
    function drawing= drawLine2d(~, first, second, color)
      drawing= line( [ first(1,1), second(1,1)],[ first(1,2), second(1,2)], 'Color', color , 'LineWidth',4);
    end
  end
end
