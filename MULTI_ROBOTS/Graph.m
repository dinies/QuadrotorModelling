classdef Graph < handle
  properties
    edges
    vertices
    clock
  end
  methods

    function self = Graph( vertices, edges, clock )
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

      if nargin > 2
        self.clock = clock;
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
    function mat = laplacianMatrix(self)
% LAPLACIANMATRIX Compute the laplacian reletion between vertices.
      if self.isDirected()
        mat = self.incidenceMatrix * self.incidenceMatrix' ;
      else
        mat =  self.degreeMatrix() - self.adjacencyMatrix();
      end
    end

    function res = isConnected(self)
      singularValues= svd( self.laplacianMatrix);
      res = singularValues( size(self.edges,1)-1 ) > 0;
    end

    function bool = isDirected(self)
           %ISDIRECTED it says if the graph is undirected ( there is at least an
           % edge that is bidirectional) or directed ( otherwise )

      bool= false;
      for i = 1:size(self.edges,1)
        if self.edges(i).directed
          bool = true;
        end
      end
    end

    function x_curr = getCurrentAgentState(self)
  % GETCURRENTAGENTSTATE returns all the states x of all the agents in the graph
      x_curr = zeros( size(self.vertices) );
      for i = 1:size(self.vertices)
        x_curr(i,1) = self.vertices(i,1).getState();
      end
    end

    function err =  error( self, x_target)
         % ERROR will ruturn a a difference between the target and current state
      x_curr = self.getCurrentAgentState();
      err = x_target - x_curr;
    end

    function updateStateVertices(self,x_dot)
      for i = 1:size(self.vertices,1)
        self.vertices(i,1).updateState( x_dot(i,1));
      end
    end

    function consensusProtocol(self,t_f)
% CONSENSUSPROTOCOL is a function that will operate an iterative control strategy
% to bring all the agent present on the graph to a common state ( a consensus value
% which will be equal to the average of the initial values for a connected undirected
% graph, this will be more difficult in the case of a not completely connencted
% directed graph)

      numOfSteps = round(t_f/self.clock.delta_t);
      data = zeros(numOfSteps, size(self.vertices,1)+1);
      self.draw();
      for i = 1:numOfSteps
        x_curr = self.getCurrentAgentState();
        t= self.clock.curr_t();
        data( i, :) = [t, x_curr'];
        L = self.laplacianMatrix();
        x_dot = - L*x_curr;
        self.clock.tick();
        self.updateStateVertices(x_dot);
        self.deleteDrawing();
        self.dynamicDraw();
        pause(0.000001);
      end
      self.drawStatisticsAgents(data);
    end

    function drawStatisticsAgents(self, data, lastIterationNum)
      figure('Name','State','pos',[10 10 950 600]),hold on;
      for i = 1:size(self.vertices,1)
        plot(data(:,1),data(:,1+i));
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

    function dynamicDraw(self)
      for i = 1:size(self.vertices,1)
        draw(self.vertices(i,1));
      end
      for i = 1:size(self.edges,1)
        draw(self.edges(i,1));
      end
    end
    function deleteDrawing(self)
      for i = 1:size(self.vertices,1)
        delete(self.vertices(i,1).drawing);
      end
      for i = 1:size(self.edges,1)
        delete(self.edges(i,1).drawing);
      end
    end
  end
end
