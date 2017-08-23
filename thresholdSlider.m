% A sliding bar from which the user can select the default threshold for
% all of the images


function varargout = thresholdSlider(varargin)
% THRESHOLDSLIDER MATLAB code for thresholdSlider.fig
%      THRESHOLDSLIDER, by itself, creates a new THRESHOLDSLIDER or raises the existing
%      singleton*.
%
%      H = THRESHOLDSLIDER returns the handle to a new THRESHOLDSLIDER or the handle to
%      the existing singleton*.
%
%      THRESHOLDSLIDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THRESHOLDSLIDER.M with the given input arguments.
%
%      THRESHOLDSLIDER('Property','Value',...) creates a new THRESHOLDSLIDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before thresholdSlider_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to thresholdSlider_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help thresholdSlider

% Last Modified by GUIDE v2.5 20-Jun-2013 15:52:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @thresholdSlider_OpeningFcn, ...
                   'gui_OutputFcn',  @thresholdSlider_OutputFcn, ...
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


% --- Executes just before thresholdSlider is made visible.
function thresholdSlider_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to thresholdSlider (see VARARGIN)

% Choose default command line output for thresholdSlider
handles.output = hObject;

% By default, set threshold to 0.
set(handles.slider,'Value',0.0);
set(handles.number,'String','0.0');
assignin('base','thresh',0.0);
handles.th = 0.0;

assignin('base','manual',0);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes thresholdSlider wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = thresholdSlider_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

th = get(hObject,'Value');

% Display the threshold value
set(handles.slider,'Value',th);
set(handles.number,'String',num2str(th));

% Assign the threshold value to the base workspace
assignin('base','thresh',th);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function number_Callback(hObject, eventdata, handles)
% hObject    handle to number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of number as text
%        str2double(get(hObject,'String')) returns contents of number as a double


% --- Executes during object creation, after setting all properties.
function number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in manual.
function manual_Callback(hObject, eventdata, handles)
% hObject    handle to manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Close the slider. ShearWaveAnalysis will open thresholdEnter
close(gcbf)

assignin('base','manual',1);
