% Seleciona grãos com mais de 2 pixels ( ajuste conforme necessário )
temp = grains . grainSize > 2;
selected_grains = grains ( temp );
% Áreas em m (em MTEX , grains . area já costuma estar em m )
grain_area_um2 = selected_grains.area ;
% Alternativa : calcular pela contagem de pixels (se necessário )
% pixel_size_um = 0.5; % m por pixel
% grain_area_um2 = selected_grains . grainSize * pixel_size_um ^2;
% Define os limites dos bins para o histograma (em m )
binEdges = 0:1:80;
% Calcula o histograma e normaliza para porcentagem
counts = histcounts ( grain_area_um2 , binEdges );
total = sum( counts ) ;
fraction = counts / max (1 , total ) * 100;
% Centros dos bins para o grá fico de barras
binCenters = binEdges (1: end -1) + diff ( binEdges ) /2;
% Plota o histograma
figure ;
bar( binCenters , fraction , 1, 'FaceColor ', [0.2 0.6 0.8] , 'EdgeColor ','none');
xlabel ('Tamanho de Gr ão ($ \ mu m ^2 $) ', ' Interpreter ', 'latex');
ylabel ('Fração (%)');
title ('Distribuição de Tamanho de Grãos ', ' Interpreter', 'latex');
grid on ;
% Adiciona uma linha vertical para a média
avg_size = mean ( grain_area_um2 ) ;
xline ( avg_size , 'r', sprintf ('Média : %.1 f $ \ mu m ^2 $ ', avg_size ) , ...
' LabelOrientation ', 'aligned ', ' LabelVerticalAlignment ', 'bottom', Interpreter ', 'latex ');
% Ajusta os limites dos eixos
xlim ([ binEdges (1) binEdges ( end ) ]) ;
ylim ([0 max ( fraction ) *1.2]) ;
