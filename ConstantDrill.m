classdef ConstantDrill < Drill
    
    methods
        function self = ConstantDrill(numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.name = "ConstantDrill";
            self.setRandomEnergies();
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            % Do Nothing
        end
    end
end

