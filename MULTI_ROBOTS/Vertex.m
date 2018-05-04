classdef Vertex < handle
  properties
    id
    state
    drawing
  end


  methods
    function self = Vertex(id, state)
      self.id = id;
      self.state = state;
    end


    function draw(self)
      self.drawing= ...
    end

    function delete(self)
      delete(self.drawing);
    end
  end
end
