classdef ConstantDrill < Drill
    
    properties (Constant)
            name = "ConstantDrill";
            description = "Drill with random,|yet static transmission|energies."
    end

    methods
        function self = ConstantDrill(numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.setRandomEnergies();
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            self.feedbackEnergies = feedbackEnergies;
            % Do Nothing
        end
    end
end

