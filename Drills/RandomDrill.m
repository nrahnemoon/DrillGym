classdef RandomDrill < Drill
    
    properties (Constant)
        name = "RandomDrill";
        description = "Transmits random normal|transmission energies each|iteration."
    end

    methods
        function self = RandomDrill(numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.setRandomEnergies();
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            self.feedbackEnergies = feedbackEnergies;
            self.setRandomEnergies()
        end
    end
end

