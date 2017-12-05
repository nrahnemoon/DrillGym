classdef AbsorptionFactors

    properties
        particleClasses
        particleAbsorptionFactors
    end
    
    methods
        function self = AbsorptionFactors(particleClasses, numFrequencies)
            self.particleClasses = particleClasses;
            self.particleAbsorptionFactors = zeros(size(self.particleClasses, 2), numFrequencies);
            for i = 1:size(self.particleClasses, 2)
                mu = double(rand() * numFrequencies);
                sigma = double(rand() * (numFrequencies/10));
                self.particleAbsorptionFactors(i, :) = pdf('Normal', 1:numFrequencies, mu, sigma);
                self.particleAbsorptionFactors(i, :) = self.particleAbsorptionFactors(i, :) ./ sum(self.particleAbsorptionFactors(i, :));
                self.particleAbsorptionFactors(i, :) = rand() .* (self.particleAbsorptionFactors(i, :) ./ max(self.particleAbsorptionFactors(i, :)));
                
            end
        end
        
        function absorptionFactors = get(self, className)
            classIndex = find(ismember(self.particleClasses, className));
            absorptionFactors = self.particleAbsorptionFactors(classIndex, :);
        end
    end
end

