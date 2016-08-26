function locallim_2(action,s)
%LOCALLIM Graphical selection of a part of a signal.
%   This function is used with Subband NMR Signal Processing Toolbox.
%
%   LOCALLIM plots two delimiter red lines on the current axes which can be
%   moved using the mouse.

%   Author: El-Hadi Djermoune, 18-July-2005.
%   Last modified: 18-July-2005.

% Possible actions
%       init
%       drag

if (nargin<1)
   action='init';
end

if ~isstr(action) | strcmp(action, 'init')
   v1 = axis;
   v=v1;
   if ~isstr(action)
       v(1:2) = action(1:2);
   end
   h = line([v(1) v(1)],[v(3) v(4)]);
   set(h, 'tag', 'Limit1');
   set(h, 'linewidth', 1);
   set(h, 'color', 'b');
   set(h, 'buttondownfcn', 'locallim_2(''drag'',1)');
   h = line([v(2) v(2)],[v(3) v(4)]);
   set(h, 'tag', 'Limit2');
   set(h, 'linewidth', 1);
   set(h, 'color', 'b');
   set(h, 'buttondownfcn', 'locallim_2(''drag'',1)');

%    handles=(guidata(gcbf));
%    N=length(handles.Signal);
%    D=fix(2/(v(2)-v(1))/3);         % decimation factor
%    Np=min(N,round(N/D));           % subband signal length
%    title(['RANGE: [',num2str(v(1)),' : ',num2str(v(2)),'] - APPROX. LENGTH: ',num2str(Np)]);
   set(gca,'userdata',v1);      % save the axis limits
   return
elseif strcmp(action, 'drag'),
   % s=1 ==> down, s=2 ==> motion, s=3 ==> up
   if s==1,    % down
       set(gco, 'erasemode', 'xor');
       set(gcbf, 'pointer', 'left');
       set(gcbf, 'windowbuttonmotionfcn', 'locallim_2(''drag'', 2)');
       set(gcbf, 'windowbuttonupfcn', 'locallim_2(''drag'', 3)');
   elseif s==2,        % motion
       h = gco;
       pt = get(gca, 'currentpoint'); 
       pt_x = pt(1,1);
       h1 = findobj(gcbf, 'tag', 'Limit1'); 
       x1 = get(h1, 'xdata');
       h2 = findobj(gcbf, 'tag', 'Limit2'); 
       x2 = get(h2, 'xdata');
       v=get(gca,'userdata');
       if h==h1    % lower limit
           if pt_x<x2(1) & pt_x>=v(1)
               set(h, 'xdata', [pt_x pt_x]);
           end
       else        % upper limit
           if pt_x>x1(1) & pt_x<=v(2)
               set(h, 'xdata', [pt_x pt_x]);
           end
       end
       %title(['RANGE: [',num2str(x1(1)),' : ',num2str(x2(1)),']']);
   elseif s==3,        % up
       handles = guidata(gcbf);
       h = gco;
       x1 = get(h, 'xdata');
       h1 = findobj(gcbf, 'tag', 'Limit1');
       h2 = findobj(gcbf, 'tag', 'Limit2');
       if h==h1
           x2 = get(h2, 'xdata');
           x = [x1(1), x2(1)];
       else
           x2 = get(h1, 'xdata');
           x = [x2(1), x1(1)];
       end
       handles.LocalData.Limits=x;
       guidata(gcbf, handles);
%         N=length(handles.Signal);
%         D=max(1,fix(2/(x(2)-x(1))/3));      % decimation factor
%        Np=min(N,round(N/D));
%        title(['RANGE: [',num2str(x(1)),' : ',num2str(x(2)),'] - APPROX. LENGTH: ',num2str(Np)]);
%        title(['RANGE: [',num2str(x(1)),' : ',num2str(x(2)),']']);
       set(gcbf, 'pointer', 'arrow');
       set(gcbf, 'windowbuttonmotionfcn', '');
       set(gcbf, 'windowbuttonupfcn', '');
   end
end
