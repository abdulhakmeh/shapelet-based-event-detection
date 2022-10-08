classdef FastShapelet 
    %FASTSHAPELETS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
   
    end
    
    methods
        function obj = FastShapelets(inputArg1,inputArg2)
            %FASTSHAPELETS Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function buildClassifier(data)
          train(data,10,10);
        end
    end
end

