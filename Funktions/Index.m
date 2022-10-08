classdef Index < Comparable
    %INDEX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        value
        index
    end
    
    methods
        function obj = Index(m)
            if nargin ~= 0
               obj(m) = obj;
            end

        end
        
        function val = compareTo(t)
            val = abs(floor(t.value)- abs(floor(t.value))); 
        end
        function val = sort(obj)
             for i=1:length(obj)
                 for k=1:length(obj)
                     if k == length(obj)
                         break;
                     end
                     if obj(k).value >  obj(k+1).value
                         temp = obj(k+1);
                         obj(k+1) = obj(k);
                          obj(k) = temp;
                     end
                 end
             end
             val =obj;
        end
    end
end

