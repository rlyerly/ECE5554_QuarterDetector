classdef SURFDetector < Detector
    %SURFDETECTOR Detect features using the speeded-up robust features
    %(SURF) detector
    
    properties
        metricThreshold;
        numOctaves;
        numScaleLevels;
    end
    
    methods
        function obj = SURFDetector(metricThreshold, numOctaves, ...
                numScaleLevels)
            obj = obj@Detector(0);
            
            if nargin > 0
                obj.metricThreshold = metricThreshold;
            else
                obj.metricThreshold = 1000.0;
            end
            
            if nargin > 1
                obj.numOctaves = numOctaves;
            else
                obj.numOctaves = 3;
            end
            
            if nargin > 2
                obj.numScaleLevels = numScaleLevels;
            else
                obj.numScaleLevels = 4;
            end
        end
        
        function points = detectFeatures(obj, img)
            if ~ismatrix(img)
                img = rgb2gray(img);
            end
            
            points = detectSURFFeatures(img, ...
                'MetricThreshold', obj.metricThreshold, ...
                'NumOctaves', obj.numOctaves, ...
                'NumScaleLevels', obj.numScaleLevels);
        end
    end
    
end

