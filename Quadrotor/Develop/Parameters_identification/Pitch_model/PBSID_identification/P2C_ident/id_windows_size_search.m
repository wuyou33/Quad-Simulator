clc
close all
clear all

%% PI-MOESP reference model 

% previous PI-MOESP test-bed P2A2 n=2 p=32 rit=0.06s
sys_moesp_tb_p2a2 = tf([12.11 24.28],[1 4.643 16.76]);

% previous PBSID test-bed P2A2 n=2 f=6 p=35 rit=0.06s
sys_pbsid_tb_p2a2 = tf([12.517 (12.517*2.906)],[1 5.583 21.3]);

% test-bed P2C PI-MOESP, rit=2(0.04s) - n=2 - p=39, campaign 3, dataset type == 2

sys_moesp_tb_p2c = tf([10.29 33.68],[1 5.112 14.72]);



%% load indoor identification data

del=0;
Ts = 0.02; % identification data sample time 
rit_vec = [3]; % insert n° of sample delay

data= 2;%input('dataset type: <=1> ; <=2> :')

if data == 1 

load var_for_ident_campaign_3 
u_ident_ = u_PRBS_campaign; 
y_ident_ = meas_q_PRBS_campaign; % SISO identifico solo ang vel
t_plot_ident = (0:Ts:((length(u_ident_)-1)*Ts))';

load var_for_valid_campaign_3
u_valid_ = u_ctrl_campaign; 
y_valid_ = meas_q_ctrl_campaign;
t_plot_valid = (0:Ts:((length(u_valid_)-1)*Ts))';

% Calcolo fattori di normalizzazione delle uscite
scale_ident = norm(y_ident_);% SISO identifico solo ang vel
scale_valid = norm(y_valid_); 
% Normalizzazione delle uscite
y_ident = y_ident_/scale_ident; % SISO identifico solo ang vel
y_valid = y_valid_/scale_valid;
% % Rimozione valor medio u
u_ident = (u_ident_ - mean(u_ident_));
u_valid = (u_valid_ - mean(u_valid_));

figure
subplot(2,1,1)
plot(t_plot_ident,u_ident_,'c')
hold on
plot(t_plot_ident(end)+t_plot_valid,u_valid_,'g')
ylabel('u [%]')
subplot(2,1,2)
plot(t_plot_ident,u_ident,'c')
hold on
plot(t_plot_ident(end)+t_plot_valid,u_valid,'g')
ylabel('time [s]')
ylabel('u [%] no mean')
legend('ident','valid')

figure
subplot(2,1,1)
plot(t_plot_ident,y_ident_,'c')
hold on
plot(t_plot_ident(end)+t_plot_valid,y_valid_,'g')
ylabel('ang vel [deg/s] all dataset')
subplot(2,1,2)
plot(t_plot_ident,y_ident,'c')
hold on
plot(t_plot_ident(end)+t_plot_valid,y_valid,'g')
ylabel('time [s]')
ylabel('ang vel normalized no mean')
legend('ident','valid')

else

load var_for_ident_campaign_3
load var_for_valid_campaign_3

u_tot_ = vertcat(u_PRBS_campaign,u_ctrl_campaign);
y_tot_ = vertcat(meas_q_PRBS_campaign,meas_q_ctrl_campaign);
N_tot = length(u_tot_);
t_plot_tot = (0:Ts:((length(u_tot_)-1)*Ts))';

scale = norm(y_tot_);
y_tot = y_tot_/scale;

u_tot = u_tot_ - mean(u_tot_);

% Identificazione da 1 a N/2 e validazione da N/2+1 a end
in_id_i=1;
in_id_f=floor(1/2*N_tot);
in_va_i=in_id_f+1;
in_va_f=N_tot;

u_ident = u_tot(in_id_i:in_id_f);
y_ident = y_tot(in_id_i:in_id_f);
t_plot_ident = (0:Ts:((length(u_ident)-1)*Ts))';
u_valid = u_tot(in_va_i:in_va_f);
y_valid = y_tot(in_va_i:in_va_f);
t_plot_valid = (0:Ts:((length(u_valid)-1)*Ts))';

