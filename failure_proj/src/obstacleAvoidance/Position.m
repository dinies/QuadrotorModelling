classdef Position < Entity
  methods
    function self= Position(x,y,z,r,color)
      self@Entity(x,y,z,r,color )
    end
  end
end
