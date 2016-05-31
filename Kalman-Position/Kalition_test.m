%% KALMAN ALTITUDE %%
%%%%%%%%%%%%%%%%%%%%%
close all
clear all
clc
%% Load data
load fly7_tuning.mat

ts = 0.01;
t = 0:ts:(length(acc)-1)*ts;
Tsim = max(t);

%% Variables

acc_bias = mean(acc(1:100,1:2));
bias_x= acc_bias(1);
bias_y= acc_bias(2);

acc_scale = mean(acc(1:100,3));

Q = diag([0.005 0.005 0.005]);
sigma_acc = 1;
sigma_opti = 1;
R = diag([sigma_acc^2 sigma_opti^2]);

%% Create Signal Block

% % Accelerometer
ax = timeseries(acc(:,1),t,'Name','ax');
ay = timeseries(acc(:,2),t,'Name','ay');
az = timeseries(acc(:,3),t,'Name','az');

% % Angles
phi = timeseries(OPTI_RPY(:,1),t,'Name','phi');
theta = timeseries(OPTI_RPY(:,2),t,'Name','theta');
psi = timeseries(OPTI_RPY(:,3),t,'Name','psi');

% % NED
pos_n = timeseries(Ned(:,1),t,'Name','pos_n');
pos_e = timeseries(Ned(:,2),t,'Name','pos_e');

%% Simulate
k_err=1;
k_disc=1;

[b,a] = butter(1,0.02,'low');
new_pos_n_filt=filtfilt(b,a,pos_n.data);
new_pos_n = timeseries(new_pos_n_filt,t,'Name','new_pos_n');

% figure('name','position')
% subplot(211)
% hold on
% plot(pos_n)
% plot(new_pos_n)
% grid minor
% ylabel('North [m]')
% subplot(212)
% hold on
% plot(pos_e)
% plot(e_dist)
% grid minor
% legend('Optitrack','Kalman','location','northeast')
% ylabel('East [m]')
% xlabel('time [s]')

best_q=[inf inf inf inf inf ];
best_a=[inf inf inf inf inf ];
best_o=[inf inf inf inf inf ];
best_v=[inf inf inf inf inf ];

% for q = 0:0.0001:0.01
%     for sigma_acc=0:0.01:1
%         for sigma_opti=0:0.01:1
q_start=0.0001;
q_step=0.0001;
q_stop=0.001;

a_start=0.1;
a_step=0.1;
a_stop=1;

o_start=0.1;
o_step=0.1;
o_stop=1;

time_start = clock;
for q = q_start:q_step:q_stop
    for sigma_acc=a_start:a_step:a_stop
        for sigma_opti=o_start:o_step:o_stop
            fprintf('%i%i%i\n', fix(q*10/q_stop-1),fix(sigma_acc*10/a_stop-1),fix(sigma_opti*10/o_stop-1));
            Q = diag([q q q]);
            R = diag([sigma_acc^2 sigma_opti^2]);
            
              
            sim Kalition_Test
            
            temp_err=0;
            temp_disc=0;
            for x=0.02:0.01:Tsim-0.01
                temp_err=temp_err+k_err*abs(n_dist.data(round(x*100))-new_pos_n.data(round(x*100)));
%                 temp=temp+k_temp*abs(n_dist.data(round(x*100))-n_dist.data(round(x*100+1)));
%                 temp_disc=temp_disc+k_disc*abs((n_dist.data(round(x*100))-n_dist.data(round(x*100-1)))/0.01 - (n_dist.data(round(x*100+1))-n_dist.data(round(x*100)))/0.01);
  
            end
%             temp=temp_err+temp_disc;
            temp=temp_err;

%             fprintf('temp_err %f, temp_disc %f, temp %f\n',temp_err,temp_disc,temp);
            
            q_temp=q;
            a_temp=sigma_acc;
            o_temp=sigma_opti;
            
            tempvar=0;
            
            for i=1:1:5
                if temp<best_v(i)
                    tempvar=best_v(i);
                    best_v(i)=temp;
                    temp=tempvar;
                    
                    tempvar=best_q(i);
                    best_q(i)=q_temp;
                    q_temp=tempvar;
                    
                    tempvar=best_a(i);
                    best_a(i)=a_temp;
                    a_temp=tempvar;
                    
                    tempvar=best_o(i);
                    best_o(i)=o_temp;
                    o_temp=tempvar;
                end
            end
            
            elapsed_time = clock-time_start
            
        end
    end
end




for i=1:1:5

    q=best_q(i);
    sigma_acc=best_a(i);
    sigma_opti=best_o(i);
    
    Q = diag([q q q]);
    R = diag([sigma_acc^2 sigma_opti^2]);

            sim Kalition_Test

           figname=  strcat('q=',num2str(q),' a=',num2str(sigma_acc),' o=',num2str(sigma_opti));
            
figure('name',figname)
subplot(211)
hold on
plot(pos_n)
plot(n_dist)
grid minor
ylabel('North [m]')
subplot(212)
hold on
plot(pos_e)
plot(e_dist)
grid minor
legend('Optitrack','Kalman','location','northeast')
ylabel('East [m]')
xlabel('time [s]')

end





%% Plot Result

figure('name','position')
subplot(211)
hold on
plot(pos_n)
plot(n_dist)
grid minor
ylabel('North [m]')
subplot(212)
hold on
plot(pos_e)
plot(e_dist)
grid minor
legend('Optitrack','Kalman','location','northeast')
ylabel('East [m]')
xlabel('time [s]')

% namefigure = strcat('NorthDistance','_q',num2str(q,4),'_i',num2str(i,3),'_j',num2str(j,3));
% distancefigure = figure('name',namefigure);
% plot(IMUtime,mat.Ned(:,1));
% hold on;
% plot(time,n_dist);
% %grid minor
% title(namefigure)
% xlabel('time [s]')
% ylabel('[m]')
% legend('Raw ','Filtered')
% xlim([20,30])
% savefile = strcat('temp_figures/',namefigure,'.jpg');
% saveas(distancefigure,savefile);
% close(distancefigure);

%% Chillin' for a while after a long journey
load handel;
player = audioplayer(y, Fs);
play(player);

%% END OF CODE