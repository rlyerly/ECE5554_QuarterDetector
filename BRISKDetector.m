classdef BRISKDetector < Detector
    %BRISKDETECTOR Detect features using the binary robust invariant
    %scalable keypoints (BRISK) detector
    
    properties
        minContrast;
        numOctaves;
    end
    
    methods
        function obj = BRISKDetector(minQuality, minContrast, numOctaves)
            if nargin > 0
                pMinQuality = minQuality;
            else
                pMinQuality = 0.01;
            end
            obj = obj@Detector(pMinQuality);
            
            if nargin > 1
                obj.minContrast = minContrast;
            else
                obj.minContrast = 0.2;
            end
            
            if nargin > 2
                obj.numOctaves = numOctaves;
            else
                obj.numOctaves = 4;
            end
        end
        
        function points = detectFeatures(obj, img)
            if ~ismatrix(img)
                img = rgb2gray(img);
            end
            
            points = detectBRISKFeatures(img, ...
                'MinQuality', obj.minQuality, ...
                'MinContrast', obj.minContrast, ...
                'NumOctaves', obj.numOctaves);
        end
    end
    
end

