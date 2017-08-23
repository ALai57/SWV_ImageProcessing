
%AL 8.19.2014 - I edited the saving method so that the EXCEL header works.

function save_SWVanalysis(ims, analysisFolder, saveName)

    % Columns: Image number, mean, min, max, sd, crude area
    Name = 'ShearWaveVelocities';
    M = [];
    [r,~] = size(ims);
    index = [];
    for i=1:r
        if strcmp(ims{i,2},'region')
            imnum = ims{i,1};
            calcs = ims{i,7};
            smean = calcs.MeanSWV;
            smin = calcs.MinSWV;
            smax = calcs.MaxSWV;
            ssd = calcs.StandardDeviation;
            sarea = calcs.Area;

            
            try
                M = [M; imnum smean smin smax ssd sarea];
            catch
                M = [M; 0 0 0 0 0 0];
            end
            index(end+1) = i;
        end
    end

    %SL-10.30.13 - I changed the save format to csvwrite as xlswrite is not
    %compatible with MAC.

    clear('i','calcs','imnum','smean','smin','smax','ssd','sarea');
    header = {'Image #', 'Mean SWV', 'Min SWV', 'Max SWV', 'StDev SWV', 'SWV Area', 'File Name', 'Img location'};

    version = 0;
    newName = [analysisFolder '\' Name '_' saveName, '.csv'];
    % newName = strcat(Name,date,strrep(num2str(threshold),'.','pt'))) % Global threshold
    while exist(newName, 'file')
        version = version + 1;
        newName = strcat(analysisFolder, '\', Name,num2str(version), '.csv');
    end

    fid = fopen(newName, 'w');
    fprintf(fid, '%s,', header{1:end-1});
    fprintf(fid, '%s\n', header{end});
    for n=1:size(M,1)
        fprintf(fid, '%f,', M(n,:));
        fprintf(fid, '%s', ims{index(n),3});
        
        if strfind(ims{index(n),3}, 'DistalCF_Lateral')
            fprintf(fid, ',%s\n', 'DistalCF_Lateral');
        elseif strfind(ims{index(n),3},'Prox30_MedialAngle')
             fprintf(fid, ',%s\n', 'Prox30_MedialAngle');  
        elseif strfind(ims{index(n),3},'Prox30_LateralAngle')
             fprintf(fid, ',%s\n', 'Prox30_LateralAngle');
        elseif strfind(ims{index(n),3},'Prox30_Lateral')
             fprintf(fid, ',%s\n', 'Prox30_Lateral');
        elseif strfind(ims{index(n),3},'Mid30_Lateral')
             fprintf(fid, ',%s\n', 'Mid30_Lateral');
        elseif strfind(ims{index(n),3},'Prox30_Distal_Lateral')
             fprintf(fid, ',%s\n', 'Prox30_Distal_Lateral');
        elseif strfind(ims{index(n),3},'Prox30_Proximal_Lateral')
             fprintf(fid, ',%s\n', 'Prox30_Proximal_Lateral');
        elseif strfind(ims{index(n),3},'Mid30_Proximal_Lateral')
             fprintf(fid, ',%s\n', 'Mid30_Proximal_Lateral');
        elseif strfind(ims{index(n),3},'Prox30_Distal')
             fprintf(fid, ',%s\n', 'Prox30_Distal');
        elseif strfind(ims{index(n),3},'Prox30_Proximal')
             fprintf(fid, ',%s\n', 'Prox30_Proximal');
        elseif strfind(ims{index(n),3},'Mid30_Proximal')
             fprintf(fid, ',%s\n', 'Mid30_Proximal');           
        elseif strfind(ims{index(n),3},'DistalCF')
             fprintf(fid, ',%s\n', 'DistalCF');
        elseif strfind(ims{index(n),3},'Prox30')
             fprintf(fid, ',%s\n', 'Prox30');
        elseif strfind(ims{index(n),3},'Mid30')
             fprintf(fid, ',%s\n', 'Mid30');   
        elseif strfind(ims{index(n),3},'Mid_Lateral')
             fprintf(fid, ',%s\n', 'Mid_Lateral');   
        elseif strfind(ims{index(n),3},'Mid_Medial')
             fprintf(fid, ',%s\n', 'Mid_Medial');   
        elseif strfind(ims{index(n),3},'Mid_Neutral')
             fprintf(fid, ',%s\n', 'Mid_Neutral');   
        elseif strfind(ims{index(n),3},'MidComposite')
             fprintf(fid, ',%s\n', 'Mid_Composite');   
        elseif strfind(ims{index(n),3},'Mid_Composite2')
             fprintf(fid, ',%s\n', 'Mid_Composite2'); 
        else
             fprintf(fid, '\n');
        end
        
    end
    fclose(fid);

    save([analysisFolder '\SWVCalcs_' saveName],'-v7.3');
    clear('name','Name','newName','version')
    
end

% 
% fid = fopen(newName, 'w');
%     fprintf(fid, '%s,', header{1:end-1});
%     fprintf(fid, '%s\n', header{end});
%     fclose(fid);
%     dlmwrite(newName,M,'-append'); 