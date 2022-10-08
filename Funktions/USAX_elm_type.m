classdef USAX_elm_type
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        obj_set 
        sax_id 
        obj_count
        
    end
    
    methods
        function obj = USAX_elm_type

            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            import  tsc_algorithms.PairT;
            obj.obj_set = java.util.HashSet;
            obj.sax_id  = java.util.ArrayList;
            obj.obj_count =containers.Map('KeyType','int32','ValueType','int32');
        end
%         
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
     end
end

