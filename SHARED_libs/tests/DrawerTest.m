close all
clear
clc

d = Drawer();

red=[1,0,0];
green=[0,1,0];
blue=[0,0,1];
orange=[1,0.6,0];

figure('Name','Test drawing arrow','pos',[10 10 1200 1200]),hold on;
axis([ -10 10 -10 10]);
title('world'), xlabel('x'), ylabel('y')

p1 = [-4,-5,0];
p2 = [3,-3,0];
headWidth = 0.3;

drawings1 = d.drawArrow( p1,p2, headWidth,orange);



p3 = [1,1,0];
p4 = [3,3,0];

swipeAngle = + pi/2;

%drawings2 = d.drawArc( p3,p4, swipeAngle ,orange);

drawings2 = d.drawCurvedArrow( p3,p4, swipeAngle , headWidth,orange);




























