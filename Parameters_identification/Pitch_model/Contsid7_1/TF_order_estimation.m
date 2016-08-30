function varargout = TF_order_estimation(varargin)

% TF_ORDER_ESTIMATION M-file for TF_order_estimation.fig
%      TF_ORDER_ESTIMATION, by itself, creates a new TF_ORDER_ESTIMATION or raises the existing
%      singleton*.
%
%      H = TF_ORDER_ESTIMATION returns the handle to a new TF_ORDER_ESTIMATION or the handle to
%      the existing singleton*.
%
%      TF_ORDER_ESTIMATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TF_ORDER_ESTIMATION.M with the given input arguments.
%
%      TF_ORDER_ESTIMATION('Property','Value',...) creates a new TF_ORDER_ESTIMATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TF_order_estimation_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TF_order_estimation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help TF_order_estimation

% Last Modified by GUIDE v2.5 16-Oct-2015 12:05:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TF_order_estimation_OpeningFcn, ...
    'gui_OutputFcn',  @TF_order_estimation_OutputFcn, ...
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


% --- Executes just before TF_order_estimation is made visible.
function TF_order_estimation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TF_order_estimation (see VARARGIN)
if nargin>0
    Uest=varargin{1};
    Uval=varargin{2};
    reg=varargin{4};
    nf=varargin{3};
    handles.Uest=Uest;
    handles.Uval=Uval;
    handles.nf=nf;
    hx=size(Uest.inputdata);
    nu=hx(2);
    hy=size(Uest.outputdata);
    ny=hy(2);
    handles.reg=reg;
    handles.nu=nu;
    handles.ny=ny;
end
if nf==1
    set(handles.popupmenu10,'string',{'--nb min--','1','2','3','4','5','6','7'});
    set(handles.popupmenu7,'string',{'--nb max--','1','2','3','4','5','6','7'});
    set(handles.popupmenu11,'string',{'--nf min--','1','2','3','4','5','6','7'});
    set(handles.popupmenu8,'string',{'--nf max--','1','2','3','4','5','6','7'});
end
if reg==0
    set(handles.edit7,'enable','on')
    set(handles.pushbutton10,'enable','on')
    set(handles.popupmenu12,'string',{'--nf min--','0'});
    set(handles.popupmenu9,'string',{'--nf max--','0'});
    set(handles.popupmenu12,'Enable','off','Value',2);
    set(handles.popupmenu9,'Enable','off','Value',2);
end

% Choose default command line output for TF_order_estimation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TF_order_estimation wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TF_order_estimation_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%     if ~isempty(handles)
varargout{1} = handles.output;
%         delete(handles.figure1);
%     else
%         varargout{1} = [];
%     end
%delete(handles.figure1);

% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6
set(handles.pushbutton7,'enable','on');



% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)

% By AP:
% The command "get(handles.popupmenu6,'Value')" delivers a cell with 
% characters and we need a number (the last choice). The following 
% workaround allows to get the last selected option from popupmenu6.
popupmenu6_val = get(handles.popupmenu6,'Value');
popupmenu6_val = popupmenu6_val{end};

% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.popupmenu7,'Value')==1)| ...
        (get(handles.popupmenu8,'Value')==1)| ...
        (get(handles.popupmenu9,'Value')==1)| ...
        (get(handles.popupmenu10,'Value')==1)| ...
        (get(handles.popupmenu11,'Value')==1)| ...
        (get(handles.popupmenu12,'Value')==1)| ...
        popupmenu6_val==1
        %(get(handles.popupmenu6,'Value')==1)
    errordlg('You must enter correctly the the parameter',...
        'Incorrect Selection','modal')
    return
end
set(handles.text14,'string','In progress...');
nu=handles.nu;
ny=handles.ny;
Uest=handles.Uest;
Uval=handles.Uval;
na_max=handles.na_max;
nb_max=handles.nb_max;
nk_max=handles.nk_max;
na_min=handles.na_min;
nb_min=handles.nb_min;
nk_min=handles.nk_min;
nf=handles.nf;
a_min=na_min*ones(1,nu);
a_max=na_max*ones(1,nu);
b_min=nb_min*ones(1,nu);
b_max=nb_max*ones(1,nu);
k_min=nk_min*ones(1,nu);
k_max=nk_max*ones(1,nu);
if nf==1
    nn=[a_min b_min k_min;a_max b_max k_max];
else
    nn=[b_min a_min k_min;b_max a_max k_max];
end
reg=handles.reg;
if reg==0
    lambda=str2num(get(handles.edit7,'string'));
    if isempty(lambda)|(lambda<=0)
        errordlg('You must enter correctly the user parameter',...
            'Incorrect Selection','modal')
        return
    end
    V=srivcstruc(Uest,Uval,nn,lambda);
else
    V=srivcstruc(Uest,Uval,nn);
end

% if get(handles.popupmenu6,'value')==2
%     [str, Vcri]=selcstruc(V,'c2sort','YIC');
% elseif  get(handles.popupmenu6,'value')==3
%     [str, Vcri]=selcstruc(V,'c2sort','RTe');
% elseif  get(handles.popupmenu6,'value')==4
%     [str, Vcri]=selcstruc(V,'c2sort','FPE');
% elseif  get(handles.popupmenu6,'value')==5
%     [str, Vcri]=selcstruc(V,'c2sort','AIC');
% end
switch popupmenu6_val
    case 2
        [str, Vcri]=selcstruc(V,'c2sort','YIC');
    case 3
        [str, Vcri]=selcstruc(V,'c2sort','RTe');
    case 4
        [str, Vcri]=selcstruc(V,'c2sort','FPE');
    case 5
        [str, Vcri]=selcstruc(V,'c2sort','AIC');
end

set(handles.text14,'string','The criterions values of each model are displayed in the workspace');


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7
na_max=get(hObject,'Value')-1;
handles.na_max=na_max;
guidata(hObject, handles);
set(handles.popupmenu11,'Enable','on');

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8
nb_max=get(hObject,'Value')-1;
handles.nb_max=nb_max;
guidata(hObject, handles);
set(handles.popupmenu12,'Enable','on');

% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9
nk_max=get(hObject,'Value')-2;
handles.nk_max=nk_max;
guidata(hObject, handles);
set(handles.popupmenu6,'Enable','on');

% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10
na_min=get(hObject,'Value')-1;
handles.na_min=na_min;
guidata(hObject, handles);
set(handles.popupmenu7,'Enable','on');

% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11
nb_min=get(hObject,'Value')-1;
handles.nb_min=nb_min;
guidata(hObject, handles);
set(handles.popupmenu8,'Enable','on');

% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12
nk_min=get(hObject,'Value')-2;
handles.nk_min=nk_min;
guidata(hObject, handles);
set(handles.popupmenu9,'Enable','on');

% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f='no';
user_prameter(f)