figure
subplot(2,1,1)
plot(t_plot_tot,u_tot_)
ylabel('u [%] all dataset')
subplot(2,1,2)
plot(t_plot_tot,u_tot)
hold on 
plot(t_plot_ident,u_ident,'c--')
hold on 
plot(t_plot_ident(end)+t_plot_valid,u_valid,'g--')
ylabel('time [s]')
ylabel('u [%] no mean')
legend('all','ident','valid')

figure
subplot(2,1,1)
plot(t_plot_tot,y_tot_)
ylabel('ang vel [deg/s] all dataset')
subplot(2,1,2)
plot(t_plot_tot,y_tot)
hold on 
plot(t_plot_ident,y_ident,'c--')
hold on 
plot(t_plot_ident(end)+t_plot_valid,y_valid,'g--')
ylabel('time [s]')
ylabel('ang vel normalized no mean')
legend('all','ident','valid')

end


%% PREFILTRAGGIO

% N=length(u_ident);
% 
% t=(0:N-1)'/Ts;
% pole=100;
% filt=tf(pole^2,[1 2*pole pole^2]);
% uf=lsim(filt,u_ident,t);
% yf=lsim(filt,y_ident,t);

uf = u_ident;
yf = y_ident;


%% DEFINIZIONE DATASET IDENTIFICAZIONE E VALIDAZIONE

ui = uf;
uv = u_valid; 

% cancellare il ritardo nei dati shiftando in avanti il segnale d'ingresso
% u per l'identificazione
% ui(rit+1:end) = ui(1:end-rit); 
% ui(1:rit) = zeros(rit,1);

% allo stesso modo per la validazione bisogna shiftare in avanti l'ingresso
% uv(rit+1:end) = uv(1:end-rit); 
% uv(1:rit) = zeros(rit,1);

yi = yf; 
yv = y_valid;

%% Identification of the model using PBSID

% The past and future window size p and f must be higher then the expected order n
% Future window size f must equal or smaller then past window p. (f <= p)
n_vect = 2;%[2:1:6];    % order of system

kk = 0;

for rr=1:length(rit_vec)
    
    rit = rit_vec(rr);
    
    ui = uf;
    uv = u_valid; 
    
    ui(rit+1:end) = ui(1:end-rit); 
    ui(1:rit) = zeros(rit,1);

    uv(rit+1:end) = uv(1:end-rit); 
    uv(1:rit) = zeros(rit,1);

    for nn=1:length(n_vect)
    
        n = n_vect(nn);

        p_vect = [n:1:50];   % past window size
        f_vect = [n:1:p_vect(end)]; % future window size

        for ii=1:length(p_vect)

            for jj=1:length(f_vect)

                if f_vect(jj) <= p_vect(ii)
            
                    f=f_vect(jj);
                    p=p_vect(ii);
                    kk = kk+1;

                    % PBSID-varx 
                    [S1,X1] = dordvarx(ui,yi,f,p,'tikh','gcv',0,0);

                    x1 = dmodx(X1,n);
                    %[A1,B1,C1,D1,K1] = dx2abcdk(x1,ui,yi,f,p);
                    [A1,B1,C1,K1] = dx2abck(x1,ui,yi,f,p);
                    D1=0;
                    sys1 = ss(A1,B1,C1,D1,Ts);
                    
                    sys1_c_tf = tf(d2c(sys1));
                    
                    zero_pos = - sys1_c_tf.num{1}(3)/sys1_c_tf.num{1}(2); % zero position calc
                    pole_pos = roots(sys1_c_tf.den{1}); % tf deno poly roots
                    
                    poly_order =  length(sys1_c_tf.den{1}); % tf order calc

        %             % PBSID-varmax 
        %             % !!! molto più lento dell'algoritmo -varx !!!
        %             [S1,X1] = dordvarmax(ui,yi,f,p,'els',1e-6,'tikh','gcv');
        % 
        %             x1 = dmodx(X1,n);
        %             %[A1,B1,C1,D1,K1] = dx2abcdk(x1,ui,yi,f,p);
        %             [A1,B1,C1,K1] = dx2abck(x1,ui,yi,f,p);
        %             D1=0;
        %             sys1 = ss(A1,B1,C1,D1,Ts);

                    % Simulazione modello identificato su dati di validazione
                     tsim = (0:Ts:((length(uv)-1)*Ts))';
