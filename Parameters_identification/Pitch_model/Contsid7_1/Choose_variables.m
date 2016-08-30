function varargout = Choose_variables(varargin)
% CHOOSE_VARIABLES M-file for Choose_variables.fig
%      CHOOSE_VARIABLES, by itself, creates a new CHOOSE_VARIABLES or raises the existing
%      singleton*.
%
%      H = CHOOSE_VARIABLES returns the handle to a new CHOOSE_VARIABLES or the handle to
%      the existing singleton*.
%
%      CHOOSE_VARIABLES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHOOSE_VARIABLES.M with the given input arguments.
%
%      CHOOSE_VARIABLES('Property','Value',...) creates a new CHOOSE_VARIABLES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Choose_variables_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Choose_variables_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Choose_variables

% Last Modified by GUIDE v2.5 20-Dec-2005 19:25:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Choose_variables_OpeningFcn, ...
                   'gui_OutputFcn',  @Choose_variables_OutputFcn, ...
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


% --- Executes just before Choose_variables is made visible.
function Choose_variables_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to Choose_variables (see VARARGIN)
    if nargin>0
        data=varargin{1};
        handles.data=data;
    end
    str=fieldnames(data);
    set(handles.listbox1,'string',str);
    handles.str=str;
    zero=1;
    handles.zero=zero;
    reg=1;
    handles.reg=reg;

    % Choose default command line output for Choose_variables
    handles.output = [];

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes Choose_variables wait for user response (see UIRESUME)
    uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Choose_variables_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    %assignin('base','h',handles);
    if ~isempty(handles)
        varargout{1} = handles.output;
        delete(handles.figure1);
    else
        varargout{1} = [];
    end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
    % hObject    handle to listbox1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    v=get(handles.listbox1,'Value');
    s=get(handles.listbox1,'String');
    su=get(handles.listbox2,'String');
    if isempty(su)
        su={s{v}};
    else
        su={su{:},s{v}};
    end
    if length(su)<=3
        set(handles.listbox2,'String',su);
    end
    handles.su=su;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    v=get(handles.listbox1,'Value');
    s=get(handles.listbox1,'String');
    sy=get(handles.listbox3,'String');
    if isempty(sy)
        sy={s{v}};
    else
        sy={sy{:},s{v}};
    end
    if length(sy)<=3
        set(handles.listbox3,'String',sy);
    end
    handles.sy=sy;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    data=handles.data;
    if isfield(handles,'su')
        U=handles.su;
    else
        errordlg('You must select at least 1 input',...
            'Incorrect Selection','modal')
            return
    end
    if isfield(handles,'sy')
        Y=handles.sy;
    else
        errordlg('You must select at least 1 output',...
            'Incorrect Selection','modal')
            return
    end
    Ts=get(handles.text3,'String');
    [x,ok]=str2num(Ts);
    if isempty (Ts) && (get(handles.radiobutton9,'value')==1)
        errordlg('You must enter the sampling period',...
            'Incorrect Selection','modal')
            return
    elseif isempty (Ts) && (get(handles.radiobutton9,'value')==0)
        errordlg('You must enter the sampling instants',...
            'Incorrect Selection','modal')
            return
    elseif ok==1
        Ts=str2num(Ts);
    elseif ok==0
        Ts=getfield(data,get(handles.text3,'String'));
    end
    u1=0;
    u2=0;
    u3=0;
    y1=0;
    if length(U)==0
        errordlg('You must select at least 1 input',...
            'Incorrect Selection','modal')
            return
    elseif length(U)==1 
        u1=getfield(data,U{1});
        Ue=u1;
    elseif length(U)==2
        u1=getfield(data,U{1});
        u2=getfield(data,U{2});
        Ue=[u1 u2];
    elseif length(U)==3
        u1=getfield(data,U{1});
        u2=getfield(data,U{2});
        u3=getfield(data,U{3});
        Ue=[u1 u2 u3];
    else
        errordlg('You must select only 3 inputs',...
            'Incorrect Selection','modal')
            return
    end
    if length(Y)==0
        errordlg('You must select at least 1 output',...
            'Incorrect Selection','modal')
            return
    elseif length(Y)==1 
        y1=getfield(data,Y{1});
        Ye=y1;
    else
        errordlg('You must select only one outputs',...
            'Incorrect Selection','modal')
            return
    end
    if length(Ts)==0
        errordlg('You must enter the sampling period',...
            'Incorrect Selection','modal')
            return
    end
    zero=handles.zero;
    reg=handles.reg;
    if (zero==1)&(reg==1)
        U=iddata(Ye,Ue,Ts);
    elseif (zero==1)&(reg==0)
        U=iddata(Ye,Ue,'SamplingInstants',Ts);
    elseif (zero==0)&(reg==1)
        U=iddata(Ye,Ue,Ts,'Intersample','foh');
    elseif (zero==0)&(reg==0)
        U=iddata(Ye,Ue,'SamplingInstants',Ts);
    end
    yunit=get(handles.edit4,'String');
    uunit=get(handles.edit3,'String');
    Tunit=get(handles.edit5,'String');
    if strcmp(yunit,'')
        yunit='';
    end
    if strcmp(uunit,'')
        yunit='';
    end
    if strcmp(uunit,'')
        yunit='';
    end    
    handles.output.yunit=yunit;
    handles.output.uunit=uunit;
    handles.output.Tunit=Tunit;
    handles.output.U=U;
    handles.output.reg=reg;  
    guidata(hObject, handles);
    uiresume(handles.figure1);
    
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(handles.listbox2,'string','')
    su={};
    handles.su=su;
    guidata(hObject, handles);
    
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(handles.listbox3,'string','')
    sy={};
    handles.sy=sy;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton8 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)    
    v=get(handles.listbox1,'Value');
    s=get(handles.listbox1,'String');
    set(handles.text3,'String',s{v});
    
    
% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
    % hObject    handle to listbox3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = get(hObject,'String') returns listbox3 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox3
    
    
% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
    % hObject    handle to listbox2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton4
    if get(hObject,'Value')==1 
        set(handles.radiobutton5,'Value',0) 
    end
    zero=1;
    handles.zero=zero;
    guidata(hObject, handles);

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton5
    if get(hObject,'Value')==1 
        set(handles.radiobutton4,'Value',0) 
    end
    zero=0;
    handles.zero=zero;
    guidata(hObject, handles);

% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton9 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton9
    if get(hObject,'Value')==1 
        set(handles.radiobutton10,'Value',0) 
    end
    set(handles.text7,'string','Ts =')
    set(handles.uipanel4,'Title','Sampling Period')
    reg=1;
    handles.reg=reg;
    set(handles.radiobutton4,'Enable','on')
    set(handles.radiobutton5,'Enable','on')
    guidata(hObject, handles);


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton10 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton10
    if get(hObject,'Value')==1 
        set(handles.radiobutton9,'Value',0) 
    end
    set(handles.text7,'string','t =')
    set(handles.uipanel4,'Title','Sampling Instants')
    reg=0;
    handles.reg=reg;
    set(handles.radiobutton4,'Enable','off')
    set(handles.radiobutton5,'Enable','off')
    set(handles.radiobutton4,'Value',0)
    set(handles.radiobutton5,'Value',1)
    guidata(hObject, handles);





function edit5_Callback(hObject, eventdata, handles)
    % hObject    handle to edit5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit5 as text
    %        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit4_Callback(hObject, eventdata, handles)
    % hObject    handle to edit4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit4 as text
    %        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit4 (see GCBO)
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


