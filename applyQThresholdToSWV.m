
function applyQThresholdToSWV(thresh, ims)

    % Apply that threshold to all images
    [r,~] = size(ims);
    for i=1:r 
        if strcmp(ims{i,2},'region')
            curIm = ims{i,6}.current;
            ims{i,6}.Constraints(curIm).threshold = thresh;
        end
    end
    clear('thresh','curIm');

    % Give option to open processing GUI
%     auto = menu('Would you like to open the processing gui?','Yes','No, use default threshold for all images');
    auto = 0;
    if auto==1
        index = 1;
        while index < r+1
            if strcmp(ims{index,2},'region')
                waitfor(checkSWVmap);
            end
            index = index + 1;
        end
    end
end