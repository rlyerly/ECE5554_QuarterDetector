classdef MinEigenDetector < Detector
    %MINEIGENDETECTOR Detect features using the minimum eigenvalue detector
    
    properties
        filterSize;
    end
    
    methods
        function obj = MinEigenDetector(minQuality, filterSize)
            if nargin > 0
                pMinQuality = minQuality;
            else
                pMinQuality = 0.01;
            end
            
            obj = obj@Detector(pMinQuality);
            
            if nargin > 1
                obj.filterSize = filterSize;
            else
                obj.filterSize = 11;
            end
        end
        
        function points = detectFeatures(obj, img)
            if ~ismatrix(img)
                img = rgb2gray(img);
            end
            
            points = detectMinEigenFeatures(img, ...
                'MinQuality', obj.minQuality, ...
                'FilterSize', obj.filterSize);
        end
    end
    
end

