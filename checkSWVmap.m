function varargout = checkSWVmap(varargin)
% CHECKSWVMAP MATLAB code for checkSWVmap.fig
%      CHECKSWVMAP, by itself, creates a new CHECKSWVMAP or raises the existing
%      singleton*.
%
%      H = CHECKSWVMAP returns the handle to a new CHECKSWVMAP or the handle to
%      the existing singleton*.
%
%      CHECKSWVMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHECKSWVMAP.M with the given input arguments.
%
%      CHECKSWVMAP('Property','Value',...) creates a new CHECKSWVMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before checkSWVmap_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to checkSWVmap_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help checkSWVmap

% Last Modified by GUIDE v2.5 25-Jun-2013 13:52:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @checkSWVmap_OpeningFcn, ...
                   'gui_OutputFcn',  @checkSWVmap_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before checkSWVmap is made visible.
function checkSWVmap_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to checkSWVmap (see VARARGIN)

% Choose default command line output for checkSWVmap
handles.output = hObject;

% Display image number
num = num2str(evalin('base','ims{index,1};'));
set(handles.text14,'String',strcat('Current image #',num));

% Load the current image
S = evalin('base','ims(index,:);');

% If the image does not have a usable shear wave region, alert the user
if ~strcmp(S{2},'region')
    waitfor(noRegion)
end

% Find the current set of constraints
curC = S{6}.current;
constraint = S{6}.Constraints(curC);

% Load the threshold value
handles.th = constraint.threshold;
handles.oldth = constraint.threshold;
set(handles.threshold,'String',num2str(handles.th));

% Load all of the plotting data
handles.sweRangeType1 = S{5}.sweRangeType1;
handles.LUTdata = S{5}.LUTdata;
handles.qualityMap = S{5}.qualityMap;
handles.lateral = S{5}.lateral;
handles.depth = S{5}.depth;
handles.regionWidthmm = S{5}.regionWidthmm;
handles.regionHeightmm = S{5}.regionHeightmm;

% Note: this will display values cut off by PhysicalConstraints as 0.
set(handles.original,'Value',0);
handles.dataSWV = constraint.dataSWV;

% Data map of shear wave velocities
set(handles.figure1,'CurrentAxes',handles.axes2);
imagesc(handles.lateral, handles.depth, handles.dataSWV)
caxis([0 handles.sweRangeType1])
colormap(handles.LUTdata/255)
axis image; colorbar;
xlabel('Lateral (mm)');ylabel('Depth (mm)');
title('SWV region in m/s');

% Data map of SWVs with those values whose qualities are below the
% threshold in white
load_goodSWV(hObject, eventdata, handles)

% The quality map
set(handles.figure1,'CurrentAxes',handles.axes1);
imagesc(handles.lateral, handles.depth, handles.qualityMap)
caxis([0 1])
colormap(handles.LUTdata/255)
axis image; colorbar;
xlabel('Lateral (mm)');ylabel('Depth (mm)');
title('Quality map');

% Display image
set(handles.images,'Value',1.0);
handles.imval = 1;

% Calculate values and display them
[smean,smin,smax,ssd,sarea] = calculateArea(handles.dataSWV,handles.qualityMap,handles.th,handles.regionWidthmm,handles.regionHeightmm);

set(handles.mean,'String',strcat(num2str(smean,3),' m/s'));
set(handles.min,'String',strcat(num2str(smin,3),' m/s'));
set(handles.max,'String',strcat(num2str(smax,3),' m/s'));
set(handles.sd,'String',strcat(num2str(ssd,3),' m/s'));
set(handles.area,'String',strcat(num2str(sarea,4),' mm2'));

handles.sarea = sarea;

% Display B-mode
figure, imshow(S{4}.Bmode.Image);

% Set the image as "unchanged"
handles.changed = false;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes checkSWVmap wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = checkSWVmap_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold as text
%        str2double(get(hObject,'String')) returns contents of threshold as a double

% Store the new threshold value
handles.th = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in preview.
function preview_Callback(hObject, eventdata, handles)
% hObject    handle to preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calculate values and display them
[smean,smin,smax,ssd,sarea] = calculateArea(handles.dataSWV,handles.qualityMap,handles.th,handles.regionWidthmm,handles.regionHeightmm);
set(handles.mean,'String',strcat(num2str(smean,3),' m/s'));
set(handles.min,'String',strcat(num2str(smin,3),' m/s'));
set(handles.max,'String',strcat(num2str(smax,3),' m/s'));
set(handles.sd,'String',strcat(num2str(ssd,3),' m/s'));
set(handles.area,'String',strcat(num2str(sarea,4),' mm2'));

handles.sarea = sarea;

