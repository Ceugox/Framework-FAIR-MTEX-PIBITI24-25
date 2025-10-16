% Calcula os grãos com um ngulo de desorientação de 15 graus ( ajustável )
[ grains , ebsd.grainId ] = calcGrains ( ebsd ( 'indexed') , 'angle', 15*degree ) ;
% Plota os grãos calculados
figure ;
plot ( grains , 'linewidth', 0.5) ;
title ('Grãos Calculados - ângulo de 15 Graus ');
% Remove grãos menores que 3 pixels ( ajustável )
ebsd ( grains ( grains . grainSize < 3) ) = [];
% Recalcula os grãos com um ngulo de desorientação de 10 graus (ajustável )
[ grains , ebsd.grainId ] = calcGrains ( ebsd ( 'indexed') , 'angle', 10*degree ) ;
% Suaviza as bordas dos grãos com raio 2 ( ajustável )
grains = smooth ( grains , 2) ;
% Plota os grãos suavizados
figure ;
plot ( grains , 'linewidth', 0.5) ;
title ('Grãos Suavizados - ângulo de 10 Graus ');
