classdef Grid

    properties
        particleDistribution
    end
    
    methods

        function init(self)
            self.particleDistribution = [0.8, 0.1, 0.1]; % Clay, Granite, Silt distribution in that order
        end

        function [particle] = getRandomSoilParticle(self)
            random = rand();
            curr = 0;
            for i = 1:size(self.particleDistribution, 2)
                curr = curr + self.particleDistribution(i);
                if random < curr
                    particle = getSoilParticleByIndex(i);
                end
            end
        end
        
        function [value] = getSoilParticleByIndex(self, index)
            if index == 1
                value = ClayParticle();
            elseif index == 2
                value = GraniteParticle();
            else
                value = SiltParticle();
            end
            return;
        end
    end
    
end

