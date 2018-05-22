
figure
a1 = animatedline('Color',[0 .7 .7]);
a2 = animatedline('Color',[0 .5 .5]);

axis([0 20 -1 1])
x = linspace(0,20,10000);
for k = 1:length(x)
                                % first line
  xk = x(k);
  ysin = sin(xk);
  addpoints(a1,xk,ysin);

                                % second line
  ycos = cos(xk);
  addpoints(a2,xk,ycos);

                                % update screen
  drawnow limitrate
end
