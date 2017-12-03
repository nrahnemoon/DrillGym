classdef SiltParticle < SoilParticle
    
    properties (Constant)
        color =  [0.82, 0.71, 0.55];
        name = "Silt";
    end
    
    methods
        
        function self = SiltParticle(absorptionFactors)
            self@SoilParticle()
            self.liquefactionEnergy = 7000;
            self.energyDecayFactor = 0.95;
            self.absorptionFactors = absorptionFactors;
        end
    end
    
end

