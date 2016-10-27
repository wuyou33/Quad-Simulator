function varargout = contsid_toolbox_help(varargin)
% CONTSID_TOOLBOX_HELP M-file for contsid_toolbox_help.fig
%      CONTSID_TOOLBOX_HELP, by itself, creates a new CONTSID_TOOLBOX_HELP or raises the existing
%      singleton*.
%
%      H = CONTSID_TOOLBOX_HELP returns the handle to a new CONTSID_TOOLBOX_HELP or the handle to
%      the existing singleton*.
%
%      CONTSID_TOOLBOX_HELP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTSID_TOOLBOX_HELP.M with the given input arguments.
%
%      CONTSID_TOOLBOX_HELP('Property','Value',...) creates a new CONTSID_TOOLBOX_HELP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before contsid_toolbox_help_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to contsid_toolbox_help_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help contsid_toolbox_help

% Last Modified by GUIDE v2.5 05-Dec-2005 12:17:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @contsid_toolbox_help_OpeningFcn, ...
                   'gui_OutputFcn',  @contsid_toolbox_help_OutputFcn, ...
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


% --- Executes just before contsid_toolbox_help is made visible.
function contsid_toolbox_help_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to contsid_toolbox_help (see VARARGIN)

% Choose default command line output for contsid_toolbox_help
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes contsid_toolbox_help wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = contsid_toolbox_help_OutputFcn(hObject, eventdata, handles) 
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


