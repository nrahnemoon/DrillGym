classdef SoilParticle < handle

    properties
        liquefactionEnergy
        currEnergy
        energyDecayFactor
        state
        absorptionFactors
    end
    
    methods
        
        function self = SoilParticle()
            self.state = SoilParticleState.Solid;
            self.currEnergy = 0;
        end
    end
    
end

