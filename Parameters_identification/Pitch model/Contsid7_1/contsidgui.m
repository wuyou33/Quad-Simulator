      a=ver('Matlab');
    if length(a.Version)<5  % modified by HG on 24/10/2006
        a.Version(4:5)=[num2str(00)];
    end    
    if (str2num([a.Version(1:3) a.Version(5)])<7.01),  % Test of the Matlab version. The GUI needs Matlab 7.0.4 or above        
        errordlg('The GUI for the CONTSID toolbox requires Matlab version 7.0.4 or above','Version error','on');         
     else
         contsidgui1;
    end

