classdef Graph < handle
  properties
    edges
    vertices
  methods
    function self = Graph( vertices, edges )

      self.vertices = vertices;
      self.edges = edges;
    end

    function mat = adjacencyMatrix(self)
      N = size( self.vertices,1);
      mat = zeros( N,N );
      ew

    end

    function draw(self)
      for v = self.vertices
        draw(v);
      end
      for e = self.edges
        draw(e);
      end
    end

    function delete(self)
      for v = self.vertices
        delete(v);
      end
      for e = self.edges
        delete(e);
      end
  end
end
