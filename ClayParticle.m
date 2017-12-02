classdef ClayParticle < SoilParticle
    
    properties
    end
    
    methods
        
        function init(self)
            self.name = "Clay";
            self.liquefactionEnergy = 5000;
            self.currEnergy = 0;
            self.energyDecayFactor = 0.9;
            self.isLiquefied = false;
            self.absorptionFactors = [0, 0, 0.125, 0.75, 0.125]; % Replace this with a 100 size vector that sums to 1
        end
    end
    
end

