close all
clear
clc


testClass1 = GraphTestDirected();
testClass2 = GraphTestUndirected();
testClass3 = VertexTest();

res1 = run(testClass1);
res2 = run(testClass2);
res3 = run(testClass3);

