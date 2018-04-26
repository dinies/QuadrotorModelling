classdef Obstacle < Entity
  properties
    influenceRange
    Kr
  end
  methods
    function self= Obstacle(x, y, z , r, color, Kr )
      self@Entity( x, y, z, r, color );
      self.influenceRange= 5*r;
      self.Kr = Kr;
    end

    function draw2D(self)
      drawer = Drawer();
      d1= drawCircle2D(drawer , self.coords.x, self.coords.y, self.radius, self.color);
      colorInfluenceRange= [1, 0.8, 0];

      d2= drawCircle2D(drawer , self.coords.x, self.coords.y, self.radius + self.influenceRange, colorInfluenceRange);

      self.drawing = [ d1 ; d2];
    end
    function draw3D(self)
      drawer = Drawer();
      d1 = drawCircle3D(drawer , self.coords.x, self.coords.y, self.coords.z, self.radius, self.color);
      colorInfluenceRange= [1, 0.8, 0];
      d2 = drawCircle3D(drawer , self.coords.x, self.coords.y, self.coords.z, self.radius + self.influenceRange, colorInfluenceRange);
      self.drawing = [ d1 ; d2];
    end
  end
end
