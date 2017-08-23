% Save images to a folder in the same directory as the DICOM directory. The
% types of images that can be saved are listed below. For image type 4, it
% is the original dataSWV map


function saveImagesTo(M,type,folder)
% M is the cell array
% type is an int 1-5 corresponding to an image type:
%     1: Full-size, original
%     2: B-mode
%     3: Region, over B-mode
%     4: Region, SWV map
%     5: Quality map
% Note: types 3-5 are only available for R

% Create the tag for the end of the image filename. You can maybe skip the
% step of adding the tags since the images will be contained in a folder
% specifying the image type
switch type
    case 1
        field = 'Original';
    case 2
        field = 'Bmode';
    case 3
        field = 'RegionImage';
    case 4
        field = 'dataSWV';
    case 5
        field = 'qualityMap';
end

[m,~] = size(M);
oldDir = cd(folder);
mkdir(field);

for i=1:m
    imtype = M{i,2};
    name = strrep(M{i,3},folder,'');
    path = strcat(field,name);
    switch imtype
        case 'region' % Can save any one of the five options
            switch type
                case 1
                    saveo(M{i,4},path);
                case 2
                    saveb(M{i,4},path);
                case 3
                    saveregion(M{i,4},path);
                case 4
                    savedataSWV(M{i,5},path);
                case 5
                    savequalityMap(M{i,5},path);
            end
        case 'badregion' % Can save any of the five options
            switch type
                case 1
                    saveo(M{i,4},name);
                case 2
                    saveb(M{i,4},name);
                case 3
                    saveregion(M{i,4},name);
                case 4
                    savedataSWV(M{i,5},name);
                case 5
                    savequalityMap(M{i,5},name);
            end
        case 'noregion' % Can save original or bmode
            switch type
                case 1
                    saveo(M{i,4},path);
                case 2
                    saveb(M{i,4},path);
                otherwise
                    disp Sorry
            end
        case 'panoramic' % As of now, only one option
            imwrite(M{i,4}.Image,strcat(path,'_pan.jpg'),'jpg');
        case 'movie' % I'm not sure how you'd want to save the movie
            % Do something
    end
end            
            
cd(oldDir);

% Save the original, full-sized image
function saveo(S,name)
imwrite(S.Original,strcat(name,'_Original.jpg'),'jpg');

% Save the B-mode image
function saveb(S,name)
imwrite(S.Bmode.Image,strcat(name,'_Bmode.jpg'),'jpg');

% Save the shear wave region over the B-mode image
function saveregion(S,name)
imwrite(S.Region.Image,strcat(name,'_Region.jpg'),'jpg');

% Save the shear wave data color map
function savedataSWV(S,name)
figure('visible','off'), imagesc(S.lateral,S.depth,S.dataSWV), ...
    caxis([0 S.sweRangeType1]),colormap(S.LUTdata/255),axis image;
frame = getframe();
imwrite(frame.cdata,strcat(name,'_data.jpg'),'jpg');
close

% Save the quality color map
function savequalityMap(S,name)
figure('visible','off'), imagesc(S.lateral,S.depth,S.qualityMap), ...
    caxis([0 1]),colormap(S.LUTdata/255),axis image;
frame = getframe();
imwrite(frame.cdata,strcat(name,'_qualityMap.jpg'),'jpg');
close

