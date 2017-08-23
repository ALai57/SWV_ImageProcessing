%AL 8.19.2014 - I removed the additional function inputs. 
%AL 9.2.2014  - I changed function outputs to include the masks save 

function [ims, masks_save] = roiSelect(ims)
    [r,~] = size(ims);
    for i=1:r
        if strcmp(ims{i,2},'region')
            image = ims{i,4}.Bmode.Image;
            swv_box = ims{i,4}.Region.Image;
            swv_data = ims{i,6}.Constraints.dataSWV;
            swv_frame = ims{i,4}.Region.Frame;
            bmode_frame = ims{i,4}.Bmode.Frame;
            figure
            imshow(image);

            %DBL 10.9.13 - I edited the roiSelect file so it presents the ROI region from the
            %previous image for minor editing rather than redoing the roi mask over and over.

            %BW 10.31.13 - I added two lines to update the mask of each frame
            if exist('xi','var')
                h = impoly(gca,[xi,yi]);
                position = wait(h);
                xi = position(:,1);
                yi = position(:,2);
                [im_x,im_y]= size(image);
                mask = poly2mask(xi',yi',im_x,im_y);
            else
                [mask,xi,yi] = roipoly(image);
            end
            mask = uint8(mask);

            minx = (ims{i,4}.Region.Frame(1,1))-(ims{i,4}.Bmode.Frame(1,1));
            maxx = (ims{i,4}.Region.Frame(1,2))-(ims{i,4}.Bmode.Frame(1,1));
            miny = (ims{i,4}.Region.Frame(2,1))-(ims{i,4}.Bmode.Frame(2,1));
            maxy = (ims{i,4}.Region.Frame(2,2))-(ims{i,4}.Bmode.Frame(2,1));

            if minx == 0
                minx = 1;
                maxx = maxx+1;
            end
            if maxx == 0
                maxx = 1;
                minx = minx+1;
            end
            if miny == 0
                miny = 1;
                maxy = maxy+1;
            end
            if maxy == 0
                maxy = 1;
                miny = miny+1;
            end

            mask_crop = mask(miny:maxy,minx:maxx);
            mask_resize = double(imresize(mask_crop, [60 59]));

            cropped_swv = swv_data .* mask_resize;
            ims{i,6}.Constraints.croppedSWV = cropped_swv;

            % Save masks for future:
            masks_save(:,:,i) = mask_resize;
            close all

        end
    end
    
    % Save masks file:
%     save('masks_save', 'masks_save');
end