%                     yyv_1=lsim(sys1,uv,tsim);
                    
                    % Stima stato iniziale per simulazione
                    x0=dinit(A1,B1,C1,D1,uv,yv);
                    % Simulazione modello identificato su dati di validazione
                    yyv_1=dlsim(A1,B1,C1,D1,uv,x0);

                    VAF=vaf(yv,yyv_1);

                    disp(sprintf('rit=%d - n=%d - p=%d - f=%d - VAF=%f' ,rit,n,p,f,VAF));

                    rit_collect(kk) = rit;
                    n_collect(kk) = n;
                    p_collect(kk) = p;
                    f_collect(kk) = f;
                    VAF_collect(kk) = VAF;
                    
                    if real(pole_pos(1)) == real(pole_pos(2)) && zero_pos<0 && poly_order==3 % identified tf is ok only if: order = 2, zero is in LHP, the pole is complex conjugate
                        
                        index = 1;
                        
                    else 
                        
                        index = 0;
                        
                    end
                    
                    index_collect(kk) = index;
        
                end
        
            end

        end

    end

end

index_ok = find(index_collect==1);



max_VAF = max(VAF_collect(index_ok));
index_max = find(VAF_collect == max_VAF);
rit_VAF_max = rit_collect(index_max);
n_VAF_max = n_collect(index_max);
p_VAF_max = p_collect(index_max);
f_VAF_max = f_collect(index_max);

disp(sprintf('******* rit=%d - n=%d - p=%d - f=%d - VAF_max=%f *******' ,rit_VAF_max,n_VAF_max,p_VAF_max,f_VAF_max,max_VAF));

%% re-do calc for best f,p (max VAF)

ui = uf;
uv = u_valid; 
ui(rit_VAF_max+1:end) = ui(1:end-rit_VAF_max); 
ui(1:rit_VAF_max) = zeros(rit_VAF_max,1);

uv(rit_VAF_max+1:end) = uv(1:end-rit_VAF_max); 
uv(1:rit_VAF_max) = zeros(rit_VAF_max,1);

% PBSID-varx 
[S1,X1] = dordvarx(ui,yi,f_VAF_max,p_VAF_max,'tikh','gcv',0,0);

x1 = dmodx(X1,n_VAF_max);
%[A1,B1,C1,D1,K1] = dx2abcdk(x1,ui,yi,f_VAF_max,p_VAF_max);
[A1,B1,C1,K1] = dx2abck(x1,ui,yi,f_VAF_max,p_VAF_max);
D1=0;
sys1 = ss(A1,B1,C1,D1,Ts);

% % PBSID-varmax 
% % !!! molto più lento dell'algoritmo -varx !!!
% [S1,X1] = dordvarmax(ui,yi,f_VAF_max,p_VAF_max,'els',1e-6,'tikh','gcv');
% 
% x1 = dmodx(X1,n);
% %[A1,B1,C1,D1,K1] = dx2abcdk(x1,ui,yi,f_VAF_max,p_VAF_max);
% [A1,B1,C1,K1] = dx2abck(x1,ui,yi,f_VAF_max,p_VAF_max);
% D1=0;
% sys1 = ss(A1,B1,C1,D1,Ts);

%% Verification results

% Simulazione modello identificato su dati di validazione (normal ctrl)
% yyv_1 = lsim(sys1,uv,tsim);

% Stima stato iniziale per simulazione
x0=dinit(A1,B1,C1,D1,uv,yv);
% Simulazione modello identificato su dati di validazione
yyv_1=dlsim(A1,B1,C1,D1,uv,x0);


figure
semilogy(S1,'*')
xlabel('order of identifiable system')
ylabel('singular values S')

figure
plot(tsim,yv)
hold on
plot(tsim,yyv_1,'r')
grid on
ylabel('Normalised angular rate')
xlabel('time [s]')
legend('measured','model')

%% conversione modello t discr -> t cont

if data == 2 

% ripristina scalatura

C1_scale=C1*scale;
D1_scale=D1*scale;

sys1_d=ss(A1,B1,C1_scale,D1_scale,Ts);

