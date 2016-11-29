classdef (Abstract) Detector
    %DETECTOR Abstract class to detect features in images
    
    properties
        minQuality;
    end
    
    methods
        function obj = Detector(minQuality)
            assert(isfloat(minQuality), 'invalid constructor argument');
            obj.minQuality = minQuality;
        end
    end
    
    methods (Abstract)
        points = detectFeatures(obj, img);
    end
    
end

