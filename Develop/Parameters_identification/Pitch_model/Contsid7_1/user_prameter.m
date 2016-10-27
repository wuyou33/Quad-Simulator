function varargout = user_prameter(varargin)
% USER_PRAMETER M-file for user_prameter.fig
%      USER_PRAMETER, by itself, creates a new USER_PRAMETER or raises the existing
%      singleton*.
%
%      H = USER_PRAMETER returns the handle to a new USER_PRAMETER or the handle to
%      the existing singleton*.
%
%      USER_PRAMETER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USER_PRAMETER.M with the given input arguments.
%
%      USER_PRAMETER('Property','Value',...) creates a new USER_PRAMETER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before user_prameter_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to user_prameter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help user_prameter

% Last Modified by GUIDE v2.5 17-Mar-2006 15:37:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @user_prameter_OpeningFcn, ...
                   'gui_OutputFcn',  @user_prameter_OutputFcn, ...
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


% --- Executes just before user_prameter is made visible.
function user_prameter_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to user_prameter (see VARARGIN)
    if nargin>0
        f=varargin{1};
    end
    if strcmp(f,'lif')
        set(handles.text2,'Visible','off')
        set(handles.text3,'Visible','on')
    elseif strcmp(f,'rpm')
        set(handles.text2,'Visible','off')
        set(handles.text4,'Visible','on')
    end
        
    % Choose default command line output for user_prameter
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes user_prameter wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = user_prameter_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    close


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    close

