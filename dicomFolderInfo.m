% Opens a folder and returns a cell array containing the metadata of the
% DICOM files in that folder
% Note: this is a cell array to accomodate the different sized structures


function D = dicomFolderInfo(link)
% Function DICOM_FOLDER_INFO gives information about all Dicom files
% in a certain folder (and subfolders), or of a certain dataset

% Set directory
oldDir = cd(link);

% Get filenames
filelist = dir; % This gives an Nx1 struct where N is the number of elements in the folder
[N,~] = size(filelist);
numDICOM = 0;

D = {};
clear i;
for i=1:N
    filename = filelist(i).name;
    try
        info = dicominfo(filename);
        numDICOM = numDICOM+1;
        D{numDICOM} = info;
    end
end

cd(oldDir)