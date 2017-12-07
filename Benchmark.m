gridSize = [20, 5]; % 100 rows, 5 columns
particleClasses = ["ClayParticle", "GraniteParticle", "SandParticle"];
particleDistributions = [0.8, 0.1, 0.1];
absorptionFactors = AbsorptionFactors(particleClasses, 100);



% Run Comparison



exploitationDrill = SimpleExploitationDrill(100, 30000);
grid1 = Grid(gridSize, particleClasses, particleDistributions, absorptionFactors, exploitationDrill);


banditDrill = BanditDrill(100, 20000);
grid2 = Grid(gridSize, particleClasses, particleDistributions, absorptionFactors, banditDrill);
grid2.fillMapByMapString(grid1.getMapString());


uniformDrill = UniformDrill(100, 20000);
grid3 = Grid(gridSize, particleClasses, particleDistributions, absorptionFactors, uniformDrill);
grid3.fillMapByMapString(grid1.getMapString());


randmDrill = RandomDrill(100, 20000);
grid4 = Grid(gridSize, particleClasses, particleDistributions, absorptionFactors, randmDrill);
grid4.fillMapByMapString(grid1.getMapString());






