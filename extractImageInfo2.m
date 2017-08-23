
% Uses the metadata from dicomFolderInfo to create a cell array of size Nx4
%
% The first column contains the image number, the second is the type of
% image (one of 'movie','panoramic','noregion', or 'region'. 'badregion'
% will be added later in the program if needed), the third is the filename,
% and the fourth is a structure containing the image information. For each
% file type, fields include
%         'movie': Movie, NumberOfFrames, FrameIncrementPointer, Frame,
%                  MovieNoBorder
%         'panoramic': the image (currently not in structure form. This can
%                      be changed)
%         'noregion': Original (image), Bmode.Frame, Bmode.Image
%         'region': Original, Bmode.Frame, Bmode.Image, Region.Frame,
%                   Region.Image


function C = extractImageInfo2(D)
% Extracts the important info from the files listed in the struct D
%
% INPUT: D, an 1xN struct, N is the number of DICOM metadata files in D

% First obtain size of D
N = max(size(D));
C = {};

% Fill the structures
for i=1:N
    info = D{i};
    C{i,1} = info.AcquisitionNumber;
    
    if isfield(info,'NumberOfFrames')
        C{i,2} = 'movie';
        C{i,3} = strrep(info.Filename,'.dcm','');
        
        S.Movie = dicomread(info); % mxnx4 matrix, where m is the height and n is the width
        S.FrameIncrementPointer = info.FrameIncrementPointer;
        S.Frame = findFrame(info,'b');
        S.MovieNoBorder = makeImage(S.Frame,S.Movie);
        C{i,4} = S;
    else
        infoS = info.SequenceOfUltrasoundRegions;
        if ~isfield(infoS,'Item_1')
            C{i,2} = 'panoramic';
            C{i,3} = strrep(info.Filename,'.dcm','');
            C{i,4} = dicomread(info); % The panoramic image
            % Other stuffs
        elseif ~isfield(infoS,'Item_2')
            C{i,2} = 'noregion';
            C{i,3} = strrep(info.Filename,'.dcm','');
            
            IS.Original = dicomread(info);
            IS.Bmode.Frame = findFrame(info,'b');
            IS.Bmode.Image = makeImage(IS.Bmode.Frame,IS.Original);
            
            C{i,4} = IS;
        elseif isfield(infoS,'Item_2')
            C{i,2} = 'region';
            C{i,3} = strrep(info.Filename,'.dcm','');
            
            IS.Original = dicomread(info);
            IS.Bmode.Frame = findFrame(info,'b');
            IS.Bmode.Image = makeImage(IS.Bmode.Frame,IS.Original);
            IS.Region.Frame = findFrame(info,'r');
            IS.Region.Image = makeImage(IS.Region.Frame,IS.Original);
            
            C{i,4} = IS;
        end
    end
end



function newImage = makeImage(frame,image)
% Makes a subimage given the [xmin xmax; ymin ymax] of the desired subimage
% with respect to the original image
xmin = frame(1,1);
xmax = frame(1,2);
ymin = frame(2,1);
ymax = frame(2,2);

newImage = image(ymin:ymax,xmin:xmax,:);

function frame = findFrame(info,im)
% info is the DICOM info
% im is either 'b' or 'r' depending on if you want the B-mode frame or the region frame

if strcmp(im,'b')
	I = info.SequenceOfUltrasoundRegions.Item_1;
elseif strcmp(im,'r')
	I = info.SequenceOfUltrasoundRegions.Item_2;
end

xmin=I.RegionLocationMinX0;
xmax=I.RegionLocationMaxX1;
ymin=I.RegionLocationMinY0;
ymax=I.RegionLocationMaxY1;

frame = [xmin xmax; ymin ymax];