
%AL 9.2.2014 - I added the ability to save the masks_save file
%               in the analysisFolder

function ims = crop_SWV(ims, analysisFolder, cropq)

    if isempty(cropq)
        %Check for existing mask file
        if exist([analysisFolder '\masks_save.mat'],'file');
            cropq = menu('Would you like to select a ROI to analyze?','Yes','No, use entire SWV box','Load old mask files');
        else
            cropq = menu('Would you like to select a ROI to analyze?','Yes','No, use entire SWV box');
        end
    end

    
    if cropq == 1
        [ims, masks_save] = roiSelect(ims);
        try
            save([analysisFolder '\masks_save1'], 'masks_save')
        end
    elseif cropq == 3
        %Load masks that have been previously selected using roiSelect
        load([analysisFolder '\masks_save'])

        [r,~] = size(ims); 
        for i=1:r
            if strcmp(ims{i,2},'region')
                swv_data = ims{i,6}.Constraints.dataSWV;
                mask_resize = masks_save(:,:,i);
                cropped_swv = swv_data .* mask_resize;
                ims{i,6}.Constraints.croppedSWV = cropped_swv;
                clear('swv_data','mask_resize','cropped_swv')
            end
        end
    end
    
end