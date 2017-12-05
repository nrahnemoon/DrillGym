classdef Grid < handle

    properties (Constant)
        liquefiedColor = [0.49, 0.99, 0];
        s = 1; % seed
    end

    properties
        map
        particleClasses
        particleDistributions
        particleNames
        mapSize % [height, width]
        absorptionFactors
        drill
        drillRow
        iterationNum
        transmissionLoss
        plots
        plotTexts
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
            self.drillRow = self.mapSize(1);
            self.closeRow(self.drillRow);
            self.iterationNum = 0;
            self.transmissionLoss = 0.9;
            self.plotTexts = [];
        end

        function play(self)
            figure('units','normalized','outerposition', [0 0 1 1]); % Make figure full screen initially
            axes('Units', 'normalized', 'Position', [0 0 1 1]); % Make plots take up entire figure space
            self.updateDisplay();
            while 1
                self.iterate();
                self.updateDisplay();
                if self.drillRow == 1
                    disp(strcat("Completed ultrasonic drilling in ", num2str(self.iterationNum), " iterations!"));
                    return;
                end
            end
        end

        function closeRow(self, row)
            for i = 1:size(self.map, 2)
                self.map{row, i}.state = SoilParticleState.Drill;
            end
        end

        function setParticleNames(self)
            self.particleNames = strings(size(self.particleDistributions, 2), 1);
            for i = 1:size(self.particleDistributions, 2)
                self.particleNames(i) = eval(strcat(self.particleClasses(i), '.name'));
            end
        end

        function colorDict = setColorMap(self, isDrill, isLiquefied)
            colorDict = containers.Map;
            nC = size(self.particleDistributions, 2) + double(isDrill) + double(isLiquefied); % + 2 for the drill and liquefiedColor
            colorMap = zeros(nC, 3);
            startColorIndex = 1;
            for i = 1:size(self.particleDistributions, 2)
                colorMap(i,:) = eval(strcat(self.particleClasses(i), '.color'));
                colorDict(char(eval(strcat(self.particleClasses(i), '.name')))) = startColorIndex;
                startColorIndex = startColorIndex + 1;
            end
            if isDrill
                colorMap(startColorIndex,:) = self.drill.color;
                colorDict('Drill') = startColorIndex;
                startColorIndex = startColorIndex + 1;
            end
            if isLiquefied
                colorMap(startColorIndex,:) = self.liquefiedColor;
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
            %rng(self.s); % Seeding Random 
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
                        Z(i, j) = colorMap('Liquefied');
                    elseif self.map{i, j}.state == SoilParticleState.Drill
                        Z(i, j) = colorMap('Drill');
                    end
                end
            end
            
            plotSize = [];
            for i = 1:(4 * (size(self.particleNames, 1) + 1))
                plotSize = [plotSize, (16 * (i - 1)) + [1, 2, 3, 4, 5, 6, 7, 8]];
            end
            subplot(4 * (size(self.particleNames, 1) + 1), 16, plotSize);
            pColorPlot = pcolor(X,Y,Z);
            set(pColorPlot, 'EdgeColor', [0.3, 0.3, 0.3]);
            nP = double(colorMap.Count);
            colorKeys = cell(1, nP);
            colorMapKeys = keys(colorMap);
            for i = 1:nP
                colorKeys{colorMap(colorMapKeys{i})} = colorMapKeys{i};
            end
            colorbar('YTick', (min(min(Z)) + 1/nP):((max(max(Z))-min(min(Z)))/nP):(max(max(Z)) - 1/nP), 'YTickLabel', colorKeys);
            for i = 1:size(self.map, 1)
                for j = 1:size(self.map, 2)
                    if self.map{i, j}.state ~= SoilParticleState.Drill
                        mapCell = self.map{i, j};
                        text(j+0.5, i+0.5, strcat(sprintf('%0.1f', mapCell.currEnergy), '/', string(mapCell.liquefactionEnergy)), 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'Color', 'white');
                    end
                end
            end
            text(1, self.mapSize(1) + 2.0, strcat("Iteration: ", num2str(self.iterationNum)), 'HorizontalAlignment', 'left', 'FontName', 'FixedWidth', 'Color', 'black', 'FontSize', 15);
            hold on

            % Plot for drill transmission energies
            subplot(4 * (size(self.particleNames, 1) + 1), 16, [10, 11, 12, 13, 26, 27, 28, 29, 42, 43, 44, 45]);
            numFrequencies = size(self.absorptionFactors.particleAbsorptionFactors, 2);
            frequencies = linspace(1, numFrequencies, numFrequencies);
            for i = 1:size(self.plots, 2)
                cla(self.plots(i));
            end
            self.plots = [];
            for i = 1:(size(self.plotTexts, 2))
                delete(self.plotTexts(1, i));
            end
            self.plotTexts = [];
            if isempty(self.drill.feedbackEnergies)
                drillPlot = area(frequencies, [self.drill.transmissionEnergies]);
                drillPlot.FaceColor = self.drill.color;
                self.plots = [self.plots, drillPlot];
                legend('T.E.');
            else
                drillPlot = area(frequencies, [self.drill.feedbackEnergies; self.drill.transmissionEnergies]');
                drillPlot(2).FaceColor = self.drill.color;
                drillPlot(1).FaceColor = [0.68, 0.85,0.90];
                self.plots = [ self.plots, drillPlot(1) ];
                legend('F.E.', 'T.E.');
            end
            hold on
            %title(strcat(self.drill.name, "'s Transmission Energies"));
            xlabel('Frequencies');
            ylabel('Energy');
            ylim([0, 1000])
            
            for i = 1:size(self.absorptionFactors.particleClasses,2)
                subplot(4 * (size(self.particleNames, 1) + 1), 16, (4 * 16 * i) + [10, 11, 12, 13, 26, 27, 28, 29,  42, 43, 44, 45]);
                soilName = eval(strcat(self.absorptionFactors.particleClasses(i), ".name"));
                soilColor = eval(strcat(self.absorptionFactors.particleClasses(i), ".color"));
                soilPlot = area(frequencies, self.absorptionFactors.particleAbsorptionFactors(i,:));
                soilPlot(1).FaceColor = soilColor;
                self.plots = [self.plots, soilPlot];
                hold on
                %title(strcat(soilName, "'s Absorption Factors"));
                xlabel('Frequencies');
                ylabel('Absorption Factor');
                ylim([0, 1])
            end
            
            ax = subplot(4 * (size(self.particleNames, 1) + 1), 16, [15, 16]);
            self.plotTexts = [ self.plotTexts, text(0.5, 0.25, self.drill.name, 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'Color', 'black', 'FontSize', 14) ];
            self.plotTexts = [ self.plotTexts, text(0.5, -0.5, strcat("Energy per cycle = ", num2str(self.drill.energyPerCycle)), 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'Color', 'black') ];
            self.plotTexts = [ self.plotTexts, text(0.5, -1.0, strcat("Drill depth = ", num2str((self.mapSize(1) + 1) - self.drillRow)), 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'Color', 'black') ];
            descriptions = strsplit(self.drill.description, '|');
            for i = 1:size(descriptions, 2)
                self.plotTexts = [ self.plotTexts, text(0.5,(i * -0.5 - 1.25), descriptions(i), 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'Color', 'black'); ]
            end
            set (ax, 'visible', 'off');
            axis off
            hold on
            
            for i = 1:size(self.absorptionFactors.particleClasses,2)
                soilName = eval(strcat(self.absorptionFactors.particleClasses(i), ".name"));
                soilLiquefactionEnergy = eval(strcat(self.absorptionFactors.particleClasses(i), ".liquefactionEnergy"));
                soilEnergyDecayFactor = eval(strcat(self.absorptionFactors.particleClasses(i), ".energyDecayFactor"));
                soilReflectanceFactor = eval(strcat(self.absorptionFactors.particleClasses(i), ".reflectanceFactor"));
                soilScatteringFactor = eval(strcat(self.absorptionFactors.particleClasses(i), ".scatteringFactor"));

                ax = subplot(4 * (size(self.particleNames, 1) + 1), 16, (4 * 16 * i) + [15, 16]);
                text(0.5, 0.25, soilName, 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'Color', 'black', 'FontSize', 14);
                text(0.5, -0.5, strcat("Liquefaction Energy = ", num2str(soilLiquefactionEnergy)), 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'Color', 'black');
                text(0.5, -1.0, strcat("Engergy Decay Factor = ", num2str(soilEnergyDecayFactor)), 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'Color', 'black');
                text(0.5, -1.5, strcat("Reflectance Factor = ", num2str(soilReflectanceFactor)), 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'Color', 'black');
                text(0.5, -2.0, strcat("Scattering Factor = ", num2str(soilScatteringFactor)), 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'Color', 'black');
                
                set (ax, 'visible', 'off');
                axis off
                hold on
            end

            pause(0.00001);
        end
        
        function iterate(self)
            self.iterationNum = self.iterationNum + 1;
            
            % For the rows that are "drills", reset energies
            for i=self.mapSize(1):self.drillRow
                for j=1:self.mapSize(2)
                    self.map{i, j}.resetEnergies();
                end
            end

            for j=1:self.mapSize(2)
                    self.map{(self.drillRow - 1), j}.receiveEnergies(self.transmissionLoss .* (self.drill.transmissionEnergies./self.mapSize(2)));
            end

            leftoverEnergies = zeros(self.mapSize(1), self.mapSize(2), size(self.absorptionFactors.particleAbsorptionFactors, 2));
            neighbors = [[-1, 0]; [0, 1]; [1, 0]; [0, -1]];
            for i=1:(self.drillRow - 1)
                for j=1:self.mapSize(2)
                    latentLeftoverEnergies = self.map{i, j}.decayEnergy();
                    transmitLeftoverEnergies = self.map{i, j}.dumpLeftoverEnergies();
                    reflectanceEnergies = (latentLeftoverEnergies ./ 4)' + (transmitLeftoverEnergies .* self.map{i, j}.reflectanceFactor)';
                    scatterEnergies = (latentLeftoverEnergies ./ 4)' + (transmitLeftoverEnergies .* (self.map{i, j}.scatteringFactor/3))';
                    for k = 1:size(neighbors, 1)
                        if self.isValidPos((i + neighbors(k, 1)), (j + neighbors(k, 2)))
                            currNeighborLeftoverEnergies = reshape(leftoverEnergies((i + neighbors(k,1)), (j + neighbors(k, 2)), :), [size(leftoverEnergies,3), 1]);
                            if neighbors(k, 1) == 1 && neighbors(k, 2) == 0
                                leftoverEnergies((i + neighbors(k,1)), (j + neighbors(k, 2)), :) = currNeighborLeftoverEnergies + reflectanceEnergies;
                            else
                                leftoverEnergies((i + neighbors(k,1)), (j + neighbors(k, 2)), :) = currNeighborLeftoverEnergies + scatterEnergies;
                            end
                        end
                    end
                end
            end
            
            for i=1:self.mapSize(1)
                for j=1:self.mapSize(2)
                    self.map{i, j}.receiveEnergies(self.transmissionLoss .* reshape(leftoverEnergies(i,j,:), [1, size(leftoverEnergies,3)]));
                end
            end
            
            drillFeedbackEnergies = zeros(1, size(self.absorptionFactors.particleAbsorptionFactors, 2));
            for i=self.drillRow:self.mapSize(1)
                for j=1:self.mapSize(2)
                    drillFeedbackEnergies = drillFeedbackEnergies + self.map{i, j}.dumpLeftoverEnergies();
                end
            end
            self.drill.receiveFeedbackEnergies(drillFeedbackEnergies);

            while 1
                currRowLiquefied = true;
                for i = 1:self.mapSize(2)
                    if self.map{(self.drillRow - 1), i}.state ~= SoilParticleState.Liquefied
                        currRowLiquefied = false;
                    end
                end
                if currRowLiquefied
                    self.closeRow(self.drillRow - 1);
                    self.drillRow = self.drillRow - 1;
                    if self.drillRow == 1
                        return
                    end
                else
                    break;
                end
            end
        end
        
        function isValid = isValidPos(self, i, j)
            if (i <= self.mapSize(1) && i >= 1 && j <= self.mapSize(2) && j >= 1)
                isValid = true;
            else
                isValid = false;
            end
        end
    end
end

