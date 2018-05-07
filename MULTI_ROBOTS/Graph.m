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

    function mat = degreeMatrix(self)
                % DEGREEMATRIX Compute the degree of all vertices of a graph,...
                % if the graph is directed it woll compute the inDegree..
      N = size( self.vertices,1);
      mat = zeros( N,N );
      for i = 1:size(self.edges,1)
        edge = self.edges(i,1);
        mat( edge.vertexTo.id, edge.vertexTo.id) = mat( edge.vertexTo.id, edge.vertexTo.id) +1;
        if ~edge.directed
          mat( edge.vertexFrom.id, edge.vertexFrom.id) = mat( edge.vertexFrom.id, edge.vertexFrom.id) +1;
        end
      end
    end
    function mat = incidenceMatrix(self)
  % INCEDENCEMATRIX Compute the incidence reletion betwwen vertices of a graph.Only directed graphs
      N = size( self.vertices,1);
      epsilon = size(self.edges,1);
      mat = zeros( N,epsilon );
      for i = 1:size(self.edges,1)
        edge = self.edges(i,1);
        mat(edge.vertexFrom.id ,i) = mat(edge.vertexFrom.id, i) -1;  %tail
        mat(edge.vertexTo.id ,i) = mat(edge.vertexTo.id, i) +1;  %head
      end
    end
    function mat = laplacianMatrixDirected(self)
% LAPLACIANMATRIX Compute the laplacian reletion betwwen vertices of a directed graph.
      mat = self.incidenceMatrix * self.incidenceMatrix' ;
    end

    function mat = laplacianMatrixUndirected(self)
% LAPLACIANMATRIX Compute the laplacian reletion betwwen vertices of a undirected graph.
      mat =  self.degreeMatrix() - self.adjacencyMatrix();
    end

    function res = isConnected(self)

      if self.edges(size(self.edges,1)).directed  %check if the graph is directed
        singularValues= svd( self.laplacianMatrixDirected);
      else
        singularValues= svd( self.laplacianMatrixUndirected);
      end
      res = singularValues( size(self.edges,1)-1 ) > 0;
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
