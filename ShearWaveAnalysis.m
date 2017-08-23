%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - This program converts raw shear wave elastography images 
%     from the Aixplorer machine into .mat files
%   - The user can also decide to crop SWV images
%
%   BEFORE RUNNING, SETUP:
%   - Store files using the following naming and organization scheme:
%       - Project folder
%           - "Data" folder
%               -Subject ID
%           - "Analysis" folder
%               -Subject ID
%
%       Example: Data folder     = "C:/Andrew/SWV_Project/Data/SID_001"
%                Analysis folder = "C:/Andrew/SWV_Project/Analysis/SID_001"
%   
%   INPUT: 
%   - dataFolder = folder where the subject's data is stored
%    
%   OUTPUT: 
%   - SWV_NoCalc.mat - file with all raw SWV data
%   - SWV_Calcs.mat  - file with cropped SWV data
%
%   TO EDIT:
%   - Change dataFolder
%
%   VARIABLES:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 

%%%%%%%%%%%%%%%%%%%%%            OPTIONS            %%%%%%%%%%%%%%%%%%%%%%%
dataFolder       = 'C:\Andrew\SWV_Project\Data\SID_001';
% dataFolder = 'C:\Users\Andrew\Lai_SMULab\Projects\SWV_Test\Data\BA\6_30_2015'; % TEST

qualityThreshold = 0.8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check that analysis folder is set up properly
[analysisFolder, folder_exists] = check_AnalysisFolderExists(dataFolder);

% Extract data
if exist([analysisFolder '\NoSWVCalcs.mat'], 'file') % Data already extracted 
    load([analysisFolder '\NoSWVCalcs.mat'])
else
    extract_SWVData
end


%% DO NOT CROP first 

%Do not crop SWV image
ims = crop_SWV(ims, analysisFolder, 2);
applyQThresholdToSWV(qualityThreshold, ims)

% Perform summary calculations & save the data to a .xls file
for i=1:r
    if strcmp(ims{i,2},'region')
        try
            cropswv = isfield(ims{i,6}.Constraints,'croppedSWV');
        catch
            cropswv = 0;
        end
        [smean,smin,smax,ssd,sarea] = calculate_crop(ims(i,:),cropswv);
        ims{i,7} = struct('MeanSWV',smean,...
                          'MinSWV',smin,...
                          'MaxSWV',smax,...
                          'StandardDeviation',ssd,...
                          'Area',sarea);
    end
end
clear('sarea','smax','smean','smin','ssd','i');

save_SWVanalysis(ims, analysisFolder, 'NoCrop')

%% CROP 

ims = crop_SWV(ims, analysisFolder, 1);

applyQThresholdToSWV(qualityThreshold, ims) 

%Perform summary calculations & save the data to a .xls file-----
for i=1:r
    if strcmp(ims{i,2},'region')
        try
            cropswv = isfield(ims{i,6}.Constraints,'croppedSWV');
        catch
            cropswv = 0;
        end
        [smean,smin,smax,ssd,sarea] = calculate_crop(ims(i,:),cropswv);
        ims{i,7} = struct('MeanSWV',smean,...
                          'MinSWV',smin,...
                          'MaxSWV',smax, ...
                          'StandardDeviation',ssd,...
                          'Area',sarea);
    end
end
clear('sarea','smax','smean','smin','ssd','i');
 
save_SWVanalysis(ims, analysisFolder, 'Cropped')
%% Rescale the SWV values

analysisFile = [analysisFolder '\SWVCalcs_NoCrop.mat'];
RescaleSWVValues