classdef MSERDetector < Detector
    %MSERDETECTOR Detect features using the maximally stable extremal
    %regions (MSER) detector
    
    properties
        thresholdDelta;
        regionAreaRange;
        maxAreaVariation;
    end
    
    methods
        function obj = MSERDetector(thresholdDelta, regionAreaRange, ...
                maxAreaVariation)
            obj = obj@Detector(0);
            
            if nargin > 0
                obj.thresholdDelta = thresholdDelta;
            else
                obj.thresholdDelta = 2;
            end
            
            if nargin > 1
                obj.regionAreaRange = regionAreaRange;
            else
                obj.regionAreaRange = [30 14000];
            end
            
            if nargin > 2
                obj.maxAreaVariation = maxAreaVariation;
            else
                obj.maxAreaVariation = 0.25;
            end
        end
        
        function points = detectFeatures(obj, img)
            if ~ismatrix(img)
                img = rgb2gray(img);
            end
            
            points = detectMSERFeatures(img, ...
                'ThresholdDelta', obj.thresholdDelta, ...
                'RegionAreaRange', obj.regionAreaRange, ...
                'MaxAreaVariation', obj.maxAreaVariation);
        end
    end
    
end

