function varargout = Delay_estimation(varargin)
% DELAY_ESTIMATION M-file for Delay_estimation.fig
%      DELAY_ESTIMATION, by itself, creates a new DELAY_ESTIMATION or raises the existing
%      singleton*.
%
%      H = DELAY_ESTIMATION returns the handle to a new DELAY_ESTIMATION or the handle to
%      the existing singleton*.
%
%      DELAY_ESTIMATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DELAY_ESTIMATION.M with the given input arguments.
%
%      DELAY_ESTIMATION('Property','Value',...) creates a new DELAY_ESTIMATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Delay_estimation_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Delay_estimation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Delay_estimation

% Last Modified by GUIDE v2.5 11-Nov-2005 12:39:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Delay_estimation_OpeningFcn, ...
                   'gui_OutputFcn',  @Delay_estimation_OutputFcn, ...
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


% --- Executes just before Delay_estimation is made visible.
function Delay_estimation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Delay_estimation (see VARARGIN)

% Choose default command line output for Delay_estimation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Delay_estimation wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Delay_estimation_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    if ~isempty(handles)
        varargout{1} = handles.output;
        delete(handles.figure1);
    else
        varargout{1} = [];
    end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    uiresume(handles.figure1);

