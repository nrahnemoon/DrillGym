classdef ClayParticle < SoilParticle
    
    properties (Constant)
        color = [0.55, 0.27, 0.07];
        name = "Clay";
    end
    
    methods
        
        function self = ClayParticle(absorptionFactors)
            self@SoilParticle();
            self.liquefactionEnergy = 5000;
            self.energyDecayFactor = 0.9;
            self.absorptionFactors = absorptionFactors;
        end
    end
    
end

