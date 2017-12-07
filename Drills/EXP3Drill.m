classdef EXP3Drill < Drill
    
    properties (Constant)
        name = "EXP3 Drill";
        description = "Does a exploration of all | Bandits and exploits the | one with local maxima";
    end
    
    properties
    end

    methods
        function self = EXP3Drill(numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.setUniformEnergies();
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            self.feedbackEnergies = feedbackEnergies;
            self.transmissionEnergies = self.transmissionEnergies - self.feedbackEnergies; % Loss
            
            % Best Bandit - Exploration
            [Val, Idx] =  max(self.transmissionEnergies);
            
            % Exploitation
            % Set Everything Else to zero
            self.transmissionEnergies(self.transmissionEnergies < Val) = 0;
            self.transmissionEnergies = self.transmissionEnergies .* (self.energyPerCycle/100);
        end
    end
end
