% Alerts the user that the image they have selected does not contain a
% workable region. Gives the user the option to select another or display
% the current image. If the user wants to keep the data for images of type
% 'badregion', they must first display the image


function varargout = noRegion(varargin)
% NOREGION MATLAB code for noRegion.fig
%      NOREGION, by itself, creates a new NOREGION or raises the existing
%      singleton*.
%
%      H = NOREGION returns the handle to a new NOREGION or the handle to
%      the existing singleton*.
%
%      NOREGION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NOREGION.M with the given input arguments.
%
%      NOREGION('Property','Value',...) creates a new NOREGION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before noRegion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to noRegion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help noRegion

% Last Modified by GUIDE v2.5 28-Jun-2013 13:11:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @noRegion_OpeningFcn, ...
                   'gui_OutputFcn',  @noRegion_OutputFcn, ...
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


% --- Executes just before noRegion is made visible.
function noRegion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to noRegion (see VARARGIN)

% Choose default command line output for noRegion
handles.output = hObject;

num = num2str(evalin('base','ims{index,1}'));
set(handles.figure1,'Name',strcat('Image #',num));

filetype = evalin('base','ims{index,2}');
switch filetype
    case 'movie'
        errormessage = 'This movie does not contain a region.';
    case 'panoramic'
        errormessage = 'This image does not contain a region.';
    case 'noregion'
        errormessage = 'This image does not contain a region.';
    case 'badregion'
        errormessage = 'This quality map is below the threshold for analysis';
    case 'region'
        errormessage = 'Whoops'
end

set(handles.errmess,'String',errormessage);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes noRegion wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = noRegion_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in newim.
function newim_Callback(hObject, eventdata, handles)
% hObject    handle to newim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all
waitfor(jumpTo)

% --- Executes on button press in disp.
function disp_Callback(hObject, eventdata, handles)
% hObject    handle to disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imtype = evalin('base','ims{index,2}');

switch imtype
    case 'movie'
        movie = evalin('base','ims{index,4}.Movie');
        figure, implay(movie);
    case 'panoramic'
        image = evalin('base','ims{index,4}'); % This will likely change
        figure, imshow(image);
    case 'noregion'
        waitfor(displayNR)
    case 'badregion'
        waitfor(displayBR)
        if evalin('base','keep')
            assignin('base','imtype','region');
            evalin('base','ims{index,2} = imtype;');
            evalin('base','clear imtype');
            close all
            evalin('base','clear keep');
        end
    case 'region'
        close all
        evalin('base','disp whoops');
end
