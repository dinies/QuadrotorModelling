close all
clear
clc

recFlag = 0;  %flag to record a video of the animation

l_0=340;   %average distance frome centre of Earth
theta=pi/4;
v_avg= 40.6;   %Km/s
b=l_0*tan(theta);
c=b-v_avg;
psi=c*theta/b;
phi=theta-psi;
x=l_0/cos(phi);


r1=[
    x*cos(psi);
    x*sin(psi);
    0
    ];
r0=[
    l_0*cos(theta);
    l_0*sin(theta);
    0
    ];
v0=r1-r0;

figure('Name','Orbital Satellite','pos',[10 10 1600 1200]),hold on;
axis([-1500 1500 -1050 1200 -3000 500]);
grid on
az=0;
el=80;
view(az,el);
title('iss orbital'),xlabel('x'),ylabel('y'),zlabel('z');

%inizialization
if recFlag
  video = VideoWriter('orbitIss.avi');
  open(video);
end

mi=398600.4;
q0=[r0';v0'];
q=q0;
h0=cross(r0,v0);
e0=cross(v0,h0)/mi-(r0/norm(r0));
delta_t=0.5;
t=0;
numOfSteps=500;
data=zeros(numOfSteps+1,17);
data(1,:)=[t,r0',v0',h0',e0',norm(e0),0,0,0];
for i=2:numOfSteps+1
    dq=stateEvolution(q);
    for j=1:size(q,1)
        for k=1:size(q,2)
            new_t=t+delta_t;
            integral=ode45(@(t,y) dq(j,k),[t new_t],q(j,k));
            q(j,k)=deval(integral,new_t);
        end
    end
    if recFlag
      drawSatellite(q(1,:)',q(2,:)',recFlag, video);
    else
      drawSatellite(q(1,:)',q(2,:)',recFlag);
    end
    t=t+delta_t;
    h=cross(q(1,:)',q(2,:)');
    e=cross(q(2,:)',h)/mi-(q(1,:)'/norm(q(1,:)'));
    data(i,:)=[t,q(1,:),q(2,:),h',e',norm(e),dq(2,:)];
    pause(0.0001);
end

drawStatistics(data);
if recFlag
  close(video);
end

function dq = stateEvolution(q)
mi=398600.4;
dq=[
    q(2,:);
    -mi*q(1,:)/norm(q(1,:))^3;
    ];
end

function frame = drawSatellite(r,v, recordingFlag ,video)
    h=cross(r,v);   %angolar momentum
    red=[1,0,0];
    green=[0,1,0];
    blue=[0,0,1];
    orange=[1,0.6,0];
    p0=[0;0;0];
    p1=p0+r;
    p2=p1+v;
    p3=r+h;
    line([p0(1,1),p1(1,1)],[p0(2,1),p1(2,1)],[p0(3,1),p1(3,1)],'Color',green,'LineWidth',2);
    line([p1(1,1),p2(1,1)],[p1(2,1),p2(2,1)],[p1(3,1),p2(3,1)],'Color',blue,'LineWidth',3);
    line([p1(1,1),p3(1,1)],[p1(2,1),p3(2,1)],[p1(3,1),p3(3,1)],'Color',orange,'LineWidth',3);
    if recordingFlag
      frame = getframe(gcf);
      video.writeVideo(frame);
    end

end


function drawStatistics(data)
    green=[0,1,0];
    red=[1,0,0];
    blue=[0,0,1];
    orange=[1,0.6,0];
    figure('Name','Plots','pos',[10 10 1200 600])
    ax1=subplot(2,3,1);hold on
    plot(data(:,1),data(:,2),'Color',green);
    plot(data(:,1),data(:,3),'Color',blue);
    plot(data(:,1),data(:,4),'Color',orange);
    title(ax1,'r');
    ax2=subplot(2,3,2);hold on
    plot(data(:,1),data(:,5),'Color',green);
    plot(data(:,1),data(:,6),'Color',blue);
    plot(data(:,1),data(:,7),'Color',orange);
    title(ax2,'v');
    ax3=subplot(2,3,3);hold on
    plot(data(:,1),data(:,8),'Color',green);
    plot(data(:,1),data(:,9),'Color',blue);
    plot(data(:,1),data(:,10),'Color',orange);
    title(ax3,'h');
    ax4=subplot(2,3,4);hold on
    plot(data(:,1),data(:,11),'Color',green);
    plot(data(:,1),data(:,12),'Color',blue);
    plot(data(:,1),data(:,13),'Color',orange);
    plot(data(:,1),data(:,14),'Color',red);
    title(ax4,'e');
    ax5=subplot(2,3,5);hold on
    plot(data(:,1),data(:,15),'Color',green);
    plot(data(:,1),data(:,16),'Color',blue);
    plot(data(:,1),data(:,17),'Color',orange);
    title(ax5,'a')
end


