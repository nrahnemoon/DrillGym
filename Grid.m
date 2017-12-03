classdef Grid < handle

    properties (Constant)
        liquefiedColor = [0.49, 0.99, 0];
    end

    properties
        map
        particleClasses
        particleDistributions
        particleNames
        mapSize % [height, width]
        absorptionFactors
        drill
    end
    
    methods

        function self = Grid(mapSize, particleClasses, particleDistributions, absorptionFactors, drill)
            self.mapSize = mapSize;
            self.particleClasses = particleClasses;
            self.particleDistributions = particleDistributions;
            self.absorptionFactors = absorptionFactors;
            self.setParticleNames();
            self.fillMap();
            self.drill = drill;
        end

        function setParticleNames(self)
            self.particleNames = strings(size(self.particleDistributions, 2), 1);
            for i = 1:size(self.particleDistributions, 2)
                self.particleNames(i) = eval(strcat(self.particleClasses(i), '.name'));
            end
        end

        function colorDict = setColorMap(self, isDrill, isLiquefied)
            colorDict = containers.Map;
            nC = size(self.particleDistributions, 2) + int8(isDrill) + int8(isLiquefied); % + 2 for the drill and liquefiedColor
            colorMap = zeros(nC, 3);
            startColorIndex = 1;
            for i = 1:size(self.particleDistributions, 2)
                colorMap(i,:) = eval(strcat(self.particleClasses(i), '.color'));
                colorDict(char(eval(strcat(self.particleClasses(i), '.name')))) = startColorIndex;
                startColorIndex = startColorIndex + 1;
            end
            if isDrill
                colorMap(nC - 1,:) = self.drill.color;
                colorDict('Drill') = startColorIndex;
                startColorIndex = startColorIndex + 1;
            end
            if isLiquefied
                colorMap(nC,:) = self.liquefiedColor;
                colorDict('Liquefied') = startColorIndex;
            end

            colormap(colorMap);
        end

        function fillMap(self)
            self.map = cell(self.mapSize(1), self.mapSize(2));
            for row = 1:self.mapSize(1)
                for col = 1:self.mapSize(2)
                    self.map{row, col} = self.getRandomSoilParticle();
                end
            end
        end

        function [particle] = getRandomSoilParticle(self)
            random = rand();
            curr = 0;
            for i = 1:size(self.particleDistributions, 2)
                curr = curr + self.particleDistributions(i);
                if random < curr
                    particle = eval(strcat(self.particleClasses(i), '(self.absorptionFactors.get("', self.particleClasses(i), '"))'));
                    return;
                end
            end
        end
        
        function updateDisplay(self)
            isDrill = false;
            isLiquefied = false;
            for i = 1:size(self.map, 1)
                for j = 1:size(self.map, 2)
                    if self.map{i,j}.state == SoilParticleState.Liquefied
                        isLiquefied = true;
                    elseif self.map{i,j}.state == SoilParticleState.Drill
                        isDrill = true;
                    end
                end
            end
            colorMap = self.setColorMap(isDrill, isLiquefied);
            [X,Y] = meshgrid(1:self.mapSize(2)+1, 1:self.mapSize(1)+1);
            Z = ones(self.mapSize(1)+1, self.mapSize(2)+1);
            for i = 1:size(self.map, 1)
                for j = 1:size(self.map, 2)
                    if self.map{i, j}.state == SoilParticleState.Solid
                        Z(i, j) = colorMap(char(self.map{i, j}.name));
                    elseif self.map{i, j}.state == SoilParticleState.Liquefied
                        Z(i, j) = colorMap("Liquefied");
                    elseif self.map{i, j}.state == SoilParticleState.Drill
                        Z(i, j) = colorMap("Drill");
                    end
                end
            end
            plot = pcolor(X,Y,Z);
            set(plot, 'EdgeColor', [0.96, 0.64, 0.38]);
            nP = double(colorMap.Count);
            colorbar('YTick', (min(Z) + 1/nP):((max(Z)-min(Z))/nP):(max(Z) - 1/nP), 'YTickLabel', keys(colorMap));
            for i = 1:size(self.map, 1)
                for j = 1:size(self.map, 2)
                    cell = self.map{i, j};
                    text(j+0.5, i+0.5, strcat(string(cell.currEnergy), '/', string(cell.liquefactionEnergy)), 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'Color', 'white');
                end
            end
        end
    end
    
end

