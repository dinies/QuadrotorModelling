close all
clear
clc

delta_t = 0.1;
clock = Clock(delta_t);

state1.coords= [0;0;0];
state1.x = 4;
v1 = SingleAgent(1,state1,clock);

state2.coords= [1;0;0];
state2.x = 0;
v2 = SingleAgent(2,state2,clock);

state3.coords= [1;1;0];
state3.x = 1;
v3 = SingleAgent(3,state3,clock);

state4.coords= [2;0;0];
state4.x = 2;
v4 = SingleAgent(4,state4,clock);

state5.coords= [2;1;0];
state5.x = 0;
v5 = SingleAgent(5,state5,clock);

vertices = [v1;v2;v3;v4;v5];

%% directed case

%e1 = Edge( vertices(1,1),vertices(2,1),false);
%e2 = Edge( vertices(2,1),vertices(3,1),false);
%e3 = Edge( vertices(2,1),vertices(5,1),false);
%e4 = Edge( vertices(3,1),vertices(4,1),false);
%e5 = Edge( vertices(3,1),vertices(5,1),false);
%e6 = Edge( vertices(4,1),vertices(5,1),false);



%% undirected case

e1 = Edge( vertices(1,1),vertices(2,1),true);
e2 = Edge( vertices(2,1),vertices(5,1),true);
% e3 = Edge( vertices(3,1),vertices(1,1),true);
e4 = Edge( vertices(3,1),vertices(4,1),true);
e5 = Edge( vertices(4,1),vertices(3,1),true);
e6 = Edge( vertices(4,1),vertices(5,1),true);
e7 = Edge( vertices(5,1),vertices(3,1),true);
e8 = Edge( vertices(5,1),vertices(4,1),true);



edges = [e1, e2, e4, e5, e6,e7,e8];

graph = Graph( vertices, edges, clock);

totTime = 10;
L = graph.laplacianMatrix()% error in the way the laplacian matrix is computed in the directed graph
%graph.consensusProtocol(totTime);
