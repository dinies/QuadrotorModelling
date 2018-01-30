classdef Agent < Entity
  methods
    function self= Agent(x,y,r,color)
      self@Entity(x,y,r,color )
    end
  
    function doAction(self , planner , clock)

      f = computeArtificialForce(planner);

      self.coords.x = self.coords.x + f(1,1)* clock.delta_t;
      self.coords.y = self.coords.y + f(2,1)* clock.delta_t;
    end

    function dynamicDraw(self,planner)
      drawer = Drawer();
      d1= drawCircle2D(drawer , self.coords.x, self.coords.y, self.radius, self.color);
      wallPotentialColor= self.color * 0.4;
      d2 = drawCircle2D(drawer , planner.coordsWallPotentials(1,1), planner.coordsWallPotentials(1,2), planner.wallInfluenceRange, wallPotentialColor);
      d3 = drawCircle2D(drawer , planner.coordsWallPotentials(2,1), planner.coordsWallPotentials(2,2), planner.wallInfluenceRange, wallPotentialColor);
      d4 = drawCircle2D(drawer , planner.coordsWallPotentials(3,1), planner.coordsWallPotentials(3,2), planner.wallInfluenceRange, wallPotentialColor);
      d5 = drawCircle2D(drawer , planner.coordsWallPotentials(4,1), planner.coordsWallPotentials(4,2), planner.wallInfluenceRange, wallPotentialColor);
      self.drawing = [ d1 ; d2; d3; d4 ;d5 ];
    end

    function dynamicDeleteDrawing(self)
      for i = 1:size(self.drawing,1)
      delete(self.drawing(i,1));
      end
    end

  end
end
