syms l M g s c J lamb

A = [
    0 1 0 -l*M*c/(J*s) ;
    l*M*g*c/(s*J) 0  0 0 ;
    0 0 0 1;
    -g 0 0 0
    ];

B = [ 0;
      0;
      0;
      2*s/M
      ];
C = [ 0 0 1 0];

T = C * inv( lamb * eye(4) - A ) * B;

      
A1 = [
    0 1 0 0;
    0 0 1 0;
    0 0 0 1;
    0 0 0 0
    ];

B1 = [ 0 0 0 1]';
C1 = [ -2*l*g*c/J 0 2*s/M 0 ];

T1 = C1 * inv( lamb * eye(4) - A1 ) * B1;

