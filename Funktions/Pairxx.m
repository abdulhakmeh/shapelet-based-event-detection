classdef Pair
    %PAIR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        first
        second
    end
    
    methods
        function obj = Pair(A,B)
            %PAIR Construct an instance of this class
            %   Detailed explanation goes here
            obj.first =A ;
            obj.second= B;
        end

    end
end

