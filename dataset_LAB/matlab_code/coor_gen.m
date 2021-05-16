inTable=readtable('coordinate.txt','Delimiter','_');% import the coordinates of all grids
a=table2array(inTable);
posGrid=a(:,2:3);
widthGrid=a(:,4);
heightGrid=a(:,5);
save('coordinates','posGrid','widthGrid','heightGrid');
