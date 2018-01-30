classdef Entity < handle

  properties
    radius
    coords
    color
    drawing
  end

  methods
    function self= Entity( x_coord, y_coord, radius, color)
      self.coords.x= x_coord;
      self.coords.y= y_coord;
      self.radius = radius;
      self.color= color;
    end

    function deleteDrawing(self)
      delete(self.drawing);
    end

    function draw(self)
      drawer = Drawer();
      self.drawing= drawCircle2D(drawer , self.coords.x, self.coords.y, self.radius, self.color);
    end
  end
end

