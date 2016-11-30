classdef HarrisDetector < GPUDetector
    %HARRISDETECTOR Detect features using the Harris corner detector

    properties
        filterSize;
    end
    
    methods
        function obj = HarrisDetector(minQuality, useGPU, filterSize)
            if nargin > 0
                pMinQuality = minQuality;
            else
                pMinQuality = 0.01;
            end
            
            if nargin > 1
                pUseGPU = useGPU;
            else
                pUseGPU = false;
            end
            
            obj = obj@GPUDetector(pMinQuality, pUseGPU);
            
            if nargin > 2
                obj.filterSize = filterSize;
            else
                obj.filterSize = 11;
            end
        end
        
        function points = detectFeatures(obj, img)
            if ~ismatrix(img)
                img = rgb2gray(img);
            end
                
            if obj.useGPU
                gpuImg = gpuArray(img);
                pointsGPU = detectHarrisFeatures(gpuImg, ...
                    'MinQuality', obj.minQuality, ...
                    'FilterSize', obj.filterSize);
                points = gather(pointsGPU);
            else
                points = detectHarrisFeatures(img, ...
                    'MinQuality', obj.minQuality, ...
                    'FilterSize', obj.filterSize);
            end
        end
    end
    
end

