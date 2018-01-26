classdef Robot < handle

  properties
    radius
    coords
    color
  end

  methods
    function self= Robot( x_coord, y_coord, radius, color)
      self.coords.x= x_coord;
      self.coords.y= y_coord;
      self.radius = radius;
      self.color= color;
    end

    function draw(self)
      drawer = Drawer();
      drawCircle2D(drawer , self.coords.x, self.coords.y, self.radius, self.color);
    end
  end
end
