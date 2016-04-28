%% Quadcopter Simulator   %
% Author: Mattia Giurato  %
% Last review: 2015/07/12 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc
 
%% Launch SIMULATOR
tsim = 50;

% %Set point u = [-height[m] roll_a[rad] pitch_a[rad] yaw_r[rad/s]]
% U = [-1 0 -pi/6 0]';

% %Set point u = [No[m] Eo[m] -height[m] head[rad]]
 U = [0 0 -1 pi/6]';

sim Simulator

P_e = yout(: ,1:3);
V_b = yout(: ,4:6);
Ome_b = yout(: ,7:9);
Alpha_e = yout(: ,10:12);

%% Plot OUTPUT
figure('name','POSITION_EARTH')
plot(tout, P_e);
grid minor
xlabel('[s]')
ylabel('[m]')
legend('N', 'E', 'D')

figure('name','VELOCITY_BODY')
plot(tout, V_b);
grid minor
xlabel('[s]')
ylabel('[m/s]')
legend('u', 'v', 'w')

figure('name','ANGULAR SPEED_BODY')
plot(tout, Ome_b);
grid minor
xlabel('[s]')
ylabel('[rad/s]')
legend('p', 'q', 'r')
 
figure('name','ATTITUDE_EARTH')
plot(tout, Alpha_e);
grid minor
xlabel('[s]')
ylabel('[rad]')
legend('phi', 'theta', 'psi')

%% 3D Animation

global index_view;
global old_position;
droneFigure = figure('name','Plot Trajectory');
ha = axes('Parent',droneFigure);
    set(droneFigure,'menubar','figure','renderer','opengl');
    set(ha,'Visible','On','Box','On','XGrid', 'on','YGrid', 'on','ZGrid',...
        'on','projection','perspective');
hold on;
cameratoolbar('show');
axis vis3d;
view(3);
zoom(0.9);
index_view = 0;
old_position = [0 0 0];
cameratoolbar('ResetCameraAndSceneLight');

for i = 1:length(tout)
   draw_mod([P_e(i,:) Alpha_e(i,:)]);
end
drawnow;
%% 3D Animation and video making
%If you want to make a short video about the output of the simulaiton just
%uncomment the following code:
% 
% global index_view;
% global old_position;
% 
% droneFigure = figure('name','Plot Trajectory');
% ha = axes('Parent',droneFigure);
%     set(droneFigure,'menubar','figure','renderer','opengl');
%     set(ha,'Visible','On','Box','On','XGrid', 'on','YGrid', 'on','ZGrid',...
%         'on','projection','perspective');
% hold on;
% cameratoolbar('show');
% axis vis3d;
% view(3);
% zoom(0.9);
% 
% index_view = 0;
% old_position = [0 0 0];
% 
% quadmovie = VideoWriter('quad.avi');
% quadmovie.FrameRate = 10;
% open(quadmovie);
% 
% cameratoolbar('ResetCameraAndSceneLight');
% for i = 1:length(tout)
%     draw_mod([P_e(i,:), Alpha_e(i,:)]);
%     F = getframe;
%     writeVideo(quadmovie,F)
% end
% drawnow;
% close(quadmovie);

 %% End of code