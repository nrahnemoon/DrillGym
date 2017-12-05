classdef PeakDrill < Drill
    
    properties (Constant)
        name = "PeakDrill";
        description = "Iteratively finds local minima | in feedback energies and | blasts energy at those points.";
    end
    
    properties
        peakFrequencies
        peakSigmas
    end

    methods
        function self = PeakDrill(numFrequencies, energyPerCycle)
            self@Drill(numFrequencies, energyPerCycle);
            self.setUniformEnergies();
        end
        
        function receiveFeedbackEnergies(self, feedbackEnergies)
            self.feedbackEnergies = feedbackEnergies;
            [~, locs] = findpeaks(smooth(feedbackEnergies) .* -1);
            for i = 1:size(locs, 1)
                if ~ismember(locs(i), self.peakFrequencies) 
                    self.peakFrequencies = [ self.peakFrequencies, locs(i) ];
                    self.peakSigmas = [ self.peakSigmas, (size(self.transmissionEnergies, 2)/5) ];
                end
            end

            self.transmissionEnergies = zeros(1, size(self.transmissionEnergies, 2));
            for i = 1:size(self.peakFrequencies, 2)
                self.transmissionEnergies = self.transmissionEnergies + pdf('Normal', 1:self.numFrequencies, self.peakFrequencies(i), self.peakSigmas(i));
                self.peakSigmas(i) = (self.peakSigmas(i)/2);
            end
            self.transmissionEnergies = self.transmissionEnergies .* (self.energyPerCycle/sum(self.transmissionEnergies));
        end
    end
end
