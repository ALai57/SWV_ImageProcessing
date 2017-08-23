% Draws two axes on the dataSWV map image and allows a user to choose a
% quadrant to include in the calculations


function varargout = PhysicalConstraints(varargin)
% PHYSICALCONSTRAINTS MATLAB code for PhysicalConstraints.fig
%      PHYSICALCONSTRAINTS, by itself, creates a new PHYSICALCONSTRAINTS or raises the existing
%      singleton*.
%
%      H = PHYSICALCONSTRAINTS returns the handle to a new PHYSICALCONSTRAINTS or the handle to
%      the existing singleton*.
%
%      PHYSICALCONSTRAINTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHYSICALCONSTRAINTS.M with the given input arguments.
%
%      PHYSICALCONSTRAINTS('Property','Value',...) creates a new PHYSICALCONSTRAINTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PhysicalConstraints_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PhysicalConstraints_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PhysicalConstraints

% Last Modified by GUIDE v2.5 25-Jun-2013 13:31:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PhysicalConstraints_OpeningFcn, ...
                   'gui_OutputFcn',  @PhysicalConstraints_OutputFcn, ...
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


% --- Executes just before PhysicalConstraints is made visible.
function PhysicalConstraints_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PhysicalConstraints (see VARARGIN)

% Choose default command line output for PhysicalConstraints
handles.output = hObject;

% Set current constraint
handles.constraint = evalin('base','ims{index,6}.Constraints(ims{index,6}.current)');

% Determine slider sizes
handles.lsize = max(size(handles.constraint.lateral));
handles.dsize = max(size(handles.constraint.depth));

% Set default constraints
set(handles.original,'Value',1);
set(handles.depth,'Value',0);
handles.haxis = 0;
handles.hval = 1;
set(handles.lateral,'Value',0);
handles.vaxis = 0;
handles.vval = 1;

% By default, use quadrant 1
set(handles.one,'Value',1);
set(handles.two,'Value',0);
set(handles.three,'Value',0);
set(handles.four,'Value',0);
handles.quad = 1;

% Load image
S = evalin('base','ims{index,5}');
handles.lateral = handles.constraint.lateral;
handles.depth = handles.constraint.depth;
handles.dataSWV = handles.constraint.dataSWV;
handles.sweRangeType1 = S.sweRangeType1;
handles.LUTdata = S.LUTdata;

% Display image
set(handles.figure1,'CurrentAxes',handles.axes1);
imagesc(handles.lateral, handles.depth, handles.dataSWV)
caxis([0 handles.sweRangeType1])
colormap(handles.LUTdata/255)
axis image; colorbar;

% Image of quadrants
quadimage = imread('iiiiiiiv.jpg');
set(handles.figure1,'CurrentAxes',handles.axes2);
imshow(quadimage)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PhysicalConstraints wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PhysicalConstraints_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function depth_Callback(hObject, eventdata, handles)
% hObject    handle to depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.haxis = get(hObject,'Value');

% Load horizontal and vertical values
handles.hval = uint32((1-handles.haxis)*double(handles.dsize));
handles.vval = uint32((handles.vaxis)*double(handles.lsize));

% Load image
set(handles.figure1,'CurrentAxes',handles.axes1);
imagesc(handles.lateral, handles.depth, handles.dataSWV)
caxis([0 handles.sweRangeType1])
colormap(handles.LUTdata/255)
axis image; colorbar;

