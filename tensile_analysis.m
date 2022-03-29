close all;
 
% This file is released open-source under the BSD 3 Clause Licence
% Author: Jack F. Murphy <jack@mrph.dev>

% This requres the Standard Force and Standard Travel to be read in as
% variables StandardForce and StandardTravel, respectively. 
%% User Defined %%%%%%%%%%%%%%%%%%
linearRegion = [0, 0.020];
axes = [0 .2 0 10];
gaugeLength = 5;
area = 5 * .14;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stress = StandardForce / area;
strain = StandardTravel / gaugeLength;

if (linearRegion(1) == 0)
    startLinear = 1;
else
    startLinear = find(strain(1:end-1) < linearRegion(1) & strain(2:end) > linearRegion(1));
end

endLinear = find(strain(1:end-1) < linearRegion(2) & strain(2:end) > linearRegion(2));

pFit = polyfit(strain(startLinear:endLinear), stress(startLinear:endLinear), 1);
yFit = pFit(1)*strain(startLinear:endLinear) + pFit(2);

offsetstrain = strain + .002;
offsetstress = pFit(1)*strain;
offset = [offsetstrain, offsetstress];

figure; hold on;
plot(strain(startLinear:endLinear), stress(startLinear:endLinear));
plot(strain(startLinear:endLinear), yFit)

figure; hold on;
plot(offsetstrain, offsetstress)
plot(strain, stress);
axis(axes);

figure; hold on; 
plot(strain, stress);
plot(offsetstrain, offsetstress);

% Optaining yield stress and strain is dependent on intersection.m
% available at https://mathworks.com/matlabcentral/fileexchange/11837-fast-and-robust-curve-intersections
[yieldStrain,yieldStress] = intersections(strain,stress,offsetstrain,offsetstress,1);
