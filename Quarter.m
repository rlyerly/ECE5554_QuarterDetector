classdef Quarter
    %QUARTER Maintains images, extracted features and other metadata for a
    %quarter
    
    properties
        % String containing the state represented by the quarter
        state;
        
        % RGB image of the quarter
        img;
        
        % Features extracted from the image
        features;
        
        % Corresponding points for each of the features
        points;
    end
    
    methods
        function obj = Quarter(state, img, features, points)
            assert(ischar(state), 'Invalid state');
            assert(isinteger(img), 'Invalid image');
            obj.state = state;
            obj.img = img;
            obj.features = features;
            obj.points = points;
        end
    end
    
end

