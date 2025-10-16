% Calcula grãos e misorientação com limiar de 5 graus ( ajustável )
[ grains , ebsd_smoothed.grainId , ebsd_smoothed.mis2mean ] = calcGrains (ebsd_smoothed , 'threshold', 5*degree ) ;
gB = grains . boundary ;
figure ;
plot ( ebsd_smoothed ( 'Iron') , ebsd_smoothed ( 'Iron'). mis2mean . angle ./degree , 'micronbar ', 'off ');
hold on ;
plot (gB , 'linewidth', 1.3) ;
title (' Misorientação Média - Iron');
hold off ;
