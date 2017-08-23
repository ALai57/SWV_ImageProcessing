% Runs DicomQ and removes the information to be used later in the program.
% This includes:
%     depth, vector of horizontal positions (in mm) of each data point wrt
%       the B-mode image
%     lateral, vector of vertical positions (in mm) or each data point wrt
%       the B-mode image
%     dataSWV, the matrix of shear wave velocities
%     qualityMap, the matrix of cross-correlation values, i.e., the matrix
%        of "qualities" for each corresponding data point
%     regionWidthmm, width in mm of the shear wave region
%     regionHeightmm, height in mm of the shear wave region
%     sweRangeType1, the maximum shear wave velocity on the colorbar
%     LUTdata, the colormap data
%
% Also created: a structure of contraints. The two fields are .current, the
% index of the current constraint, and .Constraints, an array of structures
% containing constraint matrices. Fields for each .Constraint(i) include:
%     threshold, the minimum quality value a data point must have to be
%        included in the calculation
%     dataSWV, an adujsted data map with zeros if the data will not be 
%        included in the calculation
%     Image, the image representing the data used in the calculation. The
%        points that are not used are in white
%     regionWidthmm, width of the shear wave region after physical
%        constraints have been placed on the region
%     regionHeightmm, height of the shear wave region after physical
%        constraints have been placed on the region


function [R,S] = extractQInfo(name)

[SQPTHeader SQPTRegionHeader SQPTRegionParameter SQPTRegionData] = DicomQ(name);

% Axis
R.depth   = SQPTRegionHeader.regionTopLeftOrdmm + linspace(0, SQPTRegionHeader.regionHeightmm, SQPTRegionHeader.Samples);
R.lateral = SQPTRegionHeader.regionTopLeftAbsmm + linspace(0, SQPTRegionHeader.regionWidthmm, SQPTRegionHeader.Lines);

% Convert elasticities to velocities. Save data
R.dataSWV = EtoV(SQPTRegionData.dataSWE);
R.qualityMap = SQPTRegionData.qualityMap;
R.regionWidthmm = SQPTRegionHeader.regionWidthmm;
R.regionHeightmm = SQPTRegionHeader.regionHeightmm;

R.sweRangeType1 = EtoV(SQPTRegionParameter.sweRangeType1);
R.LUTdata = SQPTRegionParameter.LUT.data;

% This is the constraints matrix
S = struct('threshold',0,'dataSWV',R.dataSWV,'Image',[],'PhysicalConstraint',0);


function SWV = EtoV(SWE)

[m,n] = size(SWE);
SWV = zeros(m,n);

for i=1:m
    for j=1:n
        SWV(i,j) = sqrt(SWE(i,j)/3);
    end
end