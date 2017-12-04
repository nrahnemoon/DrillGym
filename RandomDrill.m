classdef RandomDrill < Drill
    
    methods
        function self = RandomDrill(numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.name = "RandomDrill";
            self.setRandomEnergies();
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            self.setRandomEnergies()
        end
    end
end

