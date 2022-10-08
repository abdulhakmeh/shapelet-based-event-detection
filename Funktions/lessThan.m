function  boolean = lessThan (object,other)

    if object.gain > other.gain
        boolean = 0 ;
    else
       boolean =  (object.gain < other.gain || object.gain == other.gain && ...
        object.num_diff > other.num_diff ||( object.gain== other.gain && ...
        object.num_diff == other.num_diff && object.gap < other.gap)) ; 
    end
        
end

