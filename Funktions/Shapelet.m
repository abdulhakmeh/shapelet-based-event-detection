classdef Shapelet
    %SHAPELET Summary of this class goes here
    %   Detailed explanation goes here

    properties
        gain 
        gap  
        dist_th = +inf; 
        obj 
        pos
        len
        num_diff
        c_in =[] ;
        c_out=[];
        ts = [];
    
    end
     
    methods
        function objc = Shapelet ( gain, gap , dist_th ,obj ,pos, len , num_diff ,in ,out )
            %SHAPELET Construct an instance of this class
            if exist('gain','var'); objc.gain = gain; else, objc.gain = -inf; end 
            if exist('gap','var'); objc.gap = gap; else, objc.gap = -inf; end
            if exist('dist_th','var'); objc.dist_th = dist_th; else, objc.dist_th = + inf; end 
            if exist('pos','var'); objc.pos = pos; else, objc.pos = -1; end 
            if exist('obj','var'); objc.obj = obj; else, objc.obj = -1; end 
            if exist('len','var'); objc.len = len; else, objc.len = -1; end 
            if exist('num_diff','var'); objc.num_diff = num_diff; else, objc.num_diff = -1; end 
            if exist('in','var'); objc.c_in = in ; else, objc.c_in = []; end 
            if exist('out','var'); objc.c_out = out; else, objc.c_out = []; end 
            

            
        end
        
        function object = setTS(object,ts)
            object.ts = ts;
        end
        function buildClassifier ( data)
            train(data,10,10)
        end

    end
end

