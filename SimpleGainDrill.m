classdef SimpleGainDrill < Drill
    
    methods
        function self = SimpleGainDrill(numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.name = "SimpleGainDrill";
            self.setUniformEnergies();
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            gainEnergies = ((max(feedbackEnergies) + 0.1) - feedbackEnergies);
            gainEnergies = (gainEnergies ./ (max(feedbackEnergies) + 0.1)) .* 2;
            gainEnergies = (gainEnergies ./ (max(feedbackEnergies) + 0.1)) .* 2;
            self.transmissionEnergies = self.transmissionEnergies .* gainEnergies;
            self.transmissionEnergies = self.transmissionEnergies ./ sum(self.transmissionEnergies);
            self.transmissionEnergies = self.transmissionEnergies .* self.energyPerCycle;
        end
    end
end

