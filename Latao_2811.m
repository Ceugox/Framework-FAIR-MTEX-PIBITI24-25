%% 1. Pré-processamento e Limpeza de Dados
% Selecionar apenas a fase Cobre (ignorar notIndexed)
ebsd_Cu = ebsd('Copper');

% Remover pontos isolados (opcional, melhora a qualidade dos mapas)
% [grains, ebsd_Cu.grainId] = calcGrains(ebsd_Cu);
% ebsd_Cu(grains(grains.grainSize < 3)) = []; % Remove grãos com menos de 3 pixels

%% 2. Reconstrução de Grãos
% Calcular grãos com limiar de 10 graus (padrão para contornos de alto ângulo)
[grains, ebsd_Cu.grainId] = calcGrains(ebsd_Cu, 'angle', 15*degree);

% Suavizar os contornos dos grãos para visualização mais limpa
grains = smooth(grains, 5);

%% 3. Visualização Espacial (Mapas)

% --- Mapa IPF (Inverse Pole Figure) ---
% Mostra a orientação cristalina relativa à direção Z (normal da amostra)
figure;
ipfKey = ipfColorKey(ebsd_Cu);
ipfKey.inversePoleFigureDirection = zvector;
colors = ipfKey.orientation2color(ebsd_Cu.orientations);

plot(ebsd_Cu, colors);
hold on;
plot(grains.boundary, 'linewidth', 1.5); % Desenha contornos de grão
title('Mapa de Orientação (IPF Z)');
hold off;

% --- Mapa de Contornos de Grão (Alto vs Baixo Ângulo) ---
figure;
plot(ebsd_Cu, 'bandcontrast'); % Fundo em escala de cinza (qualidade do padrão)
hold on;

% Contornos de Baixo Ângulo (2 a 10 graus) - Vermelho
gB_low = grains.boundary('Copper', 'Copper');
gB_low = gB_low(gB_low.misorientation.angle > 2*degree & gB_low.misorientation.angle < 10*degree);
plot(gB_low, 'lineColor', 'red', 'linewidth', 1);

% Contornos de Alto Ângulo (> 10 graus) - Preto
gB_high = grains.boundary('Copper', 'Copper');
gB_high = gB_high(gB_high.misorientation.angle > 15*degree);
plot(gB_high, 'lineColor', 'black', 'linewidth', 2);

title('Mapa de Contornos (Vermelho: 2-10° | Preto: >15°)');
hold off;

%% 4. Análise de Textura (ODF e Figuras de Polo)

% Calcular a Função de Distribuição de Orientação (ODF)
psi = calcKernel(ebsd_Cu.orientations);
odf = calcDensity(ebsd_Cu.orientations, 'kernel', psi);

% --- Figuras de Polo Direta (Pole Figures) ---
% Plotar os polos {100}, {110} e {111}
h = [Miller(1,0,0,odf.CS), Miller(1,1,0,odf.CS), Miller(1,1,1,odf.CS)];

figure;
plotPDF(odf, h, 'antipodal');
mtexColorbar;
title('Figuras de Polo Direta {100}, {110}, {111}');

% --- Figuras de Polo Inversa (Inverse Pole Figures) ---
% Mostra quais direções cristalográficas estão alinhadas com X, Y e Z da amostra
figure;
plotIPDF(odf, [xvector, yvector, zvector], 'antipodal');
mtexColorbar;
title('Figuras de Polo Inversa (Eixos X, Y, Z)');

%% 5. Análise de Desorientação Local (Strain/Deformação)

% --- Mapa KAM (Kernel Average Misorientation) ---
% Útil para visualizar deformação plástica local e densidade de discordâncias
kam = ebsd_Cu.KAM / degree; % Calcula em graus

figure;
plot(ebsd_Cu, kam);
mtexColorbar;
caxis([0, 5]); % Ajusta a escala de cores (0 a 5 graus geralmente é suficiente)
title('Mapa KAM (Kernel Average Misorientation)');

%% 6. Estatísticas de Desorientação

% --- Histograma de Ângulo de Desorientação ---
% Compara a distribuição dos contornos com uma distribuição aleatória (Mackenzie)
figure;
plotAngleDistribution(grains.boundary('Copper', 'Copper'));
hold on;
plotAngleDistribution(ebsd_Cu.CS, ebsd_Cu.CS, 'lineColor', 'r', 'DisplayName', 'Random (Mackenzie)');
legend show;
title('Distribuição de Ângulos de Desorientação');
xlabel('Ângulo de Desorientação (graus)');
