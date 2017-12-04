gridSize = [20, 5]; % 100 rows, 5 columns
particleClasses = ["ClayParticle", "GraniteParticle", "SandParticle"];
particleDistributions = [0.8, 0.1, 0.1];
absorptionFactors = AbsorptionFactors(particleClasses, 100);
drill = UniformDrill(100, 10000);
grid = Grid(gridSize, particleClasses, particleDistributions, absorptionFactors, drill);
grid.play()
