classdef QuarterDatabase
    %QUARTERDATABASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        QuarterMap;
    end
    
    methods
        % Construct an empty quarter database
        function obj = QuarterDatabase()
            obj.QuarterMap = containers.Map;
        end
        
        % Return the number of quarters currently in the database
        function num = numQuarters(obj)
            num = obj.QuarterMap.size();
        end
        
        % Get the keys to the quarter map
        function keySet = getKeys(obj)
            keySet = keys(obj.QuarterMap);
        end
        
        % Add a quarter to the database
        function obj = addQuarter(obj, state, quarter)
            assert(ischar(state), 'Invalid state');
            assert(isa(quarter, 'Quarter'), 'Invalid quarter');
            obj.QuarterMap(state) = quarter;
        end
        
        % Return the quarter information for a given state
        function quarter = getQuarter(obj, state)
            assert(ischar(state), 'Invalid state');
            quarter = obj.QuarterMap(state);
        end
    end
    
end

