classdef GraniteParticle < SoilParticle
    
    properties (Constant)
        color = [0.66, 0.66, 0.66];
        name = "Granite";
    end
    
    methods
        
        function self = GraniteParticle(absorptionFactors)
            self@SoilParticle()
            self.liquefactionEnergy = 16000;
            self.energyDecayFactor = 0.99;
            self.absorptionFactors = absorptionFactors;
        end
    end
    
end

