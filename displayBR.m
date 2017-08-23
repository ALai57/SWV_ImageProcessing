% Menu of images to display for an image of type 'badregion'. From here,
% the user can choose to include the image in the overall analysis of the
% folder
%
% Right now, dataSWV displays the original dataSWV map without any
% constraints. If that option is included in the future, there should be an
% option to choose which constraint to display (or force the current
% constraint only)


function varargout = displayBR(varargin)
% DISPLAYBR MATLAB code for displayBR.fig
%      DISPLAYBR, by itself, creates a new DISPLAYBR or raises the existing
%      singleton*.
%
%      H = DISPLAYBR returns the handle to a new DISPLAYBR or the handle to
%      the existing singleton*.
%
%      DISPLAYBR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAYBR.M with the given input arguments.
%
%      DISPLAYBR('Property','Value',...) creates a new DISPLAYBR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before displayBR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to displayBR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help displayBR

% Last Modified by GUIDE v2.5 10-Jul-2013 10:02:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @displayBR_OpeningFcn, ...
                   'gui_OutputFcn',  @displayBR_OutputFcn, ...
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


% --- Executes just before displayBR is made visible.
function displayBR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to displayBR (see VARARGIN)

% Choose default command line output for displayBR
handles.output = hObject;

% Set the title of the GUI
num = num2str(evalin('base','ims{index,1}'));
set(handles.figure1,'Name',strcat('Image #',num));
set(handles.orig,'Value',1);

% Load the images for quick access
S = evalin('base','ims{index,4}');
handles.oimage = S.Original;
handles.bimage = S.Bmode.Image;
handles.rimage = S.Region.Image;

% Load the data for dataSWV and qualityMap to properly display those
T = evalin('base','ims{index,5}');
handles.dataSWV = T.dataSWV;
handles.qualityMap = T.qualityMap;

handles.lateral = T.lateral;
handles.depth = T.depth;
handles.sweRangeType1 = T.sweRangeType1;
handles.LUTdata = T.LUTdata;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes displayBR wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = displayBR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Button group
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.imtype = get(hObject,'Value');

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in disp.
function disp_Callback(hObject, eventdata, handles)
% hObject    handle to disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch handles.imtype
    case 1 % Original, full-sized
        figure, imshow(handles.oimage);
    case 2 % B-mode
        figure, imshow(handles.bimage);
    case 3 % Region, over B-mode
        figure, imshow(handles.rimage);
    case 4 % dataSWV
        figure
        imagesc(handles.lateral, handles.depth, handles.dataSWV)
        caxis([0 handles.sweRangeType1])
        colormap(handles.LUTdata/255)
        axis image; colorbar;
        xlabel('Lateral (mm)');ylabel('Depth (mm)');
        title('SWV box in m/s');
    case 5 % qualityMap
        figure
        imagesc(handles.lateral, handles.depth, handles.qualityMap)
        caxis([0 1])
        colormap(handles.LUTdata/255)
        axis image; colorbar;
        xlabel('Lateral (mm)');ylabel('Depth (mm)');
        title('Quality map');
end


% --- Executes on button press in keep.
function keep_Callback(hObject, eventdata, handles)
% hObject    handle to keep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

assignin('base','keep',true)