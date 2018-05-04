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
  % ADJANCENCYMATRIX Compute the adjacency reletion betwwen vertices of a graph.
      N = size( self.vertices,1);
      mat = zeros( N,N );
      for e = self.edges
        mat(e.vertexTo.id,vertexFrom.id) = mat(e.vertexTo.id,vertexFrom.id) +1;
        if ~e.directed
          mat(e.vertexFrom.id,vertexTo.id) = mat(e.vertexFrom.id,vertexTo.id) +1;
        end
      end
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
