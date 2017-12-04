classdef UniformDrill < Drill
    
    methods
        function self = UniformDrill(numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.name = "UniformDrill";
            self.setUniformEnergies();
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            % Do Nothing
        end
    end
end
