function varargout = Data_selection(varargin)
% DATA_SELECTION M-file for Data_selection.fig
%      DATA_SELECTION, by itself, creates a new DATA_SELECTION or raises the existing
%      singleton*.
%
%      H = DATA_SELECTION returns the handle to a new DATA_SELECTION or the handle to
%      the existing singleton*.
%
%      DATA_SELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_SELECTION.M with the given input arguments.
%
%      DATA_SELECTION('Property','Value',...) creates a new DATA_SELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Data_selection_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Data_selection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Data_selection

% Last Modified by GUIDE v2.5 24-Nov-2005 12:31:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Data_selection_OpeningFcn, ...
                   'gui_OutputFcn',  @Data_selection_OutputFcn, ...
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


% --- Executes just before Data_selection is made visible.
function Data_selection_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to Data_selection (see VARARGIN)
    if nargin>0
        U=varargin{1};
        handles.U=U;
    end
    t=U.SamplingInstants;
    nu=U.nu;
    ny=U.ny;
    for i=1:nu
        axes(handles.axes1);
        hold on
        r = betarnd(10,10,[1 3]);
        if i==1
            hu(i)=plot(t,U.Inputdata(:,i),'color','r');
        elseif i==2
            hu(i)=plot(t,U.Inputdata(:,i),'color','b');
        else
            hu(i)=plot(t,U.Inputdata(:,i),'color','g');
        end
        xlabel('Time (sec)');
        handles.hu=hu;
        hold off
    end
    for i=1:ny
        axes(handles.axes2);
        hold on
        r = betarnd(10,10,[1 3]);
        if i==1
            plot(t,U.Outputdata(:,i),'Color','r');
        elseif i==2
            plot(t,U.Outputdata(:,i),'Color','b');
        else
            plot(t,U.Outputdata(:,i),'Color','g');
        end
        xlabel('Time (sec)');
        hold off
    end
    int=['[','0',' ',num2str(max(U.SamplingInstants)),']'];
    set(handles.edit1,'String',int);
    e=0; 
    binf=1;
    bsup=(U.N);
    handles.binf=binf;
    handles.bsup=bsup;
    handles.e=e;
    minu=min(U.Inputdata);
    maxu=max(U.Inputdata);
    miny=min(U.Outputdata);
    maxy=max(U.Outputdata);
    set(handles.axes1,'Ylim',[minu(1)*1.1  maxu(1)*1.1])
    set(handles.axes2,'Ylim',[miny(1)*1.1  maxy(1)*1.1])
    % Choose default command line output for Data_selection
    handles.output = [];

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes Data_selection wait for user response (see UIRESUME)
    uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Data_selection_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    axes(handles.axes2);
    e=handles.e;
    if e==0
        locallim_2
    else
        errordlg('You have two axes on the current figure',...
            'Incorrect Selection','modal')
            return
    end
    e=1;
    handles.e=e;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)    
    U=handles.U;
    h1 = findobj(handles.figure1, 'tag', 'Limit1');
    h2 = findobj(handles.figure1, 'tag', 'Limit2');
    if isempty(h1) & isempty(h2)
        errordlg('You have to select the region of the estimation data',...
            'Incorrect Selection','modal');
        return;
    end
    xdatae=get(h1,'xdata');
    xdatav=get(h2,'xdata');
    if ((xdatav(1)/(U.Ts))+1)>(U.N)
        if (round(xdatae(1))>xdatae(1))|(round(xdatae(1))<xdatae(1))
            b=sprintf('%3.1f',xdatae(1));
        else
            b=num2str(xdatae(1));
        end
        int=['[',b,' ',num2str(max(U.SamplingInstants)),']'];
    else
        if (round(xdatae(1))>xdatae(1))|(round(xdatae(1))<xdatae(1))
            b=sprintf('%3.1f',xdatae(1));
        else
            b=num2str(xdatae(1));
        end
        if (round(xdatav(1))>xdatav(1))|(round(xdatav(1))<xdatav(1))
            s=sprintf('%3.1f',xdatav(1));
        else
            s=num2str(xdatav(1));
        end
        int=['[',b,' ',s,']'];
    end
    set(handles.axes1,'Xlim',[xdatae(1) xdatav(1)])
    set(handles.axes2,'Xlim',[xdatae(1) xdatav(1)])
    e=handles.e;
    binf=1;
    bsup=(U.N);
    if e==1
        set(handles.edit1,'string',int);
        binf=round(((xdatae(1)/(U.Ts))+1));
    if ((xdatav(1)/(U.Ts))+1)>(U.N)
        bsup=(U.N);
    else
        bsup=round(((xdatav(1)/(U.Ts))+1));
    end
    end
    handles.binf=binf;
    handles.bsup=bsup;
    e=0;
    handles.e=e;
    axes(handles.axes2);
    cla;
    t=U.SamplingInstants;
    ny=U.ny;
    for i=1:ny
        axes(handles.axes2);
        hold on
        r = betarnd(10,10,[1 3]);
        plot(t,U.Outputdata(:,i),'Color','r');
        xlabel('Time (sec)');
        hold off
    end
    guidata(hObject, handles);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    binf=handles.binf;
    bsup=handles.bsup;
    handles.output.binf=binf;
    handles.output.bsup=bsup;    
    uiresume(handles.figure1);
    guidata(hObject, handles);
    



% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
    % hObject    handle to File (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
    % hObject    handle to Open (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
    % hObject    handle to Save (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    saveas(gcf,'selection.fig')


% --------------------------------------------------------------------
function Print_Callback(hObject, eventdata, handles)
    % hObject    handle to Print (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    printdlg(handles.figure1)

% --------------------------------------------------------------------
function Close_Callback(hObject, eventdata, handles)
    % hObject    handle to Close (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
    if strcmp(selection,'No')
        return;
    end
    delete(handles.figure1)


% --------------------------------------------------------------------
function Autorange_Callback(hObject, eventdata, handles)
    % hObject    handle to Autorange (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    U=handles.U;
    Tsim=[0:U.Ts:(U.Ts*((U.N)-1))];
    set(handles.axes1,'Xlim',[0 (U.Ts*((U.N)-1))])
    set(handles.axes2,'Xlim',[0 (U.Ts*((U.N)-1))])
    minu=min(U.Inputdata);
    maxu=max(U.Inputdata);
    miny=min(U.Outputdata);
    maxy=max(U.Outputdata);
    set(handles.axes1,'Ylim',[minu(1)*1.1  maxu(1)*1.1])
    set(handles.axes2,'Ylim',[miny(1)*1.1  maxy(1)*1.1])

% --------------------------------------------------------------------
function Update_Callback(hObject, eventdata, handles)
    % hObject    handle to Update (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    X1=get(handles.axes1,'Xlim');
    X2=get(handles.axes2,'Xlim');
    if X1(2)<X2(2)
        set(handles.axes2,'Xlim',(get(handles.axes1,'Xlim')))
    elseif X1(2)>X2(2)
        set(handles.axes1,'Xlim',(get(handles.axes2,'Xlim')))
    end


% --------------------------------------------------------------------
function Grid_Callback(hObject, eventdata, handles)
    % hObject    handle to Grid (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if strcmp(get(hObject,'Checked'),'off')
        set(handles.axes1,'XGrid','on')
        set(handles.axes2,'XGrid','on')
        set(handles.axes1,'YGrid','on')
        set(handles.axes2,'YGrid','on')
        set(hObject,'Checked','on')
    else
        set(handles.axes1,'XGrid','off')
        set(handles.axes2,'XGrid','off')
        set(handles.axes1,'YGrid','off')
        set(handles.axes2,'YGrid','off')
        set(hObject,'Checked','off')
    end

% --------------------------------------------------------------------
function Zoom_Callback(hObject, eventdata, handles)
    % hObject    handle to Zoom (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if strcmp(get(hObject,'Checked'),'off')
        axes(handles.axes1);
        axes(handles.axes2);
        zoom on
        set(hObject,'Checked','on')
    else
        axes(handles.axes1);
        axes(handles.axes2);
        zoom off
        set(hObject,'Checked','off')
    end


% --------------------------------------------------------------------
function CONTSID_GU_Help_Callback(hObject, eventdata, handles)
    % hObject    handle to CONTSID_GU_Help (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Options_Callback(hObject, eventdata, handles)
    % hObject    handle to Options (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Style_Callback(hObject, eventdata, handles)
    % hObject    handle to Style (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
    % hObject    handle to Help (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)


