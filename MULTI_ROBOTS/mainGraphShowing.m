close all
clear
clc


state1.coords= [0;0;0];
v1 = Vertex(1,state1);

state2.coords= [1;0;0];
v2 = Vertex(2,state2);

state3.coords= [1;1;0];
v3 = Vertex(3,state3);

state4.coords= [2;0;0];
v4 = Vertex(4,state4);

state5.coords= [2;1;0];
v5 = Vertex(5,state5);

vertices = [v1;v2;v3;v4;v5];

e1 = Edge( vertices(1,1),vertices(2,1),false);
e2 = Edge( vertices(2,1),vertices(3,1),false);
e3 = Edge( vertices(2,1),vertices(5,1),false);
e4 = Edge( vertices(3,1),vertices(4,1),false);
e5 = Edge( vertices(3,1),vertices(5,1),false);
e6 = Edge( vertices(4,1),vertices(5,1),false);
edges = [e1, e2, e3, e4, e5, e6];

graph = Graph( vertices, edges);

graph.draw();
