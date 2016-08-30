function varargout = contsidgui1(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @contsidgui1_OpeningFcn, ...
                       'gui_OutputFcn',  @contsidgui1_OutputFcn, ...
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

% --- Executes just before contsidgui1 is made visible.
function contsidgui1_OpeningFcn(hObject, eventdata, handles, varargin)
    warning off all
    clc;
    i=1;
    handles.ws.i=i;
    axes(handles.axes1);
    I = imread('contsid_ray-tracing_medium.jpeg');
    imshow(I)
    tr1=0;handles.ws.tr1=tr1;
    tr2=0;handles.ws.tr2=tr2;
    tr3=0;handles.ws.tr3=tr3;
    handles.output = hObject;
    guidata(hObject, handles);
    
    
% --- Outputs from this function are returned to the command line.
function varargout = contsidgui1_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;
    
% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
    if get(hObject,'Value')==1 
        set(handles.radiobutton2,'Value',0) 
    end
    if (isfield(handles.ws,'Ucraw'))
        set(handles.pushbutton2,'Enable','on');
        set(handles.pushbutton1,'Enable','on');
    else
        set(handles.pushbutton2,'Enable','on');
        set(handles.pushbutton1,'Enable','off');
    end
    guidata(hObject, handles);
    
% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
    if get(hObject,'Value')==1 
        set(handles.radiobutton1,'Value',0)
    end
    if get(handles.radiobutton1,'Value')==0 
        set(hObject,'Value',1)
    end
    if (isfield(handles.ws,'Uraw'))
        set(handles.pushbutton1,'Enable','on');
        set(handles.pushbutton2,'Enable','on');
        set(handles.popupmenu1,'Enable','on');
    else
        set(handles.pushbutton2,'Enable','on');
        set(handles.pushbutton1,'Enable','off');
        set(handles.popupmenu1,'Enable','off');
    end
    guidata(hObject, handles);
    
function edit1_Callback(hObject, eventdata, handles)
    
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
    Upre=handles.ws.Upre;
    reg=handles.ws.reg;
    if (get(hObject,'value')==1)
        set(handles.pushbutton6,'Enable','off');
        set(handles.pushbutton7,'Enable','off');
        set(handles.popupmenu2,'Enable','off');
        set(handles.popupmenu3,'Enable','off');
        set(handles.popupmenu4,'Enable','off');
        set(handles.text3,'Visible','off');
        set(handles.edit1,'Visible','off');
        set(handles.pushbutton14,'Visible','off');
        set(handles.text2,'string','  ');   
    end
    if (get(hObject,'value')==2)&&(Upre.nu==1)&&(reg==1)
        set(handles.popupmenu2,'string',{'--Structure--','CT OE','CT ARX'});
        set(handles.pushbutton6,'Enable','on');
        set(handles.pushbutton7,'Enable','on');
        set(handles.popupmenu2,'Enable','on');
        set(handles.popupmenu2,'value',2);
        set(handles.text3,'Visible','off');
        set(handles.edit1,'Visible','off');
        set(handles.pushbutton14,'Visible','off');
        set(handles.text2,'string','Continuous-time IDPOLY model: y(t)=[B(p)/F(p)]u(t)+e(t)');
        set(handles.popupmenu4,'string',{'srivc','coe'});
        set(handles.popupmenu4,'value',1);
        set(handles.popupmenu3,'string',{'--Initiation method--','initiated from ivgpmf','initiated from lssvf','initiated from sriv'});
        set(handles.popupmenu3,'value',4);        
        set(handles.popupmenu3,'Enable','on');
        set(handles.popupmenu4,'Enable','on');
    elseif (get(hObject,'value')==2)&&(Upre.nu==1)&&(reg==0)
        set(handles.popupmenu2,'string',{'--Structure--','CT OE','CT ARX'});
        set(handles.pushbutton6,'Enable','on');
        set(handles.pushbutton7,'Enable','on');
        set(handles.popupmenu2,'Enable','on');
        set(handles.popupmenu2,'value',2);
        set(handles.text3,'Visible','on');
        set(handles.edit1,'Visible','on','Enable','on');
        set(handles.pushbutton14,'Visible','on');
        set(handles.text2,'string','Continuous-time IDPOLY model: y(t)=[B(s)/F(s)]u(t)+e(t)');
        set(handles.popupmenu4,'string',{'srivc'});
        set(handles.popupmenu4,'value',1);
        set(handles.popupmenu3,'string',{'--Initiation method--','initiated from ivgpmf'});
        set(handles.popupmenu3,'value',2);        
        set(handles.popupmenu3,'Enable','on');
        set(handles.popupmenu4,'Enable','on');        
    elseif (get(hObject,'value')==2)&&(Upre.nu==2)&&(reg==1)
        set(handles.popupmenu2,'string',{'--Structure--','CT OE'});
        set(handles.pushbutton6,'Enable','on');
        set(handles.pushbutton7,'Enable','on');
        set(handles.popupmenu2,'Enable','on');
        set(handles.popupmenu2,'value',2);
        set(handles.text3,'Visible','off');
        set(handles.edit1,'Visible','off');
        set(handles.pushbutton14,'Visible','off');
        set(handles.text2,'string','Continuous-time IDPOLY model: y(t)=[B(s)/F(s)]u(t)+e(t)');
        set(handles.popupmenu4,'string',{'srivc','coe'});
        set(handles.popupmenu4,'value',1);
        set(handles.popupmenu3,'string',{'--Initiation method--','initiated from ivgpmf','initiated from lssvf','by using the DT sriv'});
        set(handles.popupmenu3,'value',4); 
        set(handles.popupmenu3,'Enable','on');
        set(handles.popupmenu4,'Enable','on');      
    elseif (get(hObject,'value')==2)&&(Upre.nu==2)&&(reg==0)
        set(handles.popupmenu2,'string',{'--Structure--','CT OE'});
        set(handles.pushbutton6,'Enable','on');
        set(handles.pushbutton7,'Enable','on');
        set(handles.popupmenu2,'Enable','on');
        set(handles.popupmenu2,'value',2);
        set(handles.text3,'Visible','on');
        set(handles.edit1,'Visible','on','Enable','on');
        set(handles.pushbutton14,'Visible','off');
        set(handles.text2,'string','Continuous-time IDPOLY model: y(t)=[B(s)/F(s)]u(t)+e(t)');
        set(handles.popupmenu4,'string',{'srivc','coe'});
        set(handles.popupmenu4,'value',1);
        set(handles.popupmenu3,'string',{'--Initiation method--','initiated from ivgpmf'});
        set(handles.popupmenu3,'value',2); 
        set(handles.popupmenu3,'Enable','on');
        set(handles.popupmenu4,'Enable','on');      
    end
    Upre=handles.ws.Upre;
    if (get(handles.popupmenu1,'value')==2) & (Upre.nu==1) & (reg==1)
        set(handles.pushbutton8,'Enable','on');
    else
        set(handles.pushbutton8,'Enable','off');
    end  
    set(handles.pushbutton9,'Enable','off');

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
    reg=handles.ws.reg;
    Upre=handles.ws.Upre;
    if (get(hObject,'value')==1)
        set(handles.pushbutton6,'Enable','off');
        set(handles.pushbutton7,'Enable','off');
        set(handles.text3,'Visible','off');
        set(handles.edit1,'Visible','off');
        set(handles.pushbutton14,'Visible','off');
        set(handles.text2,'string','  ');         
        set(handles.popupmenu3,'Enable','off');
        set(handles.popupmenu4,'Enable','off');
        set(handles.pushbutton8,'Enable','off');
        set(handles.pushbutton9,'Enable','off');
    else
        set(handles.pushbutton6,'Enable','on');
        set(handles.pushbutton7,'Enable','on');
        if (get(handles.popupmenu1,'value')==2) & (Upre.nu==1) & (reg==1)
            set(handles.pushbutton8,'Enable','on');
        else
            set(handles.pushbutton8,'Enable','off');
        end
        set(handles.popupmenu4,'Enable','on');
        set(handles.popupmenu3,'Enable','on');
        set(handles.pushbutton9,'Enable','off');
    end
    if (get(hObject,'value')==3)&&(get(handles.popupmenu1,'value')==2)&&(reg==1)
        set(handles.text2,'string','Continuous-time IDPOLY model: A(s)y(t)=B(s)u(t)+e(t)');
        set(handles.popupmenu4,'string',{'--L transformation--','svf','gpmf','fmf','hmf','lif','rpm'});
        set(handles.popupmenu3,'string',{'--Estimation method--','Least Squares (LS)','Instrumental Variable (IV)'});
        set(handles.popupmenu4,'value',2);
        set(handles.popupmenu3,'value',3);
        set(handles.popupmenu3,'Enable','on');
        set(handles.text3,'Visible','on');
        set(handles.edit1,'Visible','on');
        set(handles.edit1,'Enable','on');
    elseif (get(hObject,'value')==3)&&(get(handles.popupmenu1,'value')==2)&&(reg==0)
        set(handles.text2,'string','Continuous-time IDPOLY model: A(s)y(t)=B(s)u(t)+e(t)');
        set(handles.popupmenu4,'string',{'--L transformation--','gpmf'});
        set(handles.popupmenu3,'string',{'--Estimation method--','Least Squares (LS)','Instrumental Variable (IV)'});
        set(handles.popupmenu4,'value',1);
        set(handles.popupmenu3,'value',3);
        set(handles.popupmenu3,'Enable','on');
        set(handles.text3,'Visible','on');
        set(handles.pushbutton14,'Visible','on');
        set(handles.edit1,'Visible','on');
        set(handles.edit1,'Enable','on');
    end
    if (get(hObject,'value')==2)&&(get(handles.popupmenu1,'value')==2)&&(reg==1)
        set(handles.popupmenu4,'string',{'srivc','coe'});
        set(handles.text2,'string','Continuous-time IDPOLY model: y(t)=[B(s)/F(s)]u(t)+e(t)'); 
        set(handles.popupmenu4,'value',1);
        set(handles.popupmenu3,'string',{'--Initiation method--','initiated from ivgpmf','initiated from lssvf','initiated from sriv'});
        set(handles.popupmenu3,'value',4);
        set(handles.text3,'Visible','off');
        set(handles.edit1,'Visible','off');  
        set(handles.pushbutton14,'Visible','off');
        set(handles.edit1,'Enable','off');    
    elseif (get(hObject,'value')==2)&&(get(handles.popupmenu1,'value')==2)&&(reg==0)
        set(handles.popupmenu4,'string',{'srivc'});
        set(handles.text2,'string','Continuous-time IDPOLY model: y(t)=[B(s)/F(s)]u(t)+e(t)'); 
        set(handles.popupmenu4,'value',1);
        set(handles.popupmenu3,'string',{'--Initiation method--','initiated from ivgpmf'});
        set(handles.popupmenu3,'value',2);
        set(handles.text3,'Visible','on');
        set(handles.edit1,'Visible','on');  
        set(handles.pushbutton14,'Visible','on');
        set(handles.edit1,'Enable','on');    
    end
    set(handles.text1,'String',' ');

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
    reg=handles.ws.reg;
    if (get(handles.popupmenu2,'value')==2)&&(get(handles.popupmenu4,'value')==1)&&(reg==1)&&(get(handles.popupmenu3,'value')==4)
        set(handles.text3,'Visible','off');
        set(handles.edit1,'Visible','off');
        set(handles.pushbutton14,'Visible','off');
        set(handles.edit1,'Enable','off');
    else
        set(handles.text3,'Visible','on');
        set(handles.edit1,'Visible','on');
        set(handles.edit1,'Enable','on');
        set(handles.pushbutton14,'Visible','on');
    end
    set(handles.text1,'String',' ');
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
    reg=handles.ws.reg;
    if (get(handles.popupmenu2,'value')==2)&&(get(hObject,'value')==1)&&(reg==1)
        set(handles.popupmenu3,'string',{'--Initiation method--','initiated from ivgpmf','initiated from lssvf','initiated from sriv'});
        set(handles.popupmenu3,'Value',4)
    elseif (get(handles.popupmenu2,'value')==2)&&(get(hObject,'value')==1)&&(reg==0)
        set(handles.popupmenu3,'string',{'--Initiation method--','initiated from ivgpmf'});
        set(handles.popupmenu3,'Value',2)
    end
    if (get(handles.popupmenu2,'value')==2)&&(get(hObject,'value')==1)&&(reg==1)&&(get(handles.popupmenu3,'value')==4)        
        set(handles.text3,'Visible','off');
        set(handles.edit1,'Visible','off','Enable','off');
        set(handles.pushbutton14,'Visible','off');
    elseif (get(handles.popupmenu2,'value')==2)&&(get(hObject,'value')==2)&&(reg==1)
        set(handles.popupmenu3,'string',{'--Initiation method--','initiated from ivgpmf'}); 
        set(handles.popupmenu3,'Value',2)
        set(handles.text3,'Visible','on');
        set(handles.edit1,'Visible','on','Enable','on');
        set(handles.pushbutton14,'Visible','on');
    else
        set(handles.text3,'Visible','on');
        set(handles.edit1,'Visible','on');
        set(handles.edit1,'Enable','on');
        set(handles.pushbutton14,'Visible','on');
    end
    set(handles.text1,'String',' ');
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
    gui_result=handles.ws.gui_result;
    Uest=handles.ws.Uest;
    plc=get(handles.popupmenu7,'value');
    h=handles.ws.h;
    plc=h-plc+1;
    M=gui_result(plc).Estimated_model;
    %r=betarnd(1,0.9,[1 3]);
    r=rand(1, 3);
    if isfield(handles.ws,'binfe')
        binfe=handles.ws.binfe;
        bsupe=handles.ws.bsupe;
        Test=Uest.SamplingInstants(binfe:bsupe);
    else
        Test=Uest.SamplingInstants;
    end
    if isempty(gui_result)
        errordlg('You have no models to plot', ...
            'Incorrect Selection','modal')
        return
    else    
    if (get(hObject,'value')==1)|(get(hObject,'value')==2)|(get(hObject,'value')==5)|(get(hObject,'value')==6)|(get(hObject,'value')==7)
        set(handles.popupmenu6,'enable','off');
    elseif (get(hObject,'value')==3)
        set(handles.popupmenu6,'enable','on');
        set(handles.popupmenu6,'string',{'-Transient plot type-','Step response','Impulse response'});
    else
        set(handles.popupmenu6,'enable','on');
        set(handles.popupmenu6,'string',{'-Frequency plot type-','Bode diagram','Nyquist diagram'});
    end
    if (get(hObject,'value')==2)
        hcomp = findobj('Tag','comp');
        if isempty(hcomp)
            figure('NumberTitle','off','Name','Model output','Tag','comp');
            lcomp={};
        else
            figure(hcomp);
            lcomp=handles.ws.lcomp;
        end        
        hold on
        if isfield(handles.ws,'binfe')
            binfe=handles.ws.binfe;
            bsupe=handles.ws.bsupe;
            [ys,estInfo]=comparec(Uest,M,binfe:bsupe);
            e = Uest.outputdata(binfe:bsupe,1) - ys;
            plot(Test,Uest.outputdata,'color','r')
            plot(Test,ys,'color',r)
            Teunit=handles.ws.Teunit;
            yeunit=handles.ws.yeunit;
            xlabel(Teunit);
            ylabel(yeunit);            
        else
            [ys,estInfo]=comparec(Uest,M);
            e = Uest.outputdata(:,1) - ys;
            plot(Test,Uest.outputdata,'color','r')
            plot(Test,ys,'color',r)
            Teunit=handles.ws.Teunit;
            yeunit=handles.ws.yeunit;
            xlabel(Teunit);
            ylabel(yeunit);
        end
        RT2 = estInfo.RT2;
        if get(handles.popupmenu2,'value')==2
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).L_transformation,'-',gui_result(plc).Estimation_method,'-R_T^2 = ',num2str(RT2,3));
        else
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).Estimation_method,gui_result(plc).L_transformation,'-R_T^2 = ',num2str(RT2,3));
        end  
        if isempty(lcomp)
            lcomp={'Measured output',l};
        else
            lcomp={lcomp{:},l};
        end
        handles.ws.lcomp=lcomp;
        legend(lcomp,'Location','Best')
        hold off
    end
    if (get(hObject,'value')==5)
        hpz = findobj('Tag','pz');
        if isempty(hpz)
             figure('NumberTitle','off','Name','Zero pole plot','Tag','pz');
        else
            figure(hpz);
        end
        hold on
        if (get(handles.popupmenu2,'Value') == 2)
            for j=1:1:Uest.ny
                for i=1:1:Uest.nu
                    subplot(Uest.ny,Uest.nu,i)
                    pzmap(M.b(i,:),M.f(i,:))
                    title(['From u',int2str(i)])
                    ylabel(['To y', int2str(Uest.ny)])
                end
            end
        elseif (get(handles.popupmenu2,'Value') == 3)
            for j=1:1:Uest.ny
                for i=1:1:Uest.nu
                    subplot(Uest.ny,Uest.nu,i)
                    pzmap(M.b(i,:),M.a(i,:))
                    title(['From u',int2str(i)])
                    ylabel(['To y', int2str(Uest.ny)])
                end
            end
        end
        if get(handles.popupmenu2,'value')==2
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).L_transformation,'-',gui_result(plc).Estimation_method);
        else
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).Estimation_method,gui_result(plc).L_transformation);
        end                   
        legend(l,'Location','Best')
        hold off
     end
     if (get(hObject,'value')==6)      
        hres = findobj('Tag','res');
        if isempty(hres)
            figure('NumberTitle','off','Name','Residual plot','Tag','res');
            lres={};
        else
            figure(hres);
            lres=handles.ws.lres;
        end
        hold on
        e=residc(Uest,M);
        plot(Test,e,'color',r)
        Teunit=handles.ws.Teunit;
        yeunit=handles.ws.yeunit;
        xlabel(Teunit);
        ylabel(yeunit);
        if get(handles.popupmenu2,'value')==2
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).L_transformation,'-',gui_result(plc).Estimation_method);
        else
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).Estimation_method,gui_result(plc).L_transformation);
        end 
        if isempty(lres)
            lres={l};
        else
            lres={lres{:},l};
        end
        handles.ws.lres=lres;
        legend(lres,'Location','Best')
        hold off
     end
     if (get(hObject,'value')==7)
        hana = findobj('Tag','ana');
        if isempty(hana)
            figure('NumberTitle','off','Name','Correlation test','Tag','ana');
        else
