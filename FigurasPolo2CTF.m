%% Seleção das fases
phaseNames = { 'Austenite , fcc ( New ) ','Iron'};
% Planos cristalogr á ficos para cubic m-3m
for i = 1: numel ( phaseNames )
phaseEBSD = ebsd ( phaseNames {i}) ;
if isempty ( phaseEBSD . orientations )
fprintf ('Nenhuma orienta çã o encontrada para a fase % s\n ',phaseNames {i}) ;
continue
end
ori = phaseEBSD . orientations ;
CS = phaseEBSD . CS ;
% planos {100} , {110} , {111}
h = [ Miller (1 ,0 ,0 , CS ) , Miller (1 ,1 ,0 ,CS) , Miller (1 ,1 ,1 , CS) ];
% ODF suave
odf = calcDensity ( ori , 'halfwidth' ,10*degree);
% Pole figures recalculadas
pf = calcPoleFigure (odf,h) ;
% Plot suave , preenchido
figure ;
plot (pf ,'contourf','MinMax','off','colorrange','equal','smooth');
mtexColorbar ;
title ([ 'Figuras de Polo Recalculadas - ' phaseNames {i}]) ;
end
%% Seleção das fases
phaseNames = { 'Austenite , fcc ( New ) ','Iron'};
for i = 1: numel ( phaseNames )
phaseEBSD = ebsd ( phaseNames {i}) ;
if isempty ( phaseEBSD . orientations )
fprintf ('Nenhuma orienta çã o encontrada para a fase % s\n ',
phaseNames {i}) ;
continue
end
ori = phaseEBSD . orientations ;
CS = phaseEBSD . CS ;
%% --- 1) ODF ---
odf = calcDensity ( ori , 'halfwidth ' ,10* degree );
figure ;
plotSection ( odf , 'phi2 ' ,[0 45 65]* degree , 'contourf ',' colorrange ','
equal ');
mtexColorbar ;
title ([ 'ODF Suave - ' phaseNames {i }]) ;
%% --- 2) Pole Figures ---
h = [ Miller (1 ,0 ,0 , CS ) , Miller (1 ,1 ,0 , CS ) , Miller (1 ,1 ,1 , CS ) ];
pf = calcPoleFigure ( odf , h) ;
figure ;
plot (pf ,'contourf ','MinMax ','off ',' colorrange ','equal ','smooth ');
mtexColorbar ;
title ([ 'Figuras de Polo Suaves - ' phaseNames {i}]) ;
%% --- 3) Inverse Pole Figure ( IPF ) ---
figure ;
plotIPDF ( ori ,[ xvector , yvector , zvector ], 'contourf ',' colorrange ','
equal ');
mtexColorbar ;
title ([ 'IPF - ' phaseNames {i}]) ;
end
