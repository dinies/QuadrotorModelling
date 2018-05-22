classdef BoxOp < handle
  % BOXOP implements some static function to work with values that are defined on closed and continuos manifolds, commonly angular quantities.
  % the implementation is taken from a colleague github@Giulero
  properties
  end

  methods( Static = true)
    function psi = boxPlus(alfa,beta)
% BOXPLUS computes the sum of two angles in radiants keeping the result in a fixed manifold
      Ralfa = BoxOp.rot2Mat(alfa);
      Rbeta = BoxOp.rot2Mat(beta);
      R= Rbeta*Ralfa;
      psi = atan2(R(2,1), R(1,1));
    end
    function psi = boxMinus(alfa,beta)
% BOXMINUS computes the diff of two angles in radiants keeping the result in a fixed manifold
      Ralfa = BoxOp.rot2Mat(alfa);
      Rbeta = BoxOp.rot2Mat(beta);
      R= Rbeta'*Ralfa;
      psi = atan2(R(2,1), R(1,1));
    end
    function psi = boxWrap(alfa)
% BOXWRAP keeps the value of the angle in input (radians), in a fixed manifold
      psi = atan2(sin(alfa),cos(alfa));
    end

    function R = rot2Mat(alfa)
      R = [cos(alfa) -sin(alfa);
            sin(alfa) cos(alfa)];
    end
  end
end
