classdef GreedyDrill < Drill
    
    properties (Constant)
        name = "GreedyDrill";
        description = "Transmits random normal transmission|energies every so often and|defaults to the best it's seen."
    end

	properties
        samplingRate
        isRandom
        trueTransmissionEnergies
        bestFeedbackEnergy
	end
    
    methods
        function self = GreedyDrill(samplingRate, numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.setRandomEnergies();
            self.samplingRate = samplingRate;
            self.isRandom = false;
            self.bestFeedbackEnergy = energyPerCycle;
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            self.feedbackEnergies = feedbackEnergies;
            if self.isRandom
                if sum(feedbackEnergies) < self.bestFeedbackEnergy
                    self.bestFeedbackEnergy = sum(feedbackEnergies);
                    self.trueTransmissionEnergies = self.transmissionEnergies;
                else
                    self.transmissionEnergies = self.trueTransmissionEnergies;
                end
                self.isRandom = false;
            elseif rand() < self.samplingRate
                self.trueTransmissionEnergies = self.transmissionEnergies;
                self.isRandom = true;
                self.setRandomEnergies();
            end
        end
    end
end