load_goodSWV(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in constrain.
function constrain_Callback(hObject, eventdata, handles)
% hObject    handle to constrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load the GUI displaying options for adding or changing constraints
close
waitfor(ConstraintMenu)



% --- Executes on button press in jump.
function jump_Callback(hObject, eventdata, handles)
% hObject    handle to jump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all
waitfor(jumpTo)


% --- Executes on button press in accept.
function accept_Callback(hObject, eventdata, handles)
% hObject    handle to accept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% First check that there was enough data used in the calculation
athresh = .25 * handles.regionWidthmm * handles.regionHeightmm;
if handles.sarea < athresh
    waitfor(BadArea);
end

% Determine if anything has changed with the constraints of the image
% oldTh = evalin('base','ims{index,6}.Constraints(ims{index,6}.current).threshold;');
% if oldTh ~= handles.th
%     handles.changed = true;
% end
orig = evalin('base','ims{index,5}.dataSWV;');
if orig ~= handles.dataSWV
    handles.changed = true;
end

% If the constraints are different than the current constraint, make a new
% constraint and add it to the end of the structure array
if handles.changed
    assignin('base','thresh',handles.th);
    m = size(evalin('base','ims{index,6}.Constraints'));
    assignin('base','newCur',m+1);
    evalin('base','ims{index,6}.Constraints(newCur).threshold = thresh;');
    evalin('base','ims{index,6}.current = newCur;');
    evalin('base','clear thresh');
    evalin('base','clear newCur');
end

% Close all the figures and move to the next image
close all
evalin('base','index = index + 1;');


% --- Executes on selection change in images.
function images_Callback(hObject, eventdata, handles)
% hObject    handle to images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns images contents as cell array
%        contents{get(hObject,'Value')} returns selected item from images

% contents = cellstr(get(hObject,'String'));

handles.imval = get(hObject,'Value');

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function images_CreateFcn(hObject, eventdata, handles)
% hObject    handle to images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in display.
function display_Callback(hObject, eventdata, handles)
% hObject    handle to display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imtype = handles.imval;
curIm = evalin('base','ims{index,4};');
curQ = evalin('base','ims{index,5};');

switch imtype
    case 1 % Full-size, original
        figure, imshow(curIm.Original);
    case 2 % B-mode
        figure, imshow(curIm.Bmode.Image);
    case 3 % Region, over B-mode
        figure, imshow(curIm.Region.Image);
    case 4 % Region, SWV map
        figure, imagesc(handles.lateral,handles.depth,curQ.dataSWV);
        caxis([0 handles.sweRangeType1])
        colormap(handles.LUTdata/255)
        axis image; colorbar;
    case 5 % Quality map
        figure, imagesc(handles.lateral,handles.depth,handles.qualityMap);
        caxis([0 1])
        colormap(handles.LUTdata/255)
        axis image; colorbar;
end


% --- Executes on button press in original.
function original_Callback(hObject, eventdata, handles)
% hObject    handle to original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of original

% Changes the dataSWV to the original dataSWV that was extracted in
% extractQInfo
if get(hObject, 'Value')
    handles.dataSWV = evalin('base','ims{index,5}.dataSWV;');
    
    handles.th = handles.oldth;
    set(handles.threshold,'String',num2str(handles.th));
else
    constraint = evalin('base','ims{index,6}.Constraints(ims{index,6}.current);');
    handles.dataSWV = constraint.dataSWV;
    
    set(handles.threshold,'String',num2str(handles.th));
end

% Data map of shear wave velocities
set(handles.figure1,'CurrentAxes',handles.axes2);
imagesc(handles.lateral, handles.depth, handles.dataSWV)
caxis([0 handles.sweRangeType1])
colormap(handles.LUTdata/255)
axis image; colorbar;
xlabel('Lateral (mm)');ylabel('Depth (mm)');
title('SWV region in m/s');

% Data map of SWVs with those values whose qualities are below the
% threshold in white
load_goodSWV(hObject, eventdata, handles)


% Other functions

% --- Creates the dataSWV map for values at or above threshold
function load_goodSWV(hObject, eventdata, handles)
% hObject    handle to something
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

th = handles.th;
goodSWV = handles.dataSWV;
% figure('visible','off'), imagesc(handles.lateral,handles.depth,handles.dataSWV);
% frame = getframe();
% goodSWV = frame.cdata;

quality = handles.qualityMap;

% Filter the quality map for good data. Good data is defined as data which
% have SWV values of at least 1 and quality values above or at threshold
[m,n] = size(goodSWV);
for i=1:m
    for j=1:n
        q = quality(i,j);
        
        if q < th || handles.dataSWV(i,j) < 1
            goodSWV(i,j) = 0;
        end
    end
end

% Load the image of the good data
figure('visible','off'), imagesc(handles.lateral,handles.depth,goodSWV), ...
    caxis([0 handles.sweRangeType1]),colormap(handles.LUTdata/255);
frame = getframe();
goodIm = frame.cdata;
close;

% Turn the data white
[m,n,~] = size(goodIm);
for i=1:m
    for j=1:n
        if ((goodIm(i,j,1)) == 0) && ((goodIm(i,j,2)) == 0) && ((goodIm(i,j,3)) < 144)
            goodIm(i,j,1) = 255;
            goodIm(i,j,2) = 255;
            goodIm(i,j,3) = 255;
        end
    end
end

% Display the image
set(handles.figure1,'CurrentAxes',handles.axes3);
imagesc(handles.lateral, handles.depth, goodIm)
caxis([0 handles.sweRangeType1])
colormap(handles.LUTdata/255)
axis image;
xlabel('Lateral (mm)');ylabel('Depth (mm)');
title('SWV Data Analyzed');

% Save the image
assignin('base','gI',goodIm);
evalin('base','ims{index,6}.Image = gI;');
evalin('base','clear gI');


function [smean, smin, smax, ssd, sarea] = calculateArea(dataSWV,qualityMap,threshold,width,height)
% Excluding all values whose quality is below threshold

[m,n] = size(dataSWV);

goodVals = [];

% Filter the data for good data. That is, data points for which SWV values
% are above or equal to 1 and quality values are above threshold
for i=1:m
	for j=1:n
		q = qualityMap(i,j);
		
		if q >= threshold && dataSWV(i,j) >= 1
                goodVals = [goodVals; dataSWV(i,j)];
		end
	end
end

% Calculate mean, min, max, std
smean = mean(goodVals);
smin = min(goodVals);
smax = max(goodVals);
ssd = std(goodVals);

% Calculate the crude area
wholeArea = double(width)*double(height);
[s,~] = size(goodVals);
if s > 0
    factor = double(s)/double(m*n);
    sarea = factor*factor*wholeArea;
else
    sarea = 0;
end
