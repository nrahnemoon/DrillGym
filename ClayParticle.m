classdef ClayParticle < SoilParticle
    
    properties (Constant)
        color = [0.55, 0.27, 0.07];
        name = "Clay";
        reflectanceFactor = 0.25;
        scatteringFactor = 0.75;
        liquefactionEnergy = 500;
        energyDecayFactor = 0.9;
    end
    
    methods
        
        function self = ClayParticle(absorptionFactors)
            self@SoilParticle(absorptionFactors);
            self.absorptionFactors = absorptionFactors;
            self.radiationFactors = ones(1, size(absorptionFactors, 2)) - absorptionFactors;
            self.radiationFactors = self.radiationFactors ./ sum(self.radiationFactors);
        end
    end
    
end

