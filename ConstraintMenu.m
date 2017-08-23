% Calls a menu containing the options for additional constraints to be
% placed on the data map. These are any constraints beyond the default
% threshold for that session.
%
% Current options include loading a previous constraint or removing a
% border. By having a menu like this, it is easier to add more ways of
% constraining the data.


function varargout = ConstraintMenu(varargin)
% CONSTRAINTMENU MATLAB code for ConstraintMenu.fig
%      CONSTRAINTMENU, by itself, creates a new CONSTRAINTMENU or raises the existing
%      singleton*.
%
%      H = CONSTRAINTMENU returns the handle to a new CONSTRAINTMENU or the handle to
%      the existing singleton*.
%
%      CONSTRAINTMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONSTRAINTMENU.M with the given input arguments.
%
%      CONSTRAINTMENU('Property','Value',...) creates a new CONSTRAINTMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConstraintMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConstraintMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConstraintMenu

% Last Modified by GUIDE v2.5 09-Jul-2013 11:31:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConstraintMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @ConstraintMenu_OutputFcn, ...
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


% --- Executes just before ConstraintMenu is made visible.
function ConstraintMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConstraintMenu (see VARARGIN)

% Choose default command line output for ConstraintMenu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ConstraintMenu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ConstraintMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in constraint.
function constraint_Callback(hObject, eventdata, handles)
% hObject    handle to constraint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns constraint contents as cell array
%        contents{get(hObject,'Value')} returns selected item from constraint

% Currently: 1, Load existing constraint
%            2, Physical constraint

handles.cType = get(hObject,'Value');

% --- Executes during object creation, after setting all properties.
function constraint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to constraint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ctype = handles.ctype;

switch ctype
    case 1 % Load an existing constraint
        waitfor(LoadConstraint)
    case 2 % Add a physical constraint
        waitfor(PhysicalConstraint)
end