[A1c,B1c,C1c,D1c]=d2cm(A1,B1,C1_scale,D1_scale,Ts);
sys1_c=ss(A1c,B1c,C1c,D1c);
sys1_c_tf=tf(sys1_c);

% Simulazione modello identificato a t discr con scalatura eliminata su dati di validazione (normal ctrl)
% yyv_2=lsim(sys1_d,uv,tsim);

% Stima stato iniziale per simulazione
x0=dinit(A1,B1,C1_scale,D1_scale,uv,yv*scale);
% Simulazione modello identificato su dati di validazione
yyv_2=dlsim(A1,B1,C1_scale,D1_scale,uv,x0);

figure
plot(tsim,yv*scale)
hold on
plot(tsim,yyv_2,'r')
grid on
ylabel('angular rate [rad/s]')
xlabel('time [s]')
legend('measured','model')

VAF_no_scale_d = vaf(yv*scale,yyv_2)

% Simulazione modello identificato a t cont con scalatura eliminata su dati di validazione (normal ctrl)
yyv_2_c=lsim(sys1_c,uv,tsim);
yyv_2_c_tf=lsim(sys1_c_tf,uv,tsim);

figure
plot(tsim,yv*scale)
hold on
plot(tsim,yyv_2_c,'r')
grid on
ylabel('angular rate [rad/s]')
xlabel('time [s]')
legend('measured','model')

VAF_no_scale_c = vaf(yv*scale,yyv_2_c)
VAF_no_scale_c_tf = vaf(yv*scale,yyv_2_c_tf)

else
    
% ripristina scalatura

C1_scale=C1*scale_valid;
D1_scale=D1*scale_valid;

sys1_d=ss(A1,B1,C1_scale,D1_scale,Ts);

[A1c,B1c,C1c,D1c]=d2cm(A1,B1,C1_scale,D1_scale,Ts);
sys1_c=ss(A1c,B1c,C1c,D1c);
sys1_c_tf=tf(sys1_c);

% Simulazione modello identificato a t discr con scalatura eliminata su dati di validazione (normal ctrl)
% yyv_2=lsim(sys1_d,uv,tsim);

% Stima stato iniziale per simulazione
x0=dinit(A1,B1,C1_scale,D1_scale,uv,yv*scale_valid);
% Simulazione modello identificato su dati di validazione
yyv_2=dlsim(A1,B1,C1_scale,D1_scale,uv,x0);

figure
plot(tsim,yv*scale_valid)
hold on
plot(tsim,yyv_2,'r')
grid on
ylabel('angular rate [rad/s]')
xlabel('time [s]')
legend('measured','model')

VAF_no_scale_d = vaf(yv*scale_valid,yyv_2)

% Simulazione modello identificato a t cont con scalatura eliminata su dati di validazione (normal ctrl)
yyv_2_c=lsim(sys1_c,uv,tsim);

figure
plot(tsim,yv*scale_valid)
hold on
plot(tsim,yyv_2_c,'r')
grid on
ylabel('angular rate [rad/s]')
xlabel('time [s]')
legend('measured','model')

VAF_no_scale_c = vaf(yv*scale_valid,yyv_2_c)
   
end


%% comparison

figure
bodeplot(sys1_c_tf)
hold on
bodeplot(sys_pbsid_tb_p2a2,'m')
hold on
bodeplot(sys_moesp_tb_p2c,'r')
hold on
bodeplot(sys_moesp_tb_p2a2,'g')
grid on 
legend('pbsid p2c','pbsid p2a2','pi-moesp p2c','pi-moesp p2a2')

figure
step(sys1_c_tf)
hold on
step(sys_pbsid_tb_p2a2,'m')
hold on
step(sys_moesp_tb_p2c,'r')
hold on
step(sys_moesp_tb_p2a2,'g')
grid on 
legend('pbsid p2c','pbsid p2a2','pi-moesp p2c','pi-moesp p2a2')

figure
pzmap(sys1_c_tf)
hold on
pzmap(sys_pbsid_tb_p2a2,'m')
hold on
pzmap(sys_moesp_tb_p2c,'r')
hold on
pzmap(sys_moesp_tb_p2a2,'g')
legend('pbsid p2c','pbsid p2a2','pi-moesp p2c','pi-moesp p2a2')





