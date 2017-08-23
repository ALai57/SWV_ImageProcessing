% Calculate the mean, minimum, and maximum shear wave velocities, the
% standard deviation of the shear wave velocities in the region selected,
% and a crude area of the usable data points. The crude area is calculated
% by multiplying the total area by the number of points used divided by the
% total number of data points in the matrix.


function [smean, smin, smax, ssd, sarea] = calculate(C)
% Excluding all values whose quality is below threshold
% C is the cell array

% Load the quality map, the current set of usable data, and the current
% threshold. Data will be listed as 0 if they are taken out by constraints
% other than threshold. If a SWV has a value above 1 and a quality value
% above threshold, then it will be included in the calculation.
qualityMap = C{5}.qualityMap;
cur = C{6}.current;
dataSWV = C{6}.Constraints(cur).dataSWV;
threshold = C{6}.Constraints(cur).threshold;

[m,n] = size(dataSWV);

goodVals = [];

for i=1:m
	for j=1:n
		q = qualityMap(i,j);
		
        % Create a matrix of the data to be used in the calculation
		if q >= threshold && dataSWV(i,j) >= 1
                goodVals = [goodVals; dataSWV(i,j)];
		end
	end
end

smean = mean(goodVals);
smin = min(goodVals);
smax = max(goodVals);
ssd = std(goodVals);

% Calculate the crude area
w = C{5}.regionWidthmm;
h = C{5}.regionHeightmm;
wholeArea = double(w)*double(h);
[s,~] = size(goodVals);
if s > 0
    factor = double(s)/double(m*n);
    sarea = factor*factor*wholeArea;
else
    sarea = 0;
end