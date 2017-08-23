% Matlab function to read dicom file and extract private embedded tag
% 
% [SQPTHeader SQPTRegionHeader SQPTRegionParameter SQPTRegionData] = extractDicomEmbeddedData(dicomFileIn)
% 
% contact thomas.frappart@supersonicimagine.com for assistance
%
%  Copyright (c) 2012 by SuperSonic Imagine
%  Confidential - All Right Reserved
%
% This function uses the dcmtk tool 'dcmdump' (see http://dicom.offis.de)
% For linux: install dcmtk with your package manager (apt-get/yum...)
% For windows: get the executable binaries at
% http://dicom.offis.de/dcmtk.php.en and add the path_to_dcmtkdcmtk/bin
% folder to your the path windows environment variable


function [SQPTHeader SQPTRegionHeader SQPTRegionParameter SQPTRegionData] = DicomQ(dicomFileIn)
% Private tag data
tag_SSI_Q_PRIVATE_CREATOR = '8ff1,0013';
val_SSI_Q_PRIVATE_CREATOR = 'SSI Rich Quantification Group';
tag_SSI_Q_BLOB            = '8ff1,1301';

SQPTHeader          = struct;
SQPTRegionHeader    = struct;
SQPTRegionParameter = struct;
SQPTRegionData      = struct;
%% Check private tag SSI Q Private Creator
unix_command = ['dcmdump +L +P ' tag_SSI_Q_PRIVATE_CREATOR ' "' dicomFileIn '" > dcmDataDump']; % OLD COMMAND
% unix_command = ['dcmdump +L "' dicomFileIn '" > dcmDataDump'];
status = system(unix_command);

if(~status)
    fic = fopen('dcmDataDump','r');
    dataDump = fread(fic,inf,'char=>char')';
    fclose(fic);
    if(strcmpi(dataDump,''))
        error('Private SSI Tag not found');
    elseif(strfind(dataDump,val_SSI_Q_PRIVATE_CREATOR) ~= 17)
        error('Private Tag is not from Supersonic Imagine');
    end
end


%% Extract embedded data
unix_command = ['dcmdump +L +P ' tag_SSI_Q_BLOB ' "' dicomFileIn '" > dcmDataDump'];
status = system(unix_command);

if(~status)
    fic = fopen('dcmDataDump','r');
    fseek(fic, 15, 'bof');
    % Read SQPTHeader
    SQPTHeader.formatRev  = int32parse(fread(fic,12,'char=>char')');                        % file version number
    SQPTHeader.size = uint32parse(fread(fic,12,'char=>char')');                             % sizeof this structure in bytes
    SQPTHeader.nRegions   = int32parse(fread(fic,12,'char=>char')');                        % number of SQPTRegionHeaders and SQPTRegionData structs in this file
    SQPTHeader.fullScreenWidth  = int32parse(fread(fic,12,'char=>char')');                  % width of the original full screen image
    SQPTHeader.fullScreenHeight = int32parse(fread(fic,12,'char=>char')');                  % height of the original full screen image
    
    if(SQPTHeader.nRegions>0)
        % Read SQPTRegionHeader
        SQPTRegionHeader.size = uint32parse(fread(fic,12,'char=>char')');                    % sizeof this structure in bytes
        SQPTRegionHeader.regionTopLeftAbsPxl = int32parse(fread(fic,12,'char=>char')');     % screen display region location in pixels (origin is upper-left corner)
        SQPTRegionHeader.regionTopLeftOrdPxl = int32parse(fread(fic,12,'char=>char')');     % screen display region location in pixels (origin is upper-left corner)
        SQPTRegionHeader.regionWidthPxl = int32parse(fread(fic,12,'char=>char')');          % screen display region location in pixels (origin is upper-left corner)
        SQPTRegionHeader.regionHeightPxl = int32parse(fread(fic,12,'char=>char')');         % screen display region location in pixels (origin is upper-left corner)
        
        SQPTRegionHeader.regionDataType = int32parse(fread(fic,12,'char=>char')');          % description of raw data
        SQPTRegionHeader.Samples = int32parse(fread(fic,12,'char=>char')');                 % description of raw data
        SQPTRegionHeader.Lines = int32parse(fread(fic,12,'char=>char')');                   % description of raw data
        
        SQPTRegionHeader.regionTopLeftAbsmm = floatparse(fread(fic,12,'char=>char')');      % real world dimensions of raw data (origin is upper-left corner)
        SQPTRegionHeader.regionTopLeftOrdmm = floatparse(fread(fic,12,'char=>char')');      % real world dimensions of raw data (origin is upper-left corner)
        SQPTRegionHeader.regionWidthmm = floatparse(fread(fic,12,'char=>char')');           % real world dimensions of raw data (origin is upper-left corner)
        SQPTRegionHeader.regionHeightmm = floatparse(fread(fic,12,'char=>char')');          % real world dimensions of raw data (origin is upper-left corner)

        % Read SQPTRegionParameter
        SQPTRegionParameter.size = uint32parse(fread(fic,12,'char=>char')');                % sizeof this structure in bytes
        SQPTRegionParameter.displayUnit = int32parse(fread(fic,12,'char=>char')');          % display unit m/s = 0 or kPa = 1 for SWE elasticity range
        SQPTRegionParameter.HDFrameRate = int32parse(fread(fic,12,'char=>char')');          % SAR HD/Fr.Rate
        SQPTRegionParameter.smoothing = int32parse(fread(fic,12,'char=>char')');            % SAR Smoothing aka median filter
        SQPTRegionParameter.persistence = int32parse(fread(fic,12,'char=>char')');          % SAR Persistence
        SQPTRegionParameter.sweMap = int32parse(fread(fic,12,'char=>char')');               % SAR SWE Map aka index in LUT 
        SQPTRegionParameter.gain = int32parse(fread(fic,12,'char=>char')');                 % SAR Gain
        SQPTRegionParameter.threeDFilter = int32parse(fread(fic,12,'char=>char')');         % SAR 3D Filter aka SWE adaptive filter
        SQPTRegionParameter.thickslabRender = int32parse(fread(fic,12,'char=>char')');      % SAR thickslab render
        
        SQPTRegionParameter.thickness = floatparse(fread(fic,12,'char=>char')');            % SAR thickness
        SQPTRegionParameter.opacity = floatparse(fread(fic,12,'char=>char')');              % SAR Opacity aka transparency
        SQPTRegionParameter.sweRangeType0 = floatparse(fread(fic,12,'char=>char')');        % elasticity range in m/s
        SQPTRegionParameter.sweRangeType1 = floatparse(fread(fic,12,'char=>char')');        % elasticity range in kPa
        SQPTRegionParameter.apiMI = floatparse(fread(fic,12,'char=>char')');                % header MI
        SQPTRegionParameter.apiTIB = floatparse(fread(fic,12,'char=>char')');               % header TI
        SQPTRegionParameter.apiTIS = floatparse(fread(fic,12,'char=>char')');               % header TI
        if(SQPTHeader.formatRev==6)
            SQPTRegionParameter.apiTIC = floatparse(fread(fic,12,'char=>char')');           % header TI ! only diff between rev5 and rev6 
        end
        SQPTRegionParameter.LUT.id = uint32parse(fread(fic,12,'char=>char')');              % internal identifier of the map, ie cepia, linear, rainbow...
        for k=1:3*256
            LUT(k) = uint8parse(fread(fic,3,'char=>char')');                                % RGB LUT
        end
        SQPTRegionParameter.LUT.data = [LUT(1:3:end)' LUT(2:3:end)' LUT(3:3:end)'];         % Reshaping LUT for MATLAB use [R G B]
        
        % Read SQPTRegionData
        SQPTRegionData.size = int32parse(fread(fic,12,'char=>char')');                      % sizeof this structure in bytes
        sizeCharData =  SQPTRegionData.size*3 - 12;
        data = zeros(1,sizeCharData/12);
%         buffer = fread(fic,sizeCharData,'char=>char');
%         for k = 1:sizeCharData/12
%             shift = (k-1)*12;
%             binval = dec2bin( hex2dec(buffer(1+shift:2+shift))*256^0 + hex2dec(buffer(shift + 4+shift:5+shift))*256^1 +  hex2dec(buffer(7+shift:8+shift))*256^2 +  hex2dec(buffer(10+shift:11+shift))*256^3 );
%             data(k) = typecast( uint32( bin2dec(binval) ), 'single');
%         end
        for k=1:sizeCharData/12
            data(k) = floatparse(fread(fic,12,'char=>char')');                              % read data
        end

        SQPTRegionData.dataSWE = reshape(data(1:SQPTRegionHeader.Samples*SQPTRegionHeader.Lines), SQPTRegionHeader.Samples, SQPTRegionHeader.Lines);
        SQPTRegionData.qualityMap = reshape(data(SQPTRegionHeader.Samples*SQPTRegionHeader.Lines+1:end), SQPTRegionHeader.Samples, SQPTRegionHeader.Lines);
    
    end
    fclose(fic);
end

function intval = uint32parse(charval)
    if length(charval)==12
        intval = hex2dec(charval(1:2))*256^0 + hex2dec(charval(4:5))*256^1 +  hex2dec(charval(7:8))*256^2 +  hex2dec(charval(10:11))*256^3;
    else
        intval = -1;
    end
    
function intval = uint8parse(charval)
    if length(charval)==3
        intval = hex2dec(charval(1:2));
    else
        intval = -1;
    end
    
function intval = int32parse(charval)
    if length(charval)==12
        binval = dec2bin( hex2dec(charval(1:2))*256^0 + hex2dec(charval(4:5))*256^1 +  hex2dec(charval(7:8))*256^2 +  hex2dec(charval(10:11))*256^3 );
        intval = typecast( uint32( bin2dec(binval) ), 'int32');
    else
        intval = -1;
    end

function floatval = floatparse(charval)
    if length(charval) == 12
        binval = dec2bin( hex2dec(charval(1:2))*256^0 + hex2dec(charval(4:5))*256^1 +  hex2dec(charval(7:8))*256^2 +  hex2dec(charval(10:11))*256^3 );
        floatval = typecast( uint32( bin2dec(binval) ), 'single');
    else
        floatval = -1;
    end