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

    function print(self)
      if isstruct(self.value)
        list = fieldnames(self.value);
        for i= 1:size(list,1)
          x = getField(self.value, list{i});
          if isnum(x) || isstring(x)
            disp(x);
          else
            for j=1:size(x,1)
              disp( x(j,1));
            end
          end
        end
      else
        if isnum(self.value) || isstring(self.value)
        disp(self.value);
        end
      end
    end
  end
end

