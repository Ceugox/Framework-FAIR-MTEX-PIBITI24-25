%% --- SCRIPT COMPLETO DE ANÁLISE EBSD: LATÃO ---
% Arquivo: Latao_MarcosLacerda.ctf
% Ajustes: Grãos > 10 graus, Correção de GND, Análise de Textura Completa

%% 1. Importação e Configuração Inicial

% Limpar workspace para evitar conflitos de variáveis antigas
close all; clear; clc;

% Configuração de Simetria (Fase 'Copper' para Latão)
CS = {... 
  'notIndexed',...
  crystalSymmetry('m-3m', [3.6 3.6 3.6], 'mineral', 'Copper', 'color', [0.53 0.81 0.98])};

% Preferências de Plotagem
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% Caminho e Arquivo
pname = 'C:\Users\marce\Documents\PIBITI\Aula281125';
fname = [pname '\Latao_MarcosLacerda.ctf'];

% Carregar Dados
ebsd = EBSD.load(fname,CS,'interface','ctf',...
  'convertSpatial2EulerReferenceFrame');

disp('Dados importados com sucesso!');

%% 2. Pré-processamento (Limpeza e Grid)

% Selecionar apenas a fase indexada (Copper)
ebsd_Latao = ebsd('Copper');

% Converter para GRID (Essencial para mapas de qualidade e cálculo de GND)
ebsd_grid = ebsd_Latao.gridify;

% Verificar se o gridify funcionou
if isempty(ebsd_grid)
    warning('Gridify retornou vazio. Verifique se os dados são de varredura regular.');
    ebsd_grid = ebsd_Latao; % Fallback
end

%% 3. Reconstrução de Grãos (Limiar de 10 graus)

disp('Calculando grãos (Limiar > 15º)...');
% Cálculo dos grãos com ângulo crítico de 10 graus
[grains, ebsd_grid.grainId] = calcGrains(ebsd_grid, 'angle', 15*degree);

% Suavização dos contornos (reduz o efeito pixelado)
grains = smooth(grains, 5);

% Remover grãos muito pequenos (ruído) - Opcional, descomente se quiser limpar
% ebsd_grid(grains(grains.grainSize < 3)) = [];
% [grains, ebsd_grid.grainId] = calcGrains(ebsd_grid, 'angle', 10*degree);
% grains = smooth(grains, 5);

%% 4. Mapa 1: Orientação (IPF Z) e Grãos

figure;
ipfKey = ipfColorKey(ebsd_grid);
ipfKey.inversePoleFigureDirection = zvector;
colors = ipfKey.orientation2color(ebsd_grid.orientations);

plot(ebsd_grid, colors);
hold on;
plot(grains.boundary, 'linewidth', 1, 'lineColor', 'black');
title('Mapa IPF Z (Grãos > 10^\circ)');
hold off;

%% 5. Mapa 2: Contornos de Grão (Alto vs Baixo Ângulo)

figure;
plot(ebsd_grid, 'bandcontrast');
hold on;

gB = grains.boundary('Copper', 'Copper');

% Baixo Ângulo (LAGB): 2º a 10º
gB_low = gB(gB.misorientation.angle >= 2*degree & gB.misorientation.angle < 15*degree);
plot(gB_low, 'lineColor', 'red', 'linewidth', 1, 'DisplayName', 'Baixo (2-10º)');

% Alto Ângulo (HAGB): > 10º
gB_high = gB(gB.misorientation.angle >= 15*degree);
plot(gB_high, 'lineColor', 'black', 'linewidth', 2, 'DisplayName', 'Alto (>15º)');

legend show;
title('Mapa de Contornos (Vermelho: LAGB | Preto: HAGB)');
hold off;

%% 6. Mapa 3: Identificação de Maclas (Sigma 3)

% Definir limite Sigma 3 (Macle de recozimento em CFC)
sigma3 = boundaryDefinition.sigma(ebsd_grid.CS, ebsd_grid.CS, 3);
isTwinning = gB.isBoundary(sigma3, 5*degree); % Tolerância de 5 graus

figure;
plot(ebsd_grid, 'bandcontrast');
hold on;
plot(gB(isTwinning), 'lineColor', 'blue', 'linewidth', 2);
title('Mapa de Maclas \Sigma3 (Azul)');
hold off;

%% 7. Análise de Textura (ODF e Figuras de Polo)

disp('Calculando ODF e Figuras de Polo...');
psi = calcKernel(ebsd_grid.orientations);
odf = calcDensity(ebsd_grid.orientations, 'kernel', psi);

% Figuras de Polo Direta {100}, {110}, {111}
h = [Miller(1,0,0,ebsd_grid.CS), Miller(1,1,0,ebsd_grid.CS), Miller(1,1,1,ebsd_grid.CS)];

figure;
plotPDF(odf, h, 'antipodal');
mtexColorbar;
title('Figuras de Polo Direta');

% Seção ODF phi2 = 45 (Importante para Latão/Cobre)
figure;
plotSection(odf, 'phi2', 45*degree, 'points', 'all');
mtexColorbar;
title('Seção ODF \phi_2 = 45^\circ (Identificação de Textura)');

%% 8. Mapa 4: Deformação Local (KAM)

% Kernel Average Misorientation
kam = ebsd_grid.KAM / degree;

figure;
plot(ebsd_grid, kam);
mtexColorbar;
caxis([0, 4]); % Ajuste de escala visual
title('Mapa KAM (Deformação Local)');

%% 9. Mapa 5: Densidade de Discordâncias (GND)

disp('Calculando Densidade de Discordâncias (GND)...');
% Definir sistemas de deslizamento
dS = dislocationSystem.fcc(ebsd_grid.CS);

% Calcular tensor de curvatura (suavizado)
kappa = ebsd_grid.curvature('smooth');

% Resolver sistemas
[rho, ~] = fitDislocationSystems(kappa, dS);

% Converter para m^-2
total_GND_SI = sum(abs(rho), 2) * 1e12;

figure;
plot(ebsd_grid, total_GND_SI, 'micromap');
mtexColorbar;
set(gca,'ColorScale','log');
title('Densidade Estimada de GND (m^{-2})');

%% 10. Mapa 6: Fator de Taylor e Schmid

% --- Fator de Taylor (Resistência plástica) ---
% Carga: Compressão Plana (ex: Laminação)
eps = strainTensor(diag([1 0 -1])); 
sS = slipSystem.fcc(ebsd_grid.CS);
[M, ~] = calcTaylor(ebsd_grid.orientations, sS, eps);

figure;
plot(ebsd_grid, M);
mtexColorbar;
title('Fator de Taylor (Dureza Relativa)');

% --- Fator de Schmid (Facilidade de deslizamento) ---
% Carga: Tração em X
SF = sS.SchmidFactor(ebsd_grid.orientations, xvector);

figure;
plot(ebsd_grid, max(SF, [], 2));
mtexColorbar;
title('Fator de Schmid Máximo (Carga X)');

%% 11. Estatísticas Finais

% Histograma de Desorientação
figure;
plotAngleDistribution(gB, 'faceColor', [0.2 0.2 0.8]);
hold on;
plotAngleDistribution(ebsd_grid.CS, ebsd_grid.CS, 'lineColor', 'r', 'linewidth', 2, 'DisplayName', 'Mackenzie');
legend show;
title('Distribuição de Ângulos de Desorientação');

disp('--- Análise Concluída ---');
