function varargout = Plot_data(varargin)
% PLOT_DATA M-file for Plot_data.fig
%      PLOT_DATA, by itself, creates a new PLOT_DATA or raises the existing
%      singleton*.
%
%      H = PLOT_DATA returns the handle to a new PLOT_DATA or the handle to
%      the existing singleton*.
%
%      PLOT_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOT_DATA.M with the given input arguments.
%
%      PLOT_DATA('Property','Value',...) creates a new PLOT_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Plot_data_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Plot_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Plot_data

% Last Modified by GUIDE v2.5 07-Dec-2005 11:13:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plot_data_OpeningFcn, ...
                   'gui_OutputFcn',  @Plot_data_OutputFcn, ...
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

% --- Executes just before Plot_data is made visible.
function Plot_data_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to Plot_data (see VARARGIN)
    if nargin>0
        U=varargin{1};
        Upre=U;
        handles.U=U;
        handles.Upre=Upre;
        tr1=varargin{5};
        tr2=varargin{6};
        tr3=varargin{7};
        yunit=varargin{2};
        uunit=varargin{3};
        Tunit=varargin{4};
        handles.yunit=yunit;
        handles.uunit=uunit;
        handles.Tunit=Tunit;
        handles.tr1=tr1;
        handles.tr2=tr2;
        handles.tr3=tr3;
    end
    t=U.SamplingInstants;
    set(handles.popupmenu1,'String',['All';U.InputName]);
    set(handles.popupmenu2,'String',['All';U.OutputName]);
    nu=U.nu;
    ny=U.ny;
    for i=1:nu
        axes(handles.axes1);
        hold on
        if i==1
            plot(t,U.Inputdata(:,i),'color','r');
        elseif i==2
            plot(t,U.Inputdata(:,i),'color','b');
        else
            plot(t,U.Inputdata(:,i),'color','g');
        end
        xlabel(Tunit);
        ylabel(uunit);
        hold off
    end
    for i=1:ny
        axes(handles.axes2);
        hold on
        if i==1
            plot(t,U.Outputdata(:,i),'Color','r');
        elseif i==2
            plot(t,U.Outputdata(:,i),'Color','b');
        else
            plot(t,U.Outputdata(:,i),'Color','g');
        end
        xlabel(Tunit);
        ylabel(yunit);
        hold off
    end
    set(handles.axes1,'Ylim',(get(handles.axes1,'Ylim')*1.1))
    set(handles.axes2,'Ylim',(get(handles.axes2,'Ylim')*1.1))
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
    if tr1==1
        set(handles.checkbox3,'Value',1)
        Upre=handles.Upre;    
        y=dtrend(Upre.outputdata);
        Upre=iddata(y,Upre.Inputdata,Upre.Ts);
        handles.Upre=Upre;
        for i=1:Upre.ny
            axes(handles.axes2);
            hold on
            t=Upre.samplingInstants;
            plot(t,Upre.Outputdata(:,i),'Color','c');
            xlabel(Tunit);
            ylabel(yunit);
            hold off
        end
    end
    if tr2==1
        set(handles.checkbox4,'Value',1)
        Upre=handles.Upre;
        y=dtrend(Upre.outputdata,1);
        Upre=iddata(y,Upre.Inputdata,Upre.Ts);
        handles.Upre=Upre;   
        for i=1:Upre.ny
            axes(handles.axes2);
            hold on
            t=Upre.samplingInstants;
            plot(t,Upre.Outputdata(:,i),'Color','bl');
            xlabel(Tunit);
            ylabel(yunit);
            hold off
        end
    end
    if tr3==1
        set(handles.checkbox5,'Value',1)
        Upre=handles.Upre;
        u=dtrend(Upre.Inputdata);
        Upre=iddata(Upre.Outputdata,u,Upre.Ts);
        handles.Upre=Upre;
        for i=1:Upre.nu
            axes(handles.axes1);
            t=Upre.SamplingInstants;
            hold on
            if i==1
                 plot(t,Upre.Inputdata(:,i),'color','c');
            elseif i==2
                 plot(t,Upre.Inputdata(:,i),'color','y');
            else
                 plot(t,Upre.Inputdata(:,i),'color','m');
            end
            xlabel(Tunit);
            ylabel(uunit);
            hold off
        end
    end
                        
    % Choose default command line output for Plot_data
    handles.output = [];

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes Plot_data wait for user response (see UIRESUME)
    uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Plot_data_OutputFcn(hObject, eventdata, handles)
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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
    % hObject    handle to popupmenu1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from popupmenu1
    axes(handles.axes1);
    hold on
    cla
    U=handles.U;
    t=U.SamplingInstants;
    popup_sel_index = get(hObject, 'Value');    
    switch popup_sel_index
        case 1
            if U.nu ==1
                plot(t,U.Inputdata(:,1),'color','r');
            elseif U.nu==2
                plot(t,U.Inputdata(:,1),'color','r');
                plot(t,U.Inputdata(:,2),'color','b');
            else
                plot(t,U.Inputdata(:,1),'color','r');
                plot(t,U.Inputdata(:,2),'color','b');
                plot(t,U.Inputdata(:,3),'color','g');
            end
        case 2
            plot(t,U.Inputdata(:,1),'color','r');
        case 3
            plot(t,U.Inputdata(:,2),'color','b');
        case 4
            plot(t,U.Inputdata(:,3),'color','g');                  
    end
    Tunit=handles.Tunit;
    uunit=handles.uunit;
    xlabel(Tunit);
    ylabel(uunit);
    hold off


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to popupmenu1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc
        set(hObject,'BackgroundColor','white');
    else
     set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
    end

    
% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
    % hObject    handle to popupmenu2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from popupmenu2
    axes(handles.axes2);
    hold on
    cla
    U=handles.U;
    t=U.SamplingInstants;
    popup_sel_index = get(hObject, 'Value');    
    switch popup_sel_index
        case 1
            if U.ny ==1
                plot(t,U.Outputdata(:,1),'color','r');
            elseif U.ny==2
                plot(t,U.Outputdata(:,1),'color','r');
                plot(t,U.Outputdata(:,2),'color','b');
            else
                plot(t,U.Outputdata(:,1),'color','r');
                plot(t,U.Outputdata(:,2),'color','b');
                plot(t,U.Outputdata(:,3),'color','g');
            end
        case 2
            plot(t,U.Outputdata(:,1),'color','r');
        case 3
            plot(t,U.Outputdata(:,2),'color','b');
        case 4
            plot(t,U.Outputdata(:,3),'color','g');                
    end
    Tunit=handles.Tunit;
    yunit=handles.yunit;
    xlabel(Tunit);
    ylabel(yunit);
    hold off
    

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to popupmenu2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

   
% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
    % hObject    handle to checkbox3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of checkbox3
    if get(hObject,'Value')==1
        Upre=handles.Upre;    
        y=dtrend(Upre.outputdata);
        Upre=iddata(y,Upre.Inputdata,Upre.Ts);
        for i=1:Upre.ny
            axes(handles.axes2);
            hold on
            t=Upre.samplingInstants;
            plot(t,Upre.Outputdata(:,i),'Color','c');
            hold off
        end
        tr1=1;
    else
        set(handles.checkbox4,'Value',0)
        set(handles.checkbox5,'Value',0)
        U=handles.U;
        Upre=handles.Upre;
        Upre=U;
        tr1=0;
        t=U.SamplingInstants;        
        for i=1:U.nu
            axes(handles.axes1);
            cla
            hold on
            if i==1
                plot(t,U.Inputdata(:,i),'color','r');
            elseif i==2
                plot(t,U.Inputdata(:,i),'color','b');
            else
                plot(t,U.Inputdata(:,i),'color','g');
            end
            Tunit=handles.Tunit;
            uunit=handles.uunit;
            xlabel(Tunit);
            ylabel(uunit);
            hold off
        end
        for i=1:U.ny
            axes(handles.axes2);
            cla
            hold on
            if i==1
                plot(t,U.Outputdata(:,i),'Color','r');
            elseif i==2
                plot(t,U.Outputdata(:,i),'Color','b');
            else
                plot(t,U.Outputdata(:,i),'Color','g');
            end
            Tunit=handles.Tunit;
            yunit=handles.yunit;
            xlabel(Tunit);
            ylabel(yunit);
            hold off
        end
    end
    handles.Upre=Upre;
    handles.tr1=tr1;
    guidata(hObject, handles);


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
    % hObject    handle to checkbox4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of checkbox4
    if get(hObject,'Value')==1
        Upre=handles.Upre;
        y=dtrend(Upre.outputdata,1);
        Upre=iddata(y,Upre.Inputdata,Upre.Ts);           
        for i=1:Upre.ny
            axes(handles.axes2);
            hold on
            t=Upre.samplingInstants;
            plot(t,Upre.Outputdata(:,i),'Color','bl');
            Tunit=handles.Tunit;
            yunit=handles.yunit;
            xlabel(Tunit);
            ylabel(yunit);
            hold off
        end
        tr2=1;
    else
        set(handles.checkbox3,'Value',0)
        set(handles.checkbox5,'Value',0)
        U=handles.U;
        t=U.SamplingInstants;
        Upre=handles.Upre;
        Upre=U;
        tr2=0;
        cla
        for i=1:U.nu
            axes(handles.axes1);
            cla
            hold on
            if i==1
                plot(t,U.Inputdata(:,i),'color','r');
            elseif i==2
                plot(t,U.Inputdata(:,i),'color','b');
            else
                plot(t,U.Inputdata(:,i),'color','g');
            end
            Tunit=handles.Tunit;
            uunit=handles.uunit;
            xlabel(Tunit);
            ylabel(uunit);
            hold off
        end
        for i=1:U.ny
            axes(handles.axes2);
            cla
            hold on
            if i==1
                plot(t,U.Outputdata(:,i),'Color','r');
            elseif i==2
                plot(t,U.Outputdata(:,i),'Color','b');
            else
                plot(t,U.Outputdata(:,i),'Color','g');
            end
            Tunit=handles.Tunit;
            yunit=handles.yunit;
            xlabel(Tunit);
            ylabel(yunit);
            hold off
        end
    end        
    handles.tr2=tr2;
    handles.Upre=Upre;
    guidata(hObject, handles);



% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
    % hObject    handle to checkbox5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of checkbox5
    if get(hObject,'Value')==1
        Upre=handles.Upre;
        u=dtrend(Upre.Inputdata);
        Upre=iddata(Upre.Outputdata,u,Upre.Ts);
        for i=1:Upre.nu
            axes(handles.axes1);
            t=Upre.SamplingInstants;
            hold on
            if i==1
                 plot(t,Upre.Inputdata(:,i),'color','c');
            elseif i==2
                 plot(t,Upre.Inputdata(:,i),'color','y');
            else
                 plot(t,Upre.Inputdata(:,i),'color','m');
            end
            Tunit=handles.Tunit;
            uunit=handles.uunit;
            xlabel(Tunit);
            ylabel(uunit);
            hold off
        end
        tr3=1;        
    else
        set(handles.checkbox4,'Value',0)
        set(handles.checkbox3,'Value',0)
        U=handles.U;
        Upre=handles.Upre;
        Upre=U;
        tr3=0;
        cla
        t=U.SamplingInstants;
        for i=1:U.nu
            axes(handles.axes1);
            cla
            hold on
            if i==1
                plot(t,U.Inputdata(:,i),'color','r');
            elseif i==2
                plot(t,U.Inputdata(:,i),'color','b');
            else
                plot(t,U.Inputdata(:,i),'color','g');
            end
            Tunit=handles.Tunit;
            uunit=handles.uunit;
            xlabel(Tunit);
            ylabel(uunit);
            hold off
        end
        for i=1:U.ny
            axes(handles.axes2);
            cla
            hold on
            if i==1
                plot(t,U.Outputdata(:,i),'Color','r');
            elseif i==2
                plot(t,U.Outputdata(:,i),'Color','b');
            else
                plot(t,U.Outputdata(:,i),'Color','g');
            end
            Tunit=handles.Tunit;
            yunit=handles.yunit;
            xlabel(Tunit);
            ylabel(yunit);
            hold off
        end
    end
    handles.tr3=tr3;
    handles.Upre=Upre;    
    guidata(hObject, handles);
    

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton9 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    Upre=handles.Upre;
    binf=handles.binf;
    bsup=handles.bsup;
    tr1=handles.tr1;
    tr2=handles.tr2;
    tr3=handles.tr3;
    handles.output.Upre=Upre;
    handles.output.binf=binf;
    handles.output.bsup=bsup;
    handles.output.tr1=tr1;
    handles.output.tr2=tr2;
    handles.output.tr3=tr3;
    guidata(hObject, handles);
    uiresume(handles.figure1);    
    
% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
    % hObject    handle to FileMenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
    % hObject    handle to OpenMenuItem (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    file = uigetfile('*.fig');
    if ~isequal(file, 0)
        open(file);
    end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
    % hObject    handle to PrintMenuItem (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
    % hObject    handle to CloseMenuItem (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
    if strcmp(selection,'No')
        return;
    end
    tr1=handles.tr1;
    tr2=handles.tr2;
    tr3=handles.tr3;
    Upre=handles.Upre;
    binf=handles.binf;
    bsup=handles.bsup;
    handles.output.Upre=Upre;
    handles.output.binf=binf;
    handles.output.bsup=bsup;
    handles.output.tr1=tr1;
    handles.output.tr2=tr2;
    handles.output.tr3=tr3;
    guidata(hObject, handles);
    delete(handles.figure1)

    
% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
    % hObject    handle to Save (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    saveas(gcf,'GUI_CONTSID.fig')

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
    set(handles.axes2,'Ylim',[minu(1)*1.1  maxu(1)*1.1])
    set(handles.axes1,'Ylim',[minu(1)*1.1  maxu(1)*1.1])
    guidata(hObject, handles);

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
    guidata(hObject, handles);
    
        

% --------------------------------------------------------------------
function Grid_Callback(hObject, eventdata, handles)
    % hObject    handle to Grid (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
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
    guidata(hObject, handles);


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
    guidata(hObject, handles);

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
    % hObject    handle to Help (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CONTSID_GUI_Help_Callback(hObject, eventdata, handles)
    % hObject    handle to CONTSID_GUI_Help (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton10 (see GCBO)
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


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton11 (see GCBO)
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
    e=0;
    handles.e=e;
    axes(handles.axes2);
    cla;
    t=U.SamplingInstants;
    ny=U.ny;
    for i=1:ny
        axes(handles.axes2);
        hold on
        plot(t,U.Outputdata(:,i),'Color','r');
        Tunit=handles.Tunit;
        yunit=handles.yunit;
        xlabel(Tunit);
        ylabel(yunit);
        hold off
    end
    handles.binf=binf;
    handles.bsup=bsup;
    set(handles.axes1,'Xlim',[xdatae(1) xdatav(1)])
    set(handles.axes2,'Xlim',[xdatae(1) xdatav(1)])  
    Upre=handles.Upre;
    for i=1:Upre.nu
        u=Upre.Inputdata(:,i);
        uest(:,i)=u(binf:bsup);
    end
    for i=1:Upre.ny
        y=Upre.Outputdata(:,i);
        yest(:,i)=y(binf:bsup);
    end      
    Upre=iddata(yest,uest,Upre.Ts);
    handles.Upre=Upre;
    for i=1:U.nu
        u=U.Inputdata(:,i);
        uest(:,i)=u(binf:bsup);
    end
    set(handles.checkbox3,'value',0)
    set(handles.checkbox4,'value',0)
    set(handles.checkbox5,'value',0)    
    guidata(hObject, handles);