% Draw horizontal and vertical lines
hold on
plot(handles.lateral(1):0.01:handles.lateral(end),handles.depth(handles.hval),'Color',[0 0 0]);
plot(handles.lateral(handles.vval),handles.depth(1):0.01:handles.depth(end),'Color',[0 0 0]);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function depth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function lateral_Callback(hObject, eventdata, handles)
% hObject    handle to lateral (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.vaxis = get(hObject,'Value');

% Load horizontal and vertical values
handles.hval = uint32((1-handles.haxis)*double(handles.dsize));
handles.vval = uint32((handles.vaxis)*double(handles.lsize));

% Load image
set(handles.figure1,'CurrentAxes',handles.axes1);
imagesc(handles.lateral, handles.depth, handles.dataSWV)
caxis([0 handles.sweRangeType1])
colormap(handles.LUTdata/255)
axis image; colorbar;

% Draw horizontal and vertical lines
hold on
plot(handles.lateral(1):0.01:handles.lateral(end),handles.depth(handles.hval),'Color',[0 0 0]);
plot(handles.lateral(handles.vval),handles.depth(1):0.01:handles.depth(end),'Color',[0 0 0]);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lateral_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lateral (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in images.
function images_Callback(hObject, eventdata, handles)
% hObject    handle to images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns images contents as cell array
%        contents{get(hObject,'Value')} returns selected item from images

% Store the quadrant
handles.imval = get(hObject,'Value');

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function images_CreateFcn(hObject, eventdata, handles)
% hObject    handle to images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in accept.
function accept_Callback(hObject, eventdata, handles)
% hObject    handle to accept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Find the quadrant
if get(handles.one,'Value')
    handles.quad = 1;
elseif get(handles.two,'Value')
    handles.quad = 2;
elseif get(handles.three,'Value')
    handles.quad = 3;
elseif get(handles.four,'Value')
    handles.quad = 4;
end

quadrant = handles.quad;
newConstraint = handles.constraint;

% Set all values outside of the indicated quadrant to zero. The commented
% lines of code will change regionWidthmm and regionHeight in the
% Constraints structure, which I'm deemed unnecessary.
switch quadrant
    case 1
        newConstraint.dataSWV(handles.hval:end,:) = 0;
        newConstraint.dataSWV(1:handles.hval,1:handles.vval) = 0;
        
%         depth_pc = max(size(handles.depth(1:handles.hval)));
%         lateral_pc = max(size(handles.lateral(handles.vval:end)));
    case 2
        newConstraint.dataSWV(handles.hval:end,:) = 0;
        newConstraint.dataSWV(1:handles.hval,handles.vval:end) = 0;
        
%         depth_pc = max(size(handles.depth(1:handles.hval)));
%         lateral_pc = max(size(handles.lateral(1:handles.vval)));
    case 3
        newConstraint.dataSWV(1:handles.hval,:) = 0;
        newConstraint.dataSWV(handles.hval:end,handles.vval:end) = 0;
        
%         depth_pc = max(size(handles.depth(handles.hval:end)));
%         lateral_pc = max(size(handles.lateral(1:handles.vval)));
    case 4
        newConstraint.dataSWV(1:handles.hval,:) = 0;
        newConstraint.dataSWV(handles.hval:end,1:handles.vval) = 0;
        
%         depth_pc = max(size(handles.depth(handles.hval:end)));
%         lateral_pc = max(size(handles.lateral(handles.vval:end)));
    otherwise
        newConstraint.dataSWV = handles.dataSWV;
        
%         depth_pc = max(size(handles.depth));
%         lateral_pc = max(size(handles.lateral));
end

% dfactor = depth_pc/max(size(handles.depth));
% lfactor = lateral_pc/max(size(handles.lateral));

% newConstraint.regionWidthmm = newContraint.regionWidthmm*dfactor;
% newConstraint.regionHeightmm = newContraint.regionHeightmm*lfactor;

% Set the new constraint in the base workspace
newConstraint.PhysicalConstraint = 1;
assignin('base','newConstraint',newConstraint);

evalin('base','ims{index,6}.current = max(size(ims{index,6}.Constraints)) + 1;');
evalin('base','ims{index,6}.Constraints(ims{index,6}.current) = newConstraint');
evalin('base','clear newConstraint');

close


% --- Executes on button press in display.
function display_Callback(hObject, eventdata, handles)
% hObject    handle to display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imtype = handles.imval;
curI = evalin('base','ims{index,4}');

switch imtype
    case 1 % Full-size, original
        figure, imshow(curI.Original);
    case 2 % B-mode
        figure, imshow(curI.Bmode.Image);
    case 3 % Region, over B-mode
        figure, imshow(curI.Region.Image);
    case 4 % Region, SWV map
        figure, imagesc(handles.lateral,handles.depth,handles.dataSWV);
    case 5 % Quality map
        figure, imagesc(handles.lateral,handles.depth,handles.qualityMap);
end


% --- Executes on button press in original.
function original_Callback(hObject, eventdata, handles)
% hObject    handle to original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of original

% Switch between the original dataSWV and the one used in the current
% constraint
S = evalin('base','ims{index,5};');
if get(hObject,'Value')
    const = evalin('base','ims{index,5};');
else
    const = evalin('base','ims{index,6}.Constraints(ims{index,6}.current)');
end

handles.dataSWV = const.dataSWV;
handles.lateral = S.lateral;
handles.depth = S.depth;
handles.lsize = max(size(S.lateral));
handles.dsize = max(size(S.depth));

% Reload image
set(handles.figure1,'CurrentAxes',handles.axes1);
imagesc(handles.lateral, handles.depth, handles.dataSWV)
caxis([0 handles.sweRangeType1])
colormap(handles.LUTdata/255)
axis image; colorbar;

hold on
plot(handles.lateral(1):0.01:handles.lateral(end),handles.depth(handles.hval),'Color',[0 0 0]);
plot(handles.lateral(handles.vval),handles.depth(1):0.01:handles.depth(end),'Color',[0 0 0]);
