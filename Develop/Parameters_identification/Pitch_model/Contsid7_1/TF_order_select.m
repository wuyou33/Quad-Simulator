function varargout = TF_order_select(varargin)
% TF_ORDER_SELECT M-file for TF_order_select.fig
%      TF_ORDER_SELECT, by itself, creates a new TF_ORDER_SELECT or raises the existing
%      singleton*.
%
%      H = TF_ORDER_SELECT returns the handle to a new TF_ORDER_SELECT or the handle to
%      the existing singleton*.
%
%      TF_ORDER_SELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TF_ORDER_SELECT.M with the given input arguments.
%
%      TF_ORDER_SELECT('Property','Value',...) creates a new TF_ORDER_SELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TF_order_select_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TF_order_select_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help TF_order_select

% Last Modified by GUIDE v2.5 12-Oct-2005 17:03:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TF_order_select_OpeningFcn, ...
                   'gui_OutputFcn',  @TF_order_select_OutputFcn, ...
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


% --- Executes just before TF_order_select is made visible.
function TF_order_select_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to TF_order_select (see VARARGIN)
    if nargin>0
            Uest=varargin{1};
            Uval=varargin{2};
            nf=varargin{3};
            reg=varargin{4};
            handles.Uest=Uest;
            handles.Uval=Uval;
            handles.nf=nf;
            ny = Uval.ny;
            nu = Uval.nu;
            handles.reg=reg;
            handles.nu=nu;
            handles.ny=ny;
    end
    if nf==1
        set(handles.text6,'string','nb =');
        set(handles.text8,'string','nf =');
    end
    if reg==0
        set(handles.edit3,'String',0);
        set(handles.edit3,'Enable','off');
        nk=0;
        handles.nk=nk;
    end

    % Choose default command line output for TF_order_select
    handles.output = [];

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes TF_order_select wait for user response (see UIRESUME)
    uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TF_order_select_OutputFcn(hObject, eventdata, handles) 
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
    nu=handles.nu;
    ny=handles.ny;
    na=str2num(get(handles.edit1,'string'));
    nb=str2num(get(handles.edit2,'string'));
    nk=str2num(get(handles.edit3,'string'));
    if na==0
        errordlg('You must enter the denominator order',...
            'Incorrect Selection','modal')
            return
    elseif length(na)~=nu
        errordlg('Check your definition for the number of parameters to be estimated for each polynomial; e.g. nb=1 for single input; nb=[nb1 nb2]=[2 1] for two inputs',...
            'Incorrect Selection','modal')
            return
    end
    if nb==0
        errordlg('You must enter the numerator order',...
            'Incorrect Selection','modal')
            return
    elseif length(nb)~=ny
        errordlg('You have more or less outputs',...
            'Incorrect Selection','modal')
            return
    end
    if nk < 0
        errordlg('You must enter the time delay',...
            'Incorrect Selection','modal')
            return
    end    
    N=[na nb nk];
    handles.output=N;
    guidata(hObject, handles)
    uiresume(handles.figure1);

function edit1_Callback(hObject, eventdata, handles)
    % hObject    handle to edit1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit1 as text
    %        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit2_Callback(hObject, eventdata, handles)
    % hObject    handle to edit2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit2 as text
    %        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit3_Callback(hObject, eventdata, handles)
    % hObject    handle to edit3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit3 as text
    %        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end