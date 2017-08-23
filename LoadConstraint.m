% Load a previous constraint


function varargout = LoadConstraint(varargin)
% LOADCONSTRAINT MATLAB code for LoadConstraint.fig
%      LOADCONSTRAINT, by itself, creates a new LOADCONSTRAINT or raises the existing
%      singleton*.
%
%      H = LOADCONSTRAINT returns the handle to a new LOADCONSTRAINT or the handle to
%      the existing singleton*.
%
%      LOADCONSTRAINT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOADCONSTRAINT.M with the given input arguments.
%
%      LOADCONSTRAINT('Property','Value',...) creates a new LOADCONSTRAINT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LoadConstraint_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LoadConstraint_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LoadConstraint

% Last Modified by GUIDE v2.5 09-Jul-2013 09:40:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LoadConstraint_OpeningFcn, ...
                   'gui_OutputFcn',  @LoadConstraint_OutputFcn, ...
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


% --- Executes just before LoadConstraint is made visible.
function LoadConstraint_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LoadConstraint (see VARARGIN)

% Choose default command line output for LoadConstraint
handles.output = hObject;

% List the number of constraints
current = evalin('base','ims{index,6}.current');
total = evalin('base','size(ims{index,6}.Constraints)';);
if total == 1
    headermessage = 'There is 1 constraint.';
else
    headermessage = strcat('There are ',num2str(total),' contraints.');
end
set(handles.header,'String',headermessage);

% Load and display current threshold
handles.Constraints = evalin('base','ims{index,6}.Constraints');
threshold = handles.Contraints(current).threshold;
set(handles.thresh,'String',num2str(threshold));

handles.newnum = current;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LoadConstraint wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LoadConstraint_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function number_Callback(hObject, eventdata, handles)
% hObject    handle to number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of number as text
%        str2double(get(hObject,'String')) returns contents of number as a double

handles.newnum = str2double(get(hObject,'String'));

% Display the new threshold
threshold = handles.Contraints(newnum).threshold;
set(handles.thresh,'String',num2str(threshold));

% Update handles structure
guidata(hObject, handles);


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


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Change ims{index,6}.current to reflect the new constraint
assignin('base','newnum',handles.newnum);
evalin('base','ims{index,6}.current = newnum;');
evalin('base','clear newnum');
