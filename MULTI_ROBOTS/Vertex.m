classdef Vertex < handle
  properties
    id
    state %it contains the spatial coordinates of the vertex, namely a vector in the field coords of length 3
    drawing
  end


  methods
    function self = Vertex(id, state)
      self.id = id;
      self.state = state;
    end


    function draw(self)
      violet = [0.45, 0.02,0.88];
      self.drawing= scatter3(self.state.coords(1,1),self.state.coords(2,1),self.state.coords(3,1), 18, violet);
    end

    function delete(self)
      delete(self.drawing);
    end

    function res = equals(self, obj)
      res = true;
      if self.id ~= obj.id
        res = false;
      end
      listSelf = fieldnames(self.state);
      listObj = fieldnames(obj.state);
      if size(listSelf,1) ~= size(listObj,1)
        res = false;
      else
        if ~isequal( self.state.coords,obj.state.coords)
          res = false;
        end
      end
    end
  end
end
