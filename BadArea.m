% Given an image with a certain quality threshold. If the number of points
% used is less than one-fourth the total number of points in the data map,
% then BadArea will be raised. The user can choose to keep the image,
% despite the lack of usable data, or to discard it.

function varargout = BadArea(varargin)
% BADAREA MATLAB code for BadArea.fig
%      BADAREA, by itself, creates a new BADAREA or raises the existing
%      singleton*.
%
%      H = BADAREA returns the handle to a new BADAREA or the handle to
%      the existing singleton*.
%
%      BADAREA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BADAREA.M with the given input arguments.
%
%      BADAREA('Property','Value',...) creates a new BADAREA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BadArea_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BadArea_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BadArea

% Last Modified by GUIDE v2.5 05-Jul-2013 16:37:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BadArea_OpeningFcn, ...
                   'gui_OutputFcn',  @BadArea_OutputFcn, ...
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


% --- Executes just before BadArea is made visible.
function BadArea_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BadArea (see VARARGIN)

% Choose default command line output for BadArea
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BadArea wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BadArea_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in discard.
function discard_Callback(hObject, eventdata, handles)
% hObject    handle to discard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

assignin('base','imtype','badregion'); % so that it will not be recognized as having a region
evalin('base','ims{index,2} = imtype;');
evalin('base','clear imtype');

close all
evalin('base','index = index + 1'); % move to the next image

% --- Executes on button press in keep.
function keep_Callback(hObject, eventdata, handles)
% hObject    handle to keep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcbf); % Allows the user to accept or add constraints in checkSWVmap
