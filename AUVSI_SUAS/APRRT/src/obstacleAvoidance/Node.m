classdef Node < handle
  properties
    parent
    children
    root
    value
  end
                                % list and tree foundamental functions
  methods( Static = true)
    function result = concatLists(firstSet,secondSet)
      if size(firstSet,2) ==0
        result= secondSet;
      elseif size(firstSet,2) == 1
        result= Node.addInHead( firstSet{size(firstSet,2)}, secondSet);
      else
        firstPartOfFirstSet = {firstSet{1:size(firstSet,2)-1}};
        lastOfFirstSet = firstSet{size(firstSet,2)};
        partialRes = Node.addInHead( lastOfFirstSet, secondSet);
        result= Node.concatLists( firstPartOfFirstSet, partialRes);
      end
    end
    function result= addInHead(elem, list)
      if size(list,2)== 0
        result= {elem};
      else
        elemToReplaceWith = elem;
        for i = 1:size(list,2)
          elemBeingReplaced = list{i};
          list{i} = elemToReplaceWith;
          elemToReplaceWith = elemBeingReplaced;
        end
        list{ size(list,2)+1} = elemToReplaceWith;
        result= list;
      end
    end
    function result= addInTail( elem, list)
      result= Node.concatLists( list, {elem});
    end

    function result = recRemoveNodeFromList( elem, list)
      if isempty(list)
        result = {};
      else
        if equals( list{1}, elem)
          if size(list,2) == 1
            result = Node.recRemoveNodeFromList( elem , {} );
          else
            result = Node.recRemoveNodeFromList( elem , {list{2:size(list,2)}} );
          end
        else
          if size(list,2) == 1
            result = Node.addInHead( list{1} , Node.recRemoveNodeFromList(elem , {} ) );
          else
            result = Node.addInHead( list{1} ,Node.recRemoveNodeFromList( elem , {list{2:size(list,2)}} ));
          end
        end
      end
    end

    function res = recNodeBelongs(elem, list)
      if isempty(list)
        res = false;
      else
        if equals( list{1}, elem)
          res = true;
        else
          if size(list,2) == 1
            res = Node.recNodeBelongs(elem, {});
          else
            res = Node.recNodeBelongs(elem, {list{2:size(list,2)}});
          end
        end
      end
    end




    function res = checkEquality( x, y )
      res = true;
      if isenum(x) && isenum(y)
        if x ~= y
          res = false;
        end
      elseif isstring(x) && isstring(y)
        if x ~= y
          res = false;
        end
      elseif isvector(x) && isvector(y)
        if ~isequal( x , y)
          res = false;
        end
      else
        res = false;
      end
    end
  end

  methods
    function self = Node(value)
      self.value = value;
      self.children = {};
      self.parent =  {};
      self.root = true;
    end
    function bool = isRoot(self)
      bool = self.root;
    end
    function addParent(self, parent)
      self.root = false;
      self.parent = {parent};
    end
    function addChild(self, child)
      addParent(child, self);
      self.children = Node.addInTail(child, self.children);
    end
    function removeAsChild(self)
      newChildren = Node.recRemoveNodeFromList(self,self.parent{:}.children);
      self.parent{:}.children = newChildren;
    end
    function path = getPathFromRoot(self)
      path = recPathFromRoot( self, {});
    end
    function result= recPathFromRoot( self, partial )
      list = Node.addInHead( self, partial );
      if  isRoot( self)
        result= list;
      else
        result= recPathFromRoot( self.parent{:}, list);
      end
    end
    function res = recFindLeaves(self)
      if size(self.children,2) == 0
        res = {self};
      else
        partialList = {};
        for i=1:size(self.children,2)
          partialList = Node.concatLists(partialList, recFindLeaves(self.children{i}));
        end
        res = partialList;
      end
    end


    function res = recFindNodes(self)
      if size(self.children,2) == 0
        res = {self};
      else
        partialList = {self};
        for i=1:size(self.children,2)
          partialList = Node.concatLists(partialList, recFindNodes(self.children{i}));
        end
        res = partialList;
      end
    end


   function print(self)
      if isstruct(self.value)
        list = fieldnames(self.value);
        for i= 1:size(list,1)
          x = getfield(self.value, list{i});
          disp(list{i});
          if isenum(x) || isstring(x)
            disp(x);
          else
            for j=1:size(x,1)
              disp( x(j,1));
            end
          end
        end
      else
        if isenum(self.value) || isstring(self.value)
          disp(self.value);
        end
      end
    end
   %{
    function res = equals(self, obj)
      res = true;
      if isstruct(self.value) && isstruct(obj.value)
        listSelf = fieldnames(self.value);
        listObj = fieldnames(obj.value);
        if size(listSelf,1) ~= size(listObj,1)
          res = false;
        else
          for i= 1:size(listSelf,1)
            x = getfield(self.value, listSelf{i});
            y = getfield(obj.value, listObj{i});
            if ~Node.checkEquality( x, y)
              res = false;
            end
          end
        end
      else
        x = self.value;
        y = obj.value;
        if ~Node.checkEquality( x, y)
          res = false;
        end
      end
    end
   %}

    function res = equals(self, obj)
      res = true;
      if isstruct(self.value) && isstruct(obj.value)
        listSelf = fieldnames(self.value);
        listObj = fieldnames(obj.value);
        if size(listSelf,1) ~= size(listObj,1)
          res = false;
        else
          if ~Node.checkEquality( self.value.conf,obj.value.conf )
            res = false;
          end
        end
      else
        x = self.value;
        y = obj.value;
        if ~Node.checkEquality( x, y)
          res = false;
        end
      end
    end

  end
end

