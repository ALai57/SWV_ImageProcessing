function ims = filterQualityMaps(ims,qualityThreshold)
% Dump any quality maps whose quality is below qualityThreshold.
% This means that ims{i,2} will be changed to 'badregion' and so will not
% be included in the data analysis

[n,~] = size(ims);

for i=1:n
	Q = reshape(ims{i,5}.qualityMap,3540,1);
	meanQ = mean(Q);
	
	if meanQ < qualityThreshold
		ims{i,2} = 'badregion';
	end
end
