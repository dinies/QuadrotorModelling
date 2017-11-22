function [l1, l2, l3, l4]= drawCart( x , old_draw)

	if ( nargin == 2 )
		delete(old_draw(1));
		delete(old_draw(2));
		delete(old_draw(3));
		delete(old_draw(4));
	end

	v1= [x-0.7,0];
	v2= [x-0.7,0.4];
	v3= [x+0.7,0.4];
	v4= [x+0.7,0];

	l1=line( [v1(1), v2(1)],[ v1(2), v2(2)] , 'LineWidth', 2);
	l2=line( [v2(1), v3(1)],[ v2(2), v3(2)] , 'LineWidth', 2);
	l3=line( [v3(1), v4(1)],[ v3(2), v4(2)] , 'LineWidth', 2);
	l4=line( [v4(1), v1(1)],[ v4(2), v1(2)] , 'LineWidth', 2);
