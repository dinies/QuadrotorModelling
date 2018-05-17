close all
clear
clc

delta_t = 0.1;
clock = Clock(delta_t);

state1.coords= [0;0;0];
state1.x = 1;
v1 = Agent(1,state1,clock);

state2.coords= [1;0;0];
state2.x = 0;
v2 = Agent(2,state2,clock);

state3.coords= [1;1;0];
state3.x = 1;
v3 = Agent(3,state3,clock);

state4.coords= [2;0;0];
state4.x = 2;
v4 = Agent(4,state4,clock);

state5.coords= [2;1;0];
state5.x = 0;
v5 = Agent(5,state5,clock);

vertices = [v1;v2;v3;v4;v5];

e1 = Edge( vertices(1,1),vertices(2,1),false);
e2 = Edge( vertices(2,1),vertices(3,1),false);
e3 = Edge( vertices(2,1),vertices(5,1),false);
e4 = Edge( vertices(3,1),vertices(4,1),false);
e5 = Edge( vertices(3,1),vertices(5,1),false);
e6 = Edge( vertices(4,1),vertices(5,1),false);
edges = [e1, e2, e3, e4, e5, e6];

graph = Graph( vertices, edges, clock);

totTime = 10;
graph.consensusProtocol(totTime);
