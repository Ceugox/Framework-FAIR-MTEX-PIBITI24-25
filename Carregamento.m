% Carrega os dados indexados do arquivo EBSD
ebsd = EBSD . load ( ' nome_do_arquivo . ctf '); % Substitua ' nome_do_arquivo.ctf ' pelo caminho do seu arquivo
% Verifica as fases disponíveis no arquivo
ebsd . mineralList  % Exibe as fases , e.g. , {'Cu eletrolitico ', 'austenite ', 'ferrite '}
% Seleciona apenas os dados indexados
ebsd_indexed = ebsd ( 'indexed');
% Seleciona uma fase específica (ex: Cu eletrolitico )
ebsd_phase = ebsd ( 'Cu eletrolitico ');
% Plota as orientações iniciais da fase selecionada
figure ;
plot ( ebsd_phase , ebsd_phase . orientations , ' coordinates ', 'off ');
title ('Orientações Iniciais - Cu Eletrolítico ');
