% crystal symmetry ( exemplo : cú bica )
CS = crystalSymmetry ( 'm -3 m', [2.9 2.9 2.9] ,'mineral ','Ferrita ( DRX )','color ' ,[0.56 0.74 0.56]) ;
% specimen symmetry
SS = specimenSymmetry ( 'orthorhombic');
% plotting convention
setMTEXpref ( ' xAxisDirection ','north');
setMTEXpref ( ' zAxisDirection ',' outOfPlane');
%% Specify File Names
% path to files
pname = 'C :\ Users \ marce \ Documents \ PIBITI ';
% quais arquivos de figuras de polo ser ão importados
fname = {...
[ pname '\ C70_111 . xrdml '], ...
[ pname '\ C70_200 . xrdml '], ...
[ pname '\ C70_220 . xrdml ']};
%% Specify Miller Indices
h = { ...
Miller (1 ,1 ,1 , CS ) , ...
Miller (2 ,0 ,0 , CS ) , ...
Miller (2 ,2 ,0 , CS ) };
%% Import the Data
pf = loadPoleFigure ( fname ,h ,CS , SS , 'interface ','xrdml ');
%% --- 1) Pole Figures Experimentais ---
figure ;
plot (pf ,'contourf ',' colorrange ','equal ','smooth ');
mtexColorbar ;
title ('Figuras de Polo Experimentais ( DRX ) ');
%% --- 2) Calcular ODF a partir das PF ---
odf = calcODF (pf , 'silent ');
%% --- 3) Pole Figures Recalculadas ---
figure ;
plotPDF ( odf ,h , 'contourf','colorrange','equal','smooth');
mtexColorbar ;
title ('Figuras de Polo Recalculadas ( DRX )');
%% --- 4) Seções da ODF ---
figure ;
plotSection ( odf , 'phi2 ' ,[0 45 65]* degree , 'contourf ',' colorrange ','
equal ');
mtexColorbar ;
title ('ODF ( DRX )');
%% --- 5) Inverse Pole Figure ( IPF ) ---
figure ;
plotIPDF ( odf ,[ xvector, yvector , zvector ], 'contourf ','colorrange','equal');
mtexColorbar ;
title ('IPF - DRX ');
