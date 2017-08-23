% Menu of images to display for an image of type 'noregion'


function varargout = displayNR(varargin)
% DISPLAYNR MATLAB code for displayNR.fig
%      DISPLAYNR, by itself, creates a new DISPLAYNR or raises the existing
%      singleton*.
%
%      H = DISPLAYNR returns the handle to a new DISPLAYNR or the handle to
%      the existing singleton*.
%
%      DISPLAYNR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAYNR.M with the given input arguments.
%
%      DISPLAYNR('Property','Value',...) creates a new DISPLAYNR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before displayNR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to displayNR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help displayNR

% Last Modified by GUIDE v2.5 28-Jun-2013 13:29:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @displayNR_OpeningFcn, ...
                   'gui_OutputFcn',  @displayNR_OutputFcn, ...
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


% --- Executes just before displayNR is made visible.
function displayNR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to displayNR (see VARARGIN)

% Choose default command line output for displayNR
handles.output = hObject;

% Set the title of the GUI
num = num2str(evalin('base','ims{index,1}'));
set(handles.figure1,'Name',strcat('Image #',num));
set(handles.orig,'Value',1);

% Load images for quick access
S = evalin('base','ims{index,4}');
handles.oimage = S.Original;
handles.bimage = S.Bmode.Image;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes displayNR wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = displayNR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in disp.
function disp_Callback(hObject, eventdata, handles)
% hObject    handle to disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

otrue = get(handles.orig,'Value');

if otrue % Original, full-size
    figure, imshow(handles.oimage);
else % B-mode
    figure, imshow(handles.bimage);
end
