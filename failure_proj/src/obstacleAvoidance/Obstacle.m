classdef Obstacle < Entity
  properties
    influenceRange
    Kr
  end
  methods
    function self= Obstacle(x, y, r, color )
      self@Entity( x, y, r, color );
      self.influenceRange= r;
      self.Kr= 0.02;
    end

    function draw(self)
      drawer = Drawer();
      d1= drawCircle2D(drawer , self.coords.x, self.coords.y, self.radius, self.color);
      colorInfluenceRange= self.color * 0.5;
      d2= drawCircle2D(drawer , self.coords.x, self.coords.y, self.radius + self.influenceRange, colorInfluenceRange);

      self.drawing = [ d1 ; d2];
    end
  end
end
