classdef SoilParticle < handle

    properties
        currEnergy
        state
        absorptionFactors
        radiationFactors
        leftoverEnergies
    end
    
    methods
        
        function self = SoilParticle(absorptionFactors)
            self.state = SoilParticleState.Solid;
            self.currEnergy = 0;
            self.leftoverEnergies = zeros(1, size(absorptionFactors, 2));
        end
        
        function leftoverEnergies = dumpLeftoverEnergies(self)
            leftoverEnergies = self.leftoverEnergies;
            self.leftoverEnergies = zeros(1, size(self.leftoverEnergies, 2));
        end

        function receiveEnergies(self, energies)
            if self.state == SoilParticleState.Drill
                self.leftoverEnergies = self.leftoverEnergies + energies;
            else
                self.currEnergy = self.currEnergy + sum(self.absorptionFactors .* energies);
                self.leftoverEnergies = self.leftoverEnergies + energies - (self.absorptionFactors .* energies);
                
                if self.currEnergy > self.liquefactionEnergy
                    self.state = SoilParticleState.Liquefied;
                else
                    self.state = SoilParticleState.Solid;
                end
            end
        end

        function leftoverEnergies = decayEnergy(self)
            self.currEnergy = self.currEnergy * self.energyDecayFactor;
            leftoverEnergies = self.radiationFactors .* self.currEnergy;
        end
        
        function resetEnergies(self)
            self.currEnergy = 0;
            self.leftoverEnergies = zeros(1, size(self.leftoverEnergies, 2));
        end
    end
    
end

