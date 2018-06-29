classdef Edge < handle
  properties
    directed
    vertexFrom
    vertexTo
    drawing
  end

  methods
    function self = Edge( vertexFrom, vertexTo, directed)
      if nargin > 2
        self.directed = directed;
      else
        self.directed = false;
      end
      self.vertexFrom = vertexFrom;
      self.vertexTo = vertexTo;

    end

    function draw(self)

      orange =[0.88,0.45,0.02];
      p1= self.vertexFrom.state.coords;
      p2= self.vertexTo.state.coords;
      self.drawing = line([p1(1,1),p2(1,1)],[p1(2,1),p2(2,1)],[p1(3,1),p2(3,1)],'Color',orange,'LineWidth',1);
    end

    function delete(self)
      delete(self.drawing);
    end

    function res = equals(self, obj)
      if self.directed && obj.directed
        res = self.vertexFrom.equal(obj.vertexFrom) && self.vertexTo.equals(obj.vertexTo);
      elseif ~self.directed && ~obj.directed
        res = self.vertexFrom.equal(obj.vertexFrom) && self.vertexTo.equals(obj.vertexTo) || ...
         self.vertexFrom.equal(obj.vertexTo) && self.vertexTo.equals(obj.vertexFrom);
      else
        res = false;
      end
    end
  end
end
