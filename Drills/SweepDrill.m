classdef SweepDrill < Drill
    
    properties (Constant)
        name = "SweepDrill";
        description = "Sweeps all the frequencies|first and then chooses|the best frequency."
    end

	properties
        sweepFrequency
        sweepStep
        trueTransmissionEnergies
        bestFeedbackEnergy
    end
    
    methods
        function self = SweepDrill(numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.sweepFrequency = 1;
            self.sweepStep = 5;
            self.bestFeedbackEnergy = energyPerCycle;
            self.setUniformEnergies();
            self.trueTransmissionEnergies = self.transmissionEnergies;
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            self.feedbackEnergies = feedbackEnergies;
            if self.sweepFrequency ~= -1
                if sum(feedbackEnergies) < self.bestFeedbackEnergy
                    self.trueTransmissionEnergies = self.transmissionEnergies;
                    self.bestFeedbackEnergy = sum(feedbackEnergies);
                end
                mu = double(self.sweepFrequency);
                sigma = double(self.numFrequencies/30);
                self.setNormalEnergies(mu, sigma);
                
                self.sweepFrequency = self.sweepFrequency + self.sweepStep;
                if self.sweepFrequency > self.numFrequencies
                    self.sweepFrequency = -1;
                end
            else
                self.transmissionEnergies = self.trueTransmissionEnergies;
            end
        end
    end
end

