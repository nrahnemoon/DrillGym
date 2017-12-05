classdef GraniteParticle < SoilParticle
    
    properties (Constant)
        color = [0.66, 0.66, 0.66];
        name = "Granite";
        reflectanceFactor = 0.95;
        scatteringFactor = 0.05;
        liquefactionEnergy = 1600;
        energyDecayFactor = 0.99;
    end
    
    methods
        
        function self = GraniteParticle(absorptionFactors)
            self@SoilParticle(absorptionFactors)
            self.absorptionFactors = absorptionFactors;
            self.radiationFactors = ones(1, size(absorptionFactors, 2)) - absorptionFactors;
            self.radiationFactors = self.radiationFactors ./ sum(self.radiationFactors);
        end
    end
    
end

