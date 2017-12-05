classdef (Abstract) Drill < handle

    properties (Constant)
        color = [0.30, 0.30, 0.30];
    end
    
    properties
        energyPerCycle
        transmissionEnergies % Per Frequency
        numFrequencies
        feedbackEnergies
    end
    
    methods (Abstract)
        receiveFeedbackEnergies(self, feedbackEnergies);
    end

    methods
        function self = Drill(numFrequencies, energyPerCycle)
            self.numFrequencies = numFrequencies;
            self.energyPerCycle = energyPerCycle;
        end

        function setUniformEnergies(self)
            self.transmissionEnergies = ones(1, self.numFrequencies) .* (self.energyPerCycle/self.numFrequencies);
        end

        function setRandomEnergies(self)
            mu = double(rand() * self.numFrequencies);
            sigma = double(rand() * (self.numFrequencies/10));
            self.transmissionEnergies = pdf('Normal', 1:self.numFrequencies, mu, sigma);
            self.transmissionEnergies = self.transmissionEnergies ./ sum(self.transmissionEnergies);
            self.transmissionEnergies = self.energyPerCycle * self.transmissionEnergies;
        end
        
        function setNormalEnergies(self, mu, sigma)
            self.transmissionEnergies = pdf('Normal', 1:self.numFrequencies, mu, sigma);
            self.transmissionEnergies = self.transmissionEnergies ./ sum(self.transmissionEnergies);
            self.transmissionEnergies = self.energyPerCycle * self.transmissionEnergies;
        end
    end
end

