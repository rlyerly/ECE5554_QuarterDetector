classdef GPUDetector < Detector
    %GPUDETECTOR Detect features using a GPU
    
    properties
        useGPU;
    end
    
    methods
        function obj = GPUDetector(minQuality, useGPU)
            assert(islogical(useGPU), 'invalid constructor argument');
            obj = obj@Detector(minQuality);
            obj.useGPU = useGPU;
        end
    end
    
end

