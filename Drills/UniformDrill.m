classdef UniformDrill < Drill
    
    properties (Constant)
        name = "UniformDrill";
        description = "Transmits uniform energy|across the entire frequency band.";
    end

    methods
        function self = UniformDrill(numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.setUniformEnergies();
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            self.feedbackEnergies = feedbackEnergies;
            % Do Nothing
        end
    end
end
