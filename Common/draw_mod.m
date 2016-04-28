function draw_mod(input)
% ----------------------------------------------------
% Draws the quadrotor in 3 dimensions during the simulation.
% This script is invoked once for each animation frame.
% ----------------------------------------------------
%#codegen

global old_position;
global index_view;
global quad;

x = input(1);
y = -input(2);
z = -input(3);
phi = input(4);
theta = -input(5);
psi = -input(6);

Sphi = sin(phi);
Cphi = cos(phi);
Stheta = sin(theta);
Ctheta = cos(theta);
Spsi = sin(psi);
Cpsi = cos(psi);

% Rotation matrix
TBE = [        Ctheta*Cpsi               Ctheta*Spsi          -Stheta    ;
    Sphi*Stheta*Cpsi-Cphi*Spsi Sphi*Stheta*Spsi+Cphi*Cpsi Sphi*Ctheta ;
    Cphi*Stheta*Cpsi+Sphi*Spsi Cphi*Stheta*Spsi-Sphi*Cpsi Cphi*Ctheta];
rot = TBE';

% Code executed only the first time that the script is
% called.
if index_view == 0
    
    % Initialize the figure
    screen = get(0,'screensize');
    visual = figure(1);
    set(visual,'position',[2 65 screen(3)-4 screen(4)-170]);
    clf(visual);
    hold on;
    cameratoolbar('show');
    axis vis3d;
    view(3);
    zoom(0.6);
    
    % The following two lines can be deleted for better performances.
    set(gcf,'menubar','figure','renderer','opengl');
    set(gca,'Visible','On','Box','On','XGrid', 'on','YGrid', 'on','ZGrid',...
        'on','projection','perspective');
    
    % Draw fixed frame reference
    %N
    line([0,0.5],[0,0],[0,0],'linewidth',2,'color','red');
    text(0.6,0,0,'N','fontsize',13);
    %E
    line([0,0],[0,0],[0,-0.5],'linewidth',2,'color','green');
    text(0,-0.6,0,'E','fontsize',13);
    %D
    line([0,0],[0,-0.5],[0,0],'linewidth',2,'color','black');
    text(0,0,-0.6,'D','fontsize',13);
    %Ground square
    line([-1,1],[1,1],[0,0],'linewidth',2,'color','black');
    line([-1,1],[-1,-1],[0,0],'linewidth',2,'color','black');
    line([1,1],[-1,1],[0,0],'linewidth',2,'color','black');
    line([-1,-1],[-1,1],[0,0],'linewidth',2,'color','black');
    
    
    % This part is not executed the first time the script
    % is called.
else
    
    % Delete the quadrotor drawing in the old position
    drawnow;
    delete(quad.a);
    delete(quad.b);
    delete(quad.c);
    delete(quad.d);
    delete(quad.e);
    delete(quad.f);
    line([old_position(1),x],[old_position(2),y],[old_position(3),z],...
        'linewidth',1,'color','magenta');
end

% Draw the quadrotor
%frame
points = [-0.25 +0.25;-0.25 +0.25;0 0];
quad.a = line(x+rot(1,:)*points,y+rot(2,:)*points,z+rot(3,:)*points,...
    'linewidth',2,'color','black');
points = [+0.25 -0.25;-0.25 +0.25;0 0];
quad.b = line(x+rot(1,:)*points,y+rot(2,:)*points,z+rot(3,:)*points,...
    'linewidth',2,'color','black');

%propellers
circ_x = [0.15 0.1 0 -0.1 -0.15 -0.1 0 0.1 0.15];
circ_y = [0 0.1 0.15 0.1 0 -0.1 -0.15 -0.1 0];
circ_z = [0 0 0 0 0 0 0 0 0];

points = [circ_x+0.25;circ_y+0.25;circ_z];
quad.c = line(x+rot(1,:)*points,y+rot(2,:)*points,z+rot(3,:)*points,...
    'linewidth',2,'color','red');
points = [circ_x+0.25;circ_y-0.25;circ_z];
quad.d = line(x+rot(1,:)*points,y+rot(2,:)*points,z+rot(3,:)*points,...
    'linewidth',2,'color','red');
points = [circ_x-0.25;circ_y+0.25;circ_z];
quad.e = line(x+rot(1,:)*points,y+rot(2,:)*points,z+rot(3,:)*points,...
    'linewidth',2,'color','blue');
points = [circ_x-0.25;circ_y-0.25;circ_z];
quad.f = line(x+rot(1,:)*points,y+rot(2,:)*points,z+rot(3,:)*points,...
    'linewidth',2,'color','blue');


% Save the current position for the path plot
old_position = [x,y,z];

% Set the camera position and target
camtarget_x = x/2;
camtarget_y = y/2;
camtarget_z = z/2;
campos_x = (camtarget_x/2 + camtarget_y)*6 - 2;
campos_y = (camtarget_y/2 - camtarget_x)*6 - 1;
campos_z = camtarget_z + sqrt(campos_x^2+campos_y^2)/6 + 3;

camtarget([camtarget_x,camtarget_y,camtarget_z]);
campos([campos_x,campos_y,campos_z]);

% Count the iterations
index_view = index_view + 1;