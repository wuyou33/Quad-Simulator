function varargout = about_contsid(varargin)
% ABOUT_CONTSID M-file for about_contsid.fig
%      ABOUT_CONTSID, by itself, creates a new ABOUT_CONTSID or raises the existing
%      singleton*.
%
%      H = ABOUT_CONTSID returns the handle to a new ABOUT_CONTSID or the handle to
%      the existing singleton*.
%
%      ABOUT_CONTSID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ABOUT_CONTSID.M with the given input arguments.
%
%      ABOUT_CONTSID('Property','Value',...) creates a new ABOUT_CONTSID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before about_contsid_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to about_contsid_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help about_contsid

% Last Modified by GUIDE v2.5 05-Dec-2005 10:18:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @about_contsid_OpeningFcn, ...
                   'gui_OutputFcn',  @about_contsid_OutputFcn, ...
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


% --- Executes just before about_contsid is made visible.
function about_contsid_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to about_contsid (see VARARGIN)
    axes(handles.axes1);
    I = imread('contsid_ray-tracing_medium.jpeg');
    imshow(I)
 
    % Choose default command line output for about_contsid
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes about_contsid wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = about_contsid_OutputFcn(hObject, eventdata, handles) 
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
    licence

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    close


