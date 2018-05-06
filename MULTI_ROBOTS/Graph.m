classdef Graph < handle
  properties
    edges
    vertices
  end
  methods

    function self = Graph( vertices, edges )
      if size(vertices,2) == 1
        self.vertices = vertices;
      else
        self.vertices = vertices';
      end
      if size(edges,2) == 1
        self.edges = edges;
      else
        self.edges = edges';
      end
    end

    function mat = adjacencyMatrix(self)
  % ADJANCENCYMATRIX Compute the adjacency reletion betwwen vertices of a graph.
      N = size( self.vertices,1);
      mat = zeros( N,N );
      for i = 1:size(self.edges,1)
        mat(self.edges(i,1).vertexTo.id,self.edges(i,1).vertexFrom.id) = ...
        mat(self.edges(i,1).vertexTo.id,self.edges(i,1).vertexFrom.id) +1;
        if ~self.edges(i,1).directed
          mat(self.edges(i,1).vertexFrom.id,self.edges(i,1).vertexTo.id) = ...
          mat(self.edges(i,1).vertexFrom.id,self.edges(i,1).vertexTo.id) +1;
        end
      end
    end

    function draw(self)
      figure('Name','Graph representation','pos',[10 10 1600 1200]),hold on;
      axis([-1 3 -1 3 -1 3]);
      az=0;
      el=70;
      view(az,el);
      title('graph'),xlabel('x'),ylabel('y'),zlabel('z');
      for i = 1:size(self.vertices,1)
        draw(self.vertices(i,1));
      end
      for i = 1:size(self.edges,1)
        draw(self.edges(i,1));
      end
    end
    function delete(self)
      for i = 1:size(self.vertices,1)
        delete(self.vertices(i,1));
      end
      for i = 1:size(self.edges,1)
        delete(self.edges(i,1));
      end
    end
  end
end
