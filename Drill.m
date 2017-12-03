classdef Drill < handle

    properties (Constant)
        color = [0.30, 0.30, 0.30];
        name = "Drill";
    end
    
    properties
        energyPerCycle
        transmissionEnergies % Per Frequency
        numFrequencies
    end
    
    methods
        function self = Drill(numFrequencies, energyPerCycle)
            self.numFrequencies = numFrequencies;
            self.energyPerCycle = energyPerCycle;
            self.setRandomEnergies();
        end
        
        function setRandomEnergies(self)
            mu = double(rand() * self.numFrequencies);
            sigma = double(rand() * (self.numFrequencies/10));
            self.transmissionEnergies = pdf('Normal', 1:self.numFrequencies, mu, sigma);
            self.transmissionEnergies = self.transmissionEnergies ./ sum(self.transmissionEnergies);
            self.transmissionEnergies = self.energyPerCycle * self.transmissionEnergies;
        end
    end
end

