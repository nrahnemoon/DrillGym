classdef BanditDrill < Drill
    
    properties (Constant)
        name = "BanditDrill";
        description = "Minimizes loss for each frequency|bucket independently|(each bucket is a bandit).";
    end
    
    properties
    end

    methods
        function self = BanditDrill(numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.setUniformEnergies();
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            self.feedbackEnergies = feedbackEnergies;
            self.transmissionEnergies = self.transmissionEnergies - self.feedbackEnergies;
            self.transmissionEnergies(self.transmissionEnergies < 0) = 0;
            self.transmissionEnergies = self.transmissionEnergies .* (self.energyPerCycle/sum(self.transmissionEnergies));
        end
    end
end
