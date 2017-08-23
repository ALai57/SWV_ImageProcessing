% Move 'index' to a new number. This mostly applies to checkSWVmap because
% it is the only GUI that calls jumpTo. Therefore, if an image is not of
% type 'region', then jumpTo will call noRegion, which will alert the user
% of the lack of good region


function varargout = jumpTo(varargin)
% JUMPTO MATLAB code for jumpTo.fig
%      JUMPTO, by itself, creates a new JUMPTO or raises the existing
%      singleton*.
%
%      H = JUMPTO returns the handle to a new JUMPTO or the handle to
%      the existing singleton*.
%
%      JUMPTO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in JUMPTO.M with the given input arguments.
%
%      JUMPTO('Property','Value',...) creates a new JUMPTO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before jumpTo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to jumpTo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help jumpTo

% Last Modified by GUIDE v2.5 21-Jun-2013 11:39:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @jumpTo_OpeningFcn, ...
                   'gui_OutputFcn',  @jumpTo_OutputFcn, ...
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


% --- Executes just before jumpTo is made visible.
function jumpTo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to jumpTo (see VARARGIN)

% Choose default command line output for jumpTo
handles.output = hObject;

% Display current image
index = evalin('base','index');
set(handles.figure1,'Name',strcat('Current image: #',num2str(index)));
set(handles.imnum,'String',num2str(index));

handles.newI = index;

% Update handles structure
guidata(hObject, handles);
% set(handles.figure1,'CloseRequestFcn',@closeGUI);

% UIWAIT makes jumpTo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = jumpTo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function imnum_Callback(hObject, eventdata, handles)
% hObject    handle to imnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imnum as text
%        str2double(get(hObject,'String')) returns contents of imnum as a double

handles.newI = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function imnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Close figure without changing the current image
close(gcbf)


% --- Executes on button press in go.
function go_Callback(hObject, eventdata, handles)
% hObject    handle to go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check that the image is of type 'region'. If not, alert the user
newIm = evalin('base','ims(:,2)');
reg = newIm{handles.newI};
if strcmp(reg,'region')
    con = 1;
else
    waitfor(noRegion);
    con = evalin('base','con');
    evalin('base','clear con');
end

% If either the image has a good shear wave region or it has a bad one, but
% the user wants to continue anyways
if con
    assignin('base','index',int32(handles.newI));
    close all
end

evalin('base','clear con');

% function closeGUI(src,evnt)
% selection = questdlg('Do you want to select the Q-box?','Close Request Function','Yes','No','Not Yet','Yes');
% switch selection
%     case 'Yes'
%         assignin('base','con',1);
%         delete(gcf)
%     case 'No'
%         assignin('base','con',0);
%         delete(gcf)
%     case 'Not Yet'
%         return
% end
