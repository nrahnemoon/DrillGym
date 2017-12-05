classdef SandParticle < SoilParticle
    
    properties (Constant)
        color =  [0.82, 0.71, 0.55];
        name = "Sand";
        reflectanceFactor = 0.5;
        scatteringFactor = 0.5;
        liquefactionEnergy = 700;
        energyDecayFactor = 0.95;
    end
    
    methods
        
        function self = SandParticle(absorptionFactors)
            self@SoilParticle(absorptionFactors)
            self.absorptionFactors = absorptionFactors;
            self.radiationFactors = ones(1, size(absorptionFactors, 2)) - absorptionFactors;
            self.radiationFactors = self.radiationFactors ./ sum(self.radiationFactors);
        end
    end
    
end

