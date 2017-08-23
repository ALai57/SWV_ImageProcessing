

function [analysisFolder, folder_exists] = check_AnalysisFolderExists(dataFolder)
    analysisFolder = strrep(dataFolder, '\Data\', '\Analysis\');
    if ~exist(analysisFolder, 'dir') 
        folder_exists = 0;
        button = questdlg({'Directory does not exist.',...
                           'Create new analysis directory?'},...
                             'Analysis folder does not exist',...
                                'Yes',...
                                'No',...
                                'Yes'); 
        if strcmp(button, 'Yes')
            mkdir(analysisFolder)
        else
            return;
        end
    end
    folder_exists = 1;
end