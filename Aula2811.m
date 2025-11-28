%% 11. Análise Avançada de Textura: Cortes de ODF (ODF Sections)
% Para materiais CFC (Cobre, Alumínio), o corte mais importante é phi2 = 45 graus.
% É aqui que aparecem as texturas principais (Cubo, Goss, Brass, Copper, S).

figure;
% Plota a seção phi2 = 45 graus
plotSection(odf, 'phi2', 45*degree, 'points', 'all');
mtexColorbar;
title('Seção ODF \phi_2 = 45^\circ (Identificação de Textura CFC)');

% Dica: Se quiser ver as orientações ideais em cima do mapa:
hold on;
plot(cube, 'marker', 's', 'MarkerFaceColor', 'orange', 'DisplayName', 'Cube');
plot(goss, 'marker', 'd', 'MarkerFaceColor', 'cyan', 'DisplayName', 'Goss');
plot(copper, 'marker', 'o', 'MarkerFaceColor', 'green', 'DisplayName', 'Copper');
legend show;
hold off;

%% 12. Mapa de Fator de Taylor (Taylor Factor)
% Estima a resistência do grão à deformação plástica considerando que ele
% está "preso" pelos vizinhos (policristal).

% Definir o tensor de deformação (exemplo: compressão plana / laminação)
% eps = strainTensor(diag([1 0 -1])); % Plane Strain
% Ou tração simples em X:
eps = strainTensor(diag([1 -0.5 -0.5])); 

% Definir os sistemas de deslizamento (Slip Systems) para CFC {111}<110>
sS = slipSystem.fcc(CS_Cu);

% Calcular fator de Taylor (pode demorar um pouco dependendo do tamanho do mapa)
[M, ~] = calcTaylor(ebsd_Cu.orientations, sS, eps);

figure;
plot(ebsd_Cu, M);
mtexColorbar;
title('Mapa de Fator de Taylor (Resistência à Deformação)');
% Valores altos (vermelho) = grãos "duros". Valores baixos (azul) = grãos "moles".

%% 13. Anisotropia Elástica (Módulo de Young)
% Como a textura afeta a rigidez do material em diferentes direções?

% Carregar o tensor de rigidez do Cobre (padrão do MTEX)
C = stiffnessTensor.load('Cu', CS_Cu);

% Calcular o Módulo de Young médio do seu material baseado na ODF calculada
% (Ou seja, mistura as propriedades do cristal único com a sua textura)
C_poly = calcTensor(odf, C); 

% Plotar a variação do Módulo de Young em 3D
figure;
plot(C_poly, 'YoungsModulus');
mtexTitle('Variação do Módulo de Young (GPa) com a Direção');

% Ver valores exatos nos eixos principais
E_X = C_poly.YoungsModulus(xvector);
E_Y = C_poly.YoungsModulus(yvector);
E_Z = C_poly.YoungsModulus(zvector);

disp('--- Propriedades Elásticas Estimadas ---');
disp(['Módulo de Young em X (Rolling?): ', num2str(E_X/10^9, '%.1f'), ' GPa']);
disp(['Módulo de Young em Y (Transverse?): ', num2str(E_Y/10^9, '%.1f'), ' GPa']);
disp(['Módulo de Young em Z (Normal): ', num2str(E_Z/10^9, '%.1f'), ' GPa']);

%% 14. Morfologia dos Grãos (Aspect Ratio)
% Verifica se os grãos estão alongados (sinal de deformação prévia) ou equiaxiais (sinal de recozimento).

% Ajusta elipses aos grãos para medir eixos maior e menor
[a, b] = grains.fitEllipse;
aspect_ratio = a ./ b;

figure;
plot(grains, aspect_ratio);
mtexColorbar;
title('Razão de Aspecto dos Grãos (Alongamento)');

% Histograma
figure;
histogram(aspect_ratio);
xlabel('Aspect Ratio (Maior eixo / Menor eixo)');
ylabel('Contagem');
title('Distribuição da Forma dos Grãos');
% Se a moda for perto de 1, são grãos equiaxiais. Se for > 2 ou 3, são alongados.