%            figure(hres);
            figure(hana);
        end        
%        hold on
        cor(Uest,M);
        if get(handles.popupmenu2,'value')==2
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).L_transformation,'-',gui_result(plc).Estimation_method);
        else
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).Estimation_method,gui_result(plc).L_transformation);
        end 
 %       legend(l,'Location','Best')
 %       hold off
     end
    end
    guidata(hObject, handles);
    warning on all

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
    plc=get(handles.popupmenu7,'value');
    h=handles.ws.h;
    plc=h-plc+1;
    gui_result=handles.ws.gui_result;
    M=gui_result(plc).Estimated_model;
    Uest=handles.ws.Uest;
    %r=betarnd(1,0.9,[1 3]);
    r=rand(1,3);
    if isfield(handles.ws,'binfe')
        binfe=handles.ws.binfe;
        bsupe=handles.ws.bsupe;
        Test=Uest.SamplingInstants(binfe:bsupe);
    else
        Test=Uest.SamplingInstants;
    end
    if (get(handles.popupmenu5,'value')==3)&&(get(hObject,'value')==2)
        hstep = findobj('Tag','step');
        if isempty(hstep)
            figure('NumberTitle','off','Name','Step response','Tag','step');
            lstep={};
        else
            figure(hstep);
            lstep=handles.ws.lstep;
        end
        hold on
        warning off
        [y,t]=step(M);
        for j=1:1:Uest.ny
            for i=1:1:Uest.nu
                subplot(Uest.ny,Uest.nu,i)
                plot(t,y(:,:,i),'color',r);
                title(['From u',int2str(i)])
                xlabel(['To y', int2str(Uest.ny)])
            end
        end        
        if get(handles.popupmenu2,'value')==2
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).L_transformation,'-',gui_result(plc).Estimation_method);
        else
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).Estimation_method,gui_result(plc).L_transformation);
        end
        if isempty(lstep)
            lstep={l};
        else
            lstep={lstep{:},l};
        end
        handles.ws.lstep=lstep;
        legend(lstep,'Location','Best')
        hold off
    end
    if (get(handles.popupmenu5,'value')==3)&&(get(hObject,'value')==3)
        himp = findobj('Tag','impulse');
        if isempty(himp)
            figure('NumberTitle','off','Name','Impulse response','Tag','impulse');
            limp={};
        else
            figure(himp);
            limp=handles.ws.limp;
        end
        hold on
        [y,t]=impulse(M);
        for j=1:1:Uest.ny
            for i=1:1:Uest.nu
                subplot(Uest.ny,Uest.nu,i)
                plot(t,y(:,:,i),'color',r);
                title(['From u',int2str(i)])
                xlabel(['To y', int2str(Uest.ny)])
            end
        end
        if get(handles.popupmenu2,'value')==2
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).L_transformation,'-',gui_result(plc).Estimation_method);
        else
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).Estimation_method,gui_result(plc).L_transformation);
        end 
        if isempty(limp)
            limp={l};
        else
            limp={limp{:},l};
        end
        handles.ws.limp=limp;
        legend(limp,'Location','Best')
        hold off
    end
    if (get(handles.popupmenu5,'value')==4)&&(get(hObject,'value')==2)
        hbode = findobj('Tag','bode');
        if isempty(hbode)
            figure('NumberTitle','off','Name','Bode diagram','Tag','bode');;
        else
            figure(hbode);
        end
        hold on
        warning off
        bode(M)
        if get(handles.popupmenu2,'value')==2
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).L_transformation,'-',gui_result(plc).Estimation_method);
        else
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).Estimation_method,gui_result(plc).L_transformation);
        end 
        legend(l,'Location','Best')
        hold off
    end
    if (get(handles.popupmenu5,'value')==4)&&(get(hObject,'value')==3)
        hnyq = findobj('Tag','nyq');
        if isempty(hnyq)
            figure('NumberTitle','off','Name','Nyquist diagram','Tag','nyq');
        else
            figure(hnyq);
        end
        hold on
        nyquist(M);
        if get(handles.popupmenu2,'value')==2
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).L_transformation,'-',gui_result(plc).Estimation_method);
        else
            l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).Estimation_method,gui_result(plc).L_transformation);
        end 
        legend(l,'Location','Best')
        hold off
    end
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    if get(handles.radiobutton2,'value')==1
        Uraw=handles.ws.Uraw;
        tr1=handles.ws.tr1;
        tr2=handles.ws.tr2;
        tr3=handles.ws.tr3;
        yeunit=handles.ws.yeunit;
        ueunit=handles.ws.ueunit;
        Teunit=handles.ws.Teunit;        
        data=Plot_data(Uraw,yeunit,ueunit,Teunit,tr1,tr2,tr3);
        if isempty(data)
            return;
        end        
        Upre=data.Upre;
        binfe=data.binf;
        bsupe=data.bsup;
        tr1=data.tr1;
        tr2=data.tr2;
        tr3=data.tr3;
        handles.ws.tr1=tr1;
        handles.ws.tr2=tr2;
        handles.ws.tr3=tr3;
        Uest=Upre;
        Uval=Upre;
        handles.ws.binfe=binfe;
        handles.ws.bsupe=bsupe;
        handles.ws.Upre=Upre;
        handles.ws.Uest=Uest;
        handles.ws.Uval=Uval;
        if isfield(handles.ws,'gui_result')
            clc
            gui_result=handles.ws.gui_result;
            rmfield(handles.ws,'gui_result');
            mpl=handles.ws.mpl;
            mpl=[];    
            set(handles.popupmenu7,'string','No model to plot');
            i=1;
            handles.ws.i=i;
            handles.ws.mpl=mpl;
            set(handles.popupmenu7,'Value',1);
            set(handles.popupmenu7,'Enable','off');
            set(handles.popupmenu3,'Enable','off');
            set(handles.popupmenu2,'Enable','off');
            set(handles.popupmenu4,'Enable','off');
            set(handles.popupmenu5,'Enable','off');
            set(handles.popupmenu6,'Enable','off');
            set(handles.pushbutton6,'Enable','off');
            set(handles.pushbutton7,'Enable','off');
            set(handles.pushbutton8,'Enable','off');
            set(handles.pushbutton9,'Enable','off');
            set(handles.pushbutton11,'Enable','off');
            set(handles.pushbutton10,'Enable','off');
            set(handles.pushbutton12,'Enable','off');
            set(handles.pushbutton13,'Enable','off');
            set(handles.edit1,'Enable','off');
            set(handles.text1,'string','  ')
        end
    else
        Ucraw=handles.ws.Ucraw;
        ycunit=handles.ws.ycunit;
        ucunit=handles.ws.ucunit;
        Tcunit=handles.ws.Tcunit;
        data=Plot_data(Ucraw,ycunit,ucunit,Tcunit,tr1,tr2,tr3);
        if isempty(data)
            return;
        end
        Ucpre=data.Upre;
        binfv=data.binf;
        bsupv=data.bsup;
        Ucest=Ucpre;
        Ucval=Ucpre;
        handles.ws.binfv=binfv;
        handles.ws.bsupv=bsupv;
        handles.ws.Ucpre=Ucpre;
        handles.ws.Ucest=Ucest;
        handles.ws.Ucval=Ucval;
    end
    guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
    [data_file,PathName] = uigetfile('*.mat','Select the mat-file-data');
    if isempty(data_file)|(data_file==0)
        return;
    end
    %guidata(hObject, handles);
    data=load([PathName,data_file]);
    handles.ws.data=data;
    %guidata(hObject, handles);
    if get(handles.radiobutton2,'value')==1
        donnees=Choose_variables(data);
        if isempty(donnees)
            guidata(hObject, handles);
            return;
        end
        if isfield(handles.ws,'gui_result')
            clc
            gui_result=handles.ws.gui_result;
            rmfield(handles.ws,'gui_result');
            mpl=handles.ws.mpl;
            mpl=[];    
            set(handles.popupmenu7,'string','No model to plot');
            i=1;
            handles.ws.i=i;
            handles.ws.mpl=mpl;
            set(handles.popupmenu7,'Value',1);
            set(handles.popupmenu7,'Enable','off');
            set(handles.popupmenu3,'Enable','off');
            set(handles.popupmenu2,'Enable','off');
            set(handles.popupmenu4,'Enable','off');
            set(handles.popupmenu5,'Enable','off');
            set(handles.popupmenu6,'Enable','off');
            set(handles.pushbutton1,'Enable','off');
            set(handles.pushbutton6,'Enable','off');
            set(handles.pushbutton7,'Enable','off');
            set(handles.pushbutton8,'Enable','off');
            set(handles.pushbutton9,'Enable','off');
            set(handles.pushbutton11,'Enable','off');
            set(handles.pushbutton10,'Enable','off');
            set(handles.pushbutton12,'Enable','off');
            set(handles.pushbutton13,'Enable','off');
            set(handles.edit1,'Enable','off');
            set(handles.text1,'string','  ')
        end
        Uraw=donnees.U;
        reg=donnees.reg;
        yeunit=donnees.yunit;
        ueunit=donnees.uunit;
        Teunit=donnees.Tunit;
        Upre=Uraw;
        Uest=Uraw;
        Uval=Uraw;
        Test=Uest.SamplingInstants;
        handles.ws.Test=Test;
        handles.ws.reg=reg;
        handles.ws.Uest=Uest;
        handles.ws.Uval=Uval;
        handles.ws.Upre=Upre;
        handles.ws.Uraw=Uraw;
        handles.ws.yeunit=yeunit;
        handles.ws.ueunit=ueunit;
        handles.ws.Teunit=Teunit;
    else
        donnees=Choose_variables(data);
        if isempty(donnees)
            return;
        end
        Ucraw=donnees.U;
        Ucpre=Ucraw;
        Ucest=Ucraw;
        ycunit=donnees.yunit;
        ucunit=donnees.uunit;
        Tcunit=donnees.Tunit;
        handles.ws.ycunit=ycunit;
        handles.ws.ucunit=ucunit;
        handles.ws.Tcunit=Tcunit;        
        handles.ws.Ucest=Ucest;
        handles.ws.Ucpre=Ucpre;
        handles.ws.Ucraw=Ucraw;
        if isfield(handles.ws,'gui_result')
            set(handles.pushbutton11,'Enable','on');
            set(handles.pushbutton10,'Enable','on');
            set(handles.pushbutton13,'Enable','on');
        end
    end
    set(handles.radiobutton1,'Enable','on');
    set(handles.pushbutton1,'Enable','on');
    set(handles.popupmenu1,'Enable','on');
    set(handles.popupmenu1,'Value',1);
    guidata(hObject, handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
    set(handles.text1,'string','  ');
    reg=handles.ws.reg;
    Uest=handles.ws.Uest;
    Uval=handles.ws.Uval;
    nf=0;
    s=0;
    if (get(handles.popupmenu2,'Value') == 2)
        nf=1;
    end
    N=TF_order_select(Uest,Uval,nf,reg);
    if isempty(N)
        return;
    end
    handles.ws.N=N;
    set(handles.pushbutton9,'Enable','on');
    guidata(hObject, handles);
    
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
    Uest=handles.ws.Uest;
    Uval=handles.ws.Uval;
    reg=handles.ws.reg;
    nf=0;
    if (get(handles.popupmenu1,'Value') == 2) 
        if (get(handles.popupmenu2,'Value') == 2)
            nf=1;
        end
        TF_order_estimation(Uest,Uval,nf,reg);
    end    
    guidata(hObject, handles);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
    Delay_estimation
    figure('NumberTitle','off','Name','Impulse response estimation');
    Upre=handles.ws.Upre;
    cra(Upre);
    guidata(hObject, handles);

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
    set(handles.text1,'string','In progress ...');
    guidata(hObject, handles);
    lambda=str2num(get(handles.edit1,'string'));
    reg=handles.ws.reg;
    Uest=handles.ws.Uest;
    Uval=handles.ws.Uval;
    N=handles.ws.N;    
    if (((get(handles.popupmenu2,'value')==3) && (isempty(get(handles.edit1,'string')))))|((get(handles.popupmenu2,'value')==2) && (get(handles.popupmenu4,'value')==1) && (reg==0) && (isempty(get(handles.edit1,'string'))))|((get(handles.popupmenu2,'value')==2) && (get(handles.popupmenu4,'value')==2) && (isempty(get(handles.edit1,'string'))))|((get(handles.popupmenu2,'value')==2)&&(get(handles.popupmenu4,'value')==1)&& (reg==1)&&(get(handles.popupmenu3,'value')~=4)&&(isempty(get(handles.edit1,'string'))))|(~isempty(get(handles.edit1,'string'))&&(str2num(get(handles.edit1,'string'))<=0)&&(get(handles.popupmenu2,'value')==2)&&(get(handles.popupmenu4,'value')==1)&& (reg==1)&&(get(handles.popupmenu3,'value')~=4))|(~isempty(get(handles.edit1,'string'))&&(str2num(get(handles.edit1,'string'))<=0)&&((get(handles.popupmenu2,'value')==2)&&(get(handles.popupmenu4,'value')==2)&&(reg==1)))
        errordlg('You must enter correctly the user parameter',...
            'Incorrect Selection','modal')
            return  
    end
    if (get(handles.popupmenu2,'value')==2)&&(get(handles.popupmenu3,'value')==1)
        errordlg('You must select the initiation method',...
            'Incorrect Selection','modal')
            return  
    end
    if (get(handles.popupmenu2,'value')==3)
        if ((get(handles.popupmenu4,'value')==1)|(get(handles.popupmenu3,'value')==1))
            p=0;
        elseif ((get(handles.popupmenu4,'value')==2)&&(get(handles.popupmenu3,'value')==2))
            p=11;
        elseif ((get(handles.popupmenu4,'value')==3)&&(get(handles.popupmenu3,'value')==2))
            p=21;
        elseif ((get(handles.popupmenu4,'value')==4)&&(get(handles.popupmenu3,'value')==2))
            p=31;
        elseif ((get(handles.popupmenu4,'value')==5)&&(get(handles.popupmenu3,'value')==2))
            p=41;
        elseif ((get(handles.popupmenu4,'value')==6)&&(get(handles.popupmenu3,'value')==2))
            p=51;
        elseif ((get(handles.popupmenu4,'value')==7)&&(get(handles.popupmenu3,'value')==2))
            p=61;
        elseif ((get(handles.popupmenu4,'value')==2)&&(get(handles.popupmenu3,'value')==3))
            p=12;
        elseif ((get(handles.popupmenu4,'value')==3)&&(get(handles.popupmenu3,'value')==3))
            p=22;   
        elseif ((get(handles.popupmenu4,'value')==4)&&(get(handles.popupmenu3,'value')==3))
            p=32;
        elseif ((get(handles.popupmenu4,'value')==5)&&(get(handles.popupmenu3,'value')==3))
            p=42;
        elseif ((get(handles.popupmenu4,'value')==6)&&(get(handles.popupmenu3,'value')==3))
            p=52;
        elseif ((get(handles.popupmenu4,'value')==7)&&(get(handles.popupmenu3,'value')==3))
            p=62;
        end        
        switch p
            case 0
                errordlg('You must select the linear transformation and/or the estimation method',...
            'Incorrect Selection','modal')
            return
            case 11
                M=lssvf(Uest,N,lambda);
            case 21
                M=lsgpmf(Uest,N,lambda);
            case 31
                M=lsfmf(Uest,N,lambda);
            case 41
                M=lshmf(Uest,N,lambda);
            case 51
                M=lslif(Uest,N,lambda);
            case 61
                M=lsrpm(Uest,N,lambda);
            case 12
                M=ivsvf(Uest,N,lambda);
            case 22
                M=ivgpmf(Uest,N,lambda);
            case 32
                M=ivfmf(Uest,N,lambda);
            case 42
                M=ivhmf(Uest,N,lambda);
            case 52
                M=ivlif(Uest,N,lambda);
            case 62
                M=ivrpm(Uest,N,lambda);
        end
    end
    % keyboard
    if (get(handles.popupmenu2,'value')==2)&&(get(handles.popupmenu4,'value')==1)&& (reg==1)&&(get(handles.popupmenu3,'value')==4)
        M=srivc(Uest,N);
    elseif (get(handles.popupmenu2,'value')==2)&&(get(handles.popupmenu4,'value')==1)&& (reg==0)&&(get(handles.popupmenu3,'value')==2)
        M=srivc(Uest,N,'lambda',lambda);
    elseif (get(handles.popupmenu2,'value')==2)&&(get(handles.popupmenu4,'value')==1)&& (reg==1)&&(get(handles.popupmenu3,'value')==2)
        M=srivc(Uest,N,'lambda',lambda,'InitMethod','ivgpmf');
    elseif (get(handles.popupmenu2,'value')==2)&&(get(handles.popupmenu4,'value')==1)&& (reg==1)&&(get(handles.popupmenu3,'value')==3)        
        M=srivc(Uest,N,'lambda',lambda,'InitMethod','lssvf');
    end
    if (get(handles.popupmenu2,'value')==2)&&(get(handles.popupmenu4,'value')==2)&&(get(handles.popupmenu3,'value')==2) 
        M=coe(Uest,N,lambda);
%     elseif (get(handles.popupmenu2,'value')==2)&&(get(handles.popupmenu4,'value')==2)&&(get(handles.popupmenu3,'value')==3) 
%         M=coe(Uest,N,lambda,[],'lssvf');
    end
    present(M)
    s3=get(handles.popupmenu1,'String');
    v3=get(handles.popupmenu1,'value');
    s1=get(handles.popupmenu2,'String');
    v1=get(handles.popupmenu2,'value');
    s4=get(handles.popupmenu4,'String');
    v4=get(handles.popupmenu4,'value');
    s2=get(handles.popupmenu3,'String');
    v2=get(handles.popupmenu3,'value');
    if v1==2 
        l=s2(v2);
    elseif (v1==3) && (v2==2)
        l='ls';
    elseif (v1==3) && (v2==3)
        l='iv';
    end
    i=handles.ws.i;
    Ns=num2str(N);
    lambdas=num2str(lambda);
    if isfield(handles.ws,'gui_result')
        gui_result=handles.ws.gui_result;
    end
    gui_result(i) = struct('Estimated_model',M,'Model',s3(v3),'Structure',s1(v1),'Order',Ns,'L_transformation',s4(v4),'Estimation_method',l,'User_parameter',lambdas);
    handles.ws.gui_result=gui_result;
    guidata(hObject, handles);
    for j=1:length(gui_result)
        if get(handles.popupmenu2,'value')==2
            mpl{j,1}=[gui_result(j).Model,'-',gui_result(j).Structure,'-[',gui_result(j).Order,']-',gui_result(j).L_transformation,'-',gui_result(j).Estimation_method];
        else
            mpl{j,1}=[gui_result(j).Model,'-',gui_result(j).Structure,'-[',gui_result(j).Order,']-',gui_result(j).Estimation_method,gui_result(j).L_transformation];
        end
        hl=size(mpl);
        m=1;
        for k=hl(1):-1:1
            mplinv{m,1}=mpl{k,1};
            m=m+1;
        end
        set(handles.popupmenu7,'string',mplinv);
    end
    i=i+1;
    h=hl(1);
    handles.ws.h=h;
    handles.ws.mpl=mpl;
    handles.ws.i=i;
    set(handles.text1,'string','The estimated model is displayed in the workspace');
    set(handles.pushbutton12,'Enable','on');
    set(handles.popupmenu7,'Enable','on');
    if reg==1
        set(handles.popupmenu5,'String',{'--Plot type--','Model output','Transient response','Frequency response','Zero pole','Residuals','Correlation test'},'Enable','on','Value',1,'Visible','on')
    else
        set(handles.popupmenu5,'String',{'--Plot type--','Model output','Transient response','Frequency response','Zero pole','Residuals'},'Enable','on','Value',1,'Visible','on')
    end    
    if isfield(handles.ws,'Ucraw')
        set(handles.pushbutton11,'Enable','on');
        set(handles.pushbutton10,'Enable','on');
        set(handles.pushbutton13,'Enable','on');
    end
    guidata(hObject, handles);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
    plc=get(handles.popupmenu7,'value');
    gui_result=handles.ws.gui_result;
    M=gui_result(plc).Estimated_model;
    figure('NumberTitle','off','Name','Cross-validation residual plot');
    Ucpre=handles.ws.Ucpre;
    cor(Ucpre,M);
    guidata(hObject, handles);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
    Ucest=handles.ws.Ucest;
    plc=get(handles.popupmenu7,'value');
    h=handles.ws.h;
    plc=h-plc+1;
    %r=betarnd(1,0.9,[1 3]);
    r=rand(1,3);
    gui_result=handles.ws.gui_result;
    M=gui_result(plc).Estimated_model;
    hcompc = findobj('Tag','compc');
    if isempty(hcompc)
        figure('NumberTitle','off','Name','Cross-validation model output','Tag','compc');
        lcompc={'Measured output'};
    else
        figure(hcompc);
        lcompc=handles.ws.lcompc;
    end      
    hold on    
    if isfield(handles.ws,'binfv')
        binfv=handles.ws.binfv;
        bsupv=handles.ws.bsupv;
        [ys,estInfo]=comparec(Ucest,M,binfv:bsupv);
        e = Ucest.outputdata(binfv:bsupv,1) - ys;
        Tcest=Ucest.SamplingInstants(binfv:bsupv);
    else
        [ys,estInfo]=comparec(Ucest,M);
        e = Ucest.outputdata - ys;
        Tcest=Ucest.SamplingInstants;
    end
    RT2 = estInfo.RT2;
    plot(Tcest,Ucest.outputdata,'color','r')
    plot(Tcest,ys,'color',r)
    Tcunit=handles.ws.Tcunit;
    ycunit=handles.ws.ycunit;
    xlabel(Tcunit);
    ylabel(ycunit);    
    if get(handles.popupmenu2,'value')==2
        l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).L_transformation,'-',gui_result(plc).Estimation_method,'-R_T^2 = ',num2str(RT2,3));
    else
        l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).Estimation_method,gui_result(plc).L_transformation,'-R_T^2 = ',num2str(RT2,3));
    end  
    lcompc={lcompc{:},l};
    handles.ws.lcompc=lcompc;
    legend(lcompc,'Location','Best')
    guidata(hObject, handles);
    hold off

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
    clc
    gui_result=handles.ws.gui_result;
    mpl=handles.ws.mpl;    
    handles.ws=rmfield(handles.ws,'gui_result');
    handles.ws=rmfield(handles.ws,'mpl');
    set(handles.popupmenu7,'string','No model to plot');
    i=1;
    handles.ws.i=i;
    set(handles.popupmenu7,'Value',1);
    set(handles.popupmenu7,'Enable','off');
    set(handles.popupmenu5,'Enable','off');
    set(handles.popupmenu6,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.text1,'string','There is no model')
    guidata(hObject, handles);


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
    plc=get(handles.popupmenu7,'value');
    h=handles.ws.h;
    plc=h-plc+1;
    gui_result=handles.ws.gui_result;
    M=gui_result(plc).Estimated_model;
    Ucest=handles.ws.Ucest;
    hresc = findobj('Tag','resc');
    %r=betarnd(1,0.9,[1 3]);
    r=rand(1,3);
    if isempty(hresc)
        figure('NumberTitle','off','Name','Cross-validation residual plot','Tag','resc');
        lresc={};
    else
        figure(hresc);
        lresc=handles.ws.lresc;
    end     
    if isfield(handles.ws,'binfv')
        binfv=handles.ws.binfv;
        bsupv=handles.ws.bsupv;
        Tval=Ucest.SamplingInstants(binfv:bsupv);
    else
        Tval=Ucest.SamplingInstants;
    end    
    hold on
    e=residc(Ucest,M);  
    plot(Tval,e,'color',r)
    if get(handles.popupmenu2,'value')==2
        l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).L_transformation,'-',gui_result(plc).Estimation_method);
    else
        l=strcat(gui_result(plc).Model,'-',gui_result(plc).Structure,'-[',gui_result(plc).Order,']-',gui_result(plc).Estimation_method,gui_result(plc).L_transformation);
    end        
    if isempty(lresc)
        lresc={l};
    else
        lresc={lresc{:},l};
    end
    handles.ws.lresc=lresc;
    legend(lresc,'Location','Best')
    Tcunit=handles.ws.Tcunit;
    ycunit=handles.ws.ycunit;
    xlabel(Tcunit);
    ylabel(ycunit);
    guidata(hObject, handles);
    hold off
    
% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
    % hObject    handle to File (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Open_session_Callback(hObject, eventdata, handles)
    file = uigetfile('*.fig');
    if ~isequal(file, 0)
        open(file);
    end

% --------------------------------------------------------------------
function New_session_Callback(hObject, eventdata, handles)
    selection = questdlg(['Close current session' '?'],...
                     ['Close '  '...'],...
                     'Yes','No','Yes');
    if strcmp(selection,'No')
        return;
    end
    if strcmp(selection,'Yes')
        selection = questdlg(['Save current session'  '?'],...
                     ['Save ? '  '...'],...
                     'Yes','No','Yes');
        if strcmp(selection,'Yes')
            [FileName,PathName]=uiputfile('*.fig','Save session as', 'contsidgui');
            saveas(gcf,[PathName,FileName]);
        end
    end
    delete(handles.figure1)
    contsidgui1

% --------------------------------------------------------------------
function Save_session_Callback(hObject, eventdata, handles)
    saveas(gcf,'ctident.fig')

% --------------------------------------------------------------------
function Save_session_as_Callback(hObject, eventdata, handles)
    [FileName,PathName]=uiputfile('*.fig','Save session as', 'ctident');
    if isempty(FileName)|(FileName==0)
        return;
    end
    saveas(gcf,[PathName,FileName])
    
% --------------------------------------------------------------------
function Window_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function contsidgui_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function CONTSID_GUI_Help_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function CONTSID_Toolbox_Help_Callback(hObject, eventdata, handles)
    contsid_toolbox_help

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Exit_CONTSIDGUI_Callback(hObject, eventdata, handles)
    selection = questdlg(['Exit CONTSIDGUI ?' '?'],...
              ['Exit ' '...'],...
              'Yes','No','Yes');
    if strcmp(selection,'No')
        return;
    end
    delete(handles.figure1)

% --------------------------------------------------------------------
function About_CONTSID_Callback(hObject, eventdata, handles)
    about_contsid

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
    if (get(handles.popupmenu2,'Value')==3) && (get(handles.popupmenu4,'Value')==6)
        f='lif';
        user_prameter(f)
    elseif (get(handles.popupmenu2,'Value')==3) && (get(handles.popupmenu4,'Value')==7)
        f='rpm';
        user_prameter(f)
    else
        f='no';
        user_prameter(f)
    end


% --------------------------------------------------------------------
function Contsidgui_Callback(hObject, eventdata, handles)
% hObject    handle to Contsidgui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


