% Cria uma variável para as bordas dos grãos
gB = grains.boundary ;
% Define o filtro half - quadratic
F = halfQuadraticFilter ;
F. alpha = 0.1; % Grau de suaviza ção (0 a 1, maior = mais suavização)
F. eps = 0.1; % Tolerncia para contornos (0 a 1 , menor = mais sensível)
% Suaviza os dados indexados com o filtro e preenche vazios
ebsd_smoothed = smooth ( ebsd ('indexed') , F , 'fill', grains );
% Plota as orienta ções suavizadas para uma ou mais fases 
figure;
plot ( ebsd_smoothed ( 'Cu eletrolitico') , ebsd_smoothed ( 'Cu eletrolitico'). orientations , 'coordinates', 'off');
hold on ;
plot (gB , 'linewidth', 1) ;
title ('Orienta çõ es Suavizadas - Cu Eletrolítico');
hold off;
% Exemplo com duas fases ( austenita e ferrita )
figure;
plot ( ebsd_smoothed ( 'austenite') , ebsd_smoothed ( 'austenite').
orientations , 'coordinates', 'off');
hold on;
plot ( ebsd_smoothed ( 'ferrite') , ebsd_smoothed ( 'ferrite'). orientations ,'coordinates', 'off');
plot (gB , 'linewidth', 1) ;
title ('Orienta çõ es Suavizadas - Austenita e Ferrita ');
hold off ;
% Filtros alternativos
F_median = medianFilter ; % Filtro mediano , robusto para ruídos
F_median.numNeighbours = 3; % Nú mero de vizinhos ( ajustável )
ebsd_smoothed_median = smooth ( ebsd ( 'indexed') , F_median , 'fill',grains ) ;
F_spline = splineFilter ; % Filtro spline , suave para contornos
ebsd_smoothed_spline = smooth ( ebsd ( 'indexed ') , F_spline , 'fill ',grains ) ;
