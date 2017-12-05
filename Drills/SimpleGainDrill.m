classdef SimpleGainDrill < Drill
    
	properties (Constant)
        name = "SimpleGainDrill";
        description = "Determines the gain|(from 0 to 2) and amplifies the|last transmission energies by it."
    end

    methods
        function self = SimpleGainDrill(numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.setUniformEnergies();
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            self.feedbackEnergies = feedbackEnergies;
            gainEnergies = ((max(feedbackEnergies) + 0.1) - feedbackEnergies);
            gainEnergies = (gainEnergies ./ (max(feedbackEnergies) + 0.1)) .* 2;
            gainEnergies = (gainEnergies ./ (max(feedbackEnergies) + 0.1)) .* 2;
            self.transmissionEnergies = self.transmissionEnergies .* gainEnergies;
            self.transmissionEnergies = self.transmissionEnergies ./ sum(self.transmissionEnergies);
            self.transmissionEnergies = self.transmissionEnergies .* self.energyPerCycle;
        end
    end
end

