classdef FASTDetector < GPUDetector
    %FASTDETECTOR Detect features using the features from accelerated
    %segment test (FAST) detector
    
    properties
        minContrast;
    end
    
    methods
        function obj = FASTDetector(minQuality, useGPU, minContrast)
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
                obj.minContrast = minContrast;
            else
                obj.minContrast = 0.2;
            end
        end
        
        function points = detectFeatures(obj, img)
            if ~ismatrix(img)
                img = rgb2gray(img);
            end
            
            if obj.useGPU
                gpuImg = gpuArray(img);
                pointsGPU = detectFASTFeatures(gpuImg, ...
                    'MinQuality', obj.minQuality, ...
                    'MinContrast', obj.minContrast);
                points = gather(pointsGPU);
            else
                points = detectFASTFeatures(img, ...
                    'MinQuality', obj.minQuality, ...
                    'MinContrast', obj.minContrast);
            end
        end
    end
    
end

