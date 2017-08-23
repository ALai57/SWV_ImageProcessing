% Extract the SWV data


cd(dataFolder);

% Open folder
folderInfo = dicomFolderInfo(dataFolder);

% Create structures containing image information
ims = extractImageInfo2(folderInfo);

% Extract the Q-box info
[r,~] = size(ims);
for i=1:r
    if strcmp(ims{i,2},'region')
        extractComplete = 0;
        while ~extractComplete
            i
            try
                try
                    name = strcat(ims{i,3},'.dcm');
                    [R,C] = extractQInfo(name);
                    ims{i,5} = R;
                    ims{i,6}.current = 1;
                    ims{i,6}.Constraints(1) = C;
                catch
                    name = ims{i,3};
                    [R,C] = extractQInfo(name);
                    ims{i,5} = R;
                    ims{i,6}.current = 1;
                    ims{i,6}.Constraints(1) = C;
                end
                extractComplete = 1;
            catch
                pause on;
                pause(10);
            end
        end
    end
end
clear('R','C');

% Save files
save([analysisFolder '\NoSWVCalcs'],'-v7.3');