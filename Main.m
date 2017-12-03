gridSize = [20, 5]; % 100 rows, 5 columns
particleClasses = ["ClayParticle", "GraniteParticle", "SiltParticle"];
particleDistributions = [0.8, 0.1, 0.1];
absorptionFactors = AbsorptionFactors(particleClasses, 100);
drill = Drill(100, 1000);
grid = Grid(gridSize, particleClasses, particleDistributions, absorptionFactors, drill);
