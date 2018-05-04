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
      self.drawing= ...
    end

    function delete(self)
      delete(self.drawing);
    end
  end
end
