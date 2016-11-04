% script per la relalizzazione del grafico che mostra la risposta a gradino
% e contour per vaf
%clear all;% close all; clc

% carica i dati precedentemente raccolti
%load('dati_test_22giu.mat');
%load('dati_test_28giu.mat');

%load('data_29giu_hinf.mat');
%load('data_1lu_40cm.mat');
%load('data_1lu_42cm_terra.mat');
load('data_1lu_54cm_terra.mat');

%load('data_29giu_h40_f4_a3.mat');
%load('data_29giu_h34_f4_a3.mat');

plt = 'y';

f = 18; p =18; n = 2; xx = 0;
f = 28; p = 28; n = 2; xx = 1; %yy = 5
sh = -4;
%sh = 0 ;

fvec = [27:30];
fvec=[4:30];%[8:10];
pvec = [4:30];
vafmxx = zeros(max(fvec),max(pvec));
% tenta identificazione con pbsid
for yy=5%:numel(data)
    
    u = data{yy}.u; y = data{yy}.p;
    
    [u,y] = applica_shift_singolarmente(u,y,sh);
    
    u = u - mean(u);
    y = y - mean(y);
    
    % normalizza e rimuove media
    scal_u = norm(u);
    scal_y = norm(y);
    
    
    % qui si inserisce la ricerca dei parametri p e f ottimi
    clear vafm;
    for fii = 1: numel(fvec)
        for pii = 1:numel(pvec)
            f = fvec(fii);
            p = pvec(pii);
            if f>p, continue, end
            disp(sprintf('sono a p= %d e f=%d', pvec(pii),fvec(fii)))
            u = 1/scal_u * u;
            y = 1/scal_y * y;
            
            % PBSID-varx (closed loop)
            if xx == 0
                [S,X] = dordvarx(u,y,f,p,'tikh','gcv');
            else
                [S,X] = dordvarmax(u,y,f,p,'els',1e-6,'tikh','gcv');
            end
            %   figure, semilogy(S,'*');
            x = dmodx(X,n);
            [Ai,Bi,Ci,Di,Ki] = dx2abcdk(x,u,y,f,p);
            
            % applica dimensionalizzazione alle matrici
            Bi = 1/scal_u * Bi;
            Ci = scal_y * Ci;
            Di = 1/scal_u * scal_y * Di;
            
            % ridimensionalizza input
            u = scal_u * u;
            % ridimensionalizza output (solo per calcolo VAF)
            y = scal_y * y;
            % verification using variance accounted for (VAF) (closed loop)
            OLi = ss(Ai,Bi,Ci,Di,.01);
            x0=dinit(Ai,Bi,Ci,Di,u,y);
            t  = .01 * [0:numel(u)-1];
            yi = lsim(OLi,u,t,x0);
            
            vafm(fii,pii) = vaf(y,yi);
            vafmxx(fvec(fii),pvec(pii))=vafm(fii,pii);
            tmp_oli(fii,pii) = OLi;
            tmptmp(fii,pii) = zpk(tf(d2c(OLi)));
        end
    end
    
    
    vafm = vafm .* (vafm<100&vafm>=0);
    for qq=1:size(vafm,1)
        for ww = 1:size(vafm,2)
            if vafm(qq,ww)==0, vafm(qq,ww)=nan;
            end
        end
    end
    
    % aggiunge cornice per riportare p ed f a valori sensati
    vafmm = [nan*zeros(max(fvec), min(pvec)-1), [nan*zeros(min(pvec)-1,size(vafm,2));vafm]];
    figure
    contourf(vafmm)
    xlabel('p'); ylabel('f');
    
    if 0
        figure;
        %        imagesc(vafm); colorbar;
        contourf(vafm)
        xlabel('p'); ylabel('f');
    end
    % trova i migliori parametri
    [v1, i1] = max(vafm);
    disp(sprintf('vaf max = %2.0f p=q=%2.0f', v1, i1, i1))
    
    return
    
    % ripete il calcolo un'altra volta (ineffeciente ma semplice)
    if 1
        f = fvec(i1);
        p = f;
        
        u = 1/scal_u * u;
        y = 1/scal_y * y;
        
        % PBSID-varx (closed loop)
        if xx == 0
            [S,X] = dordvarx(u,y,f,p,'tikh','gcv');
        else
            [S,X] = dordvarmax(u,y,f,p,'els',1e-6,'tikh','gcv');
        end
        %   figure, semilogy(S,'*');
        x = dmodx(X,n);
        [Ai,Bi,Ci,Di,Ki] = dx2abcdk(x,u,y,f,p);
        
        % applica dimensionalizzazione alle matrici
        Bi = 1/scal_u * Bi;
        Ci = scal_y * Ci;
        Di = 1/scal_u * scal_y * Di;
        
        % ridimensionalizza input
        u = scal_u * u;
        % ridimensionalizza output (solo per calcolo VAF)
        y = scal_y * y;
        % verification using variance accounted for (VAF) (closed loop)
        OLi = ss(Ai,Bi,Ci,Di,.01);
        x0=dinit(Ai,Bi,Ci,Di,u,y);
        t  = .01 * [0:numel(u)-1];
        yi = lsim(OLi,u,t,x0);
    end
    vc(yy) = vaf(y,yi);
    
    % a questo punto p e f sono stati scelti
    if plt == 'y'
        figure, plot(t, y, t, yi); grid on; title(num2str(yy))
    end
    
    if 1 % causa il salvataggio di tutte le cose di possibile interesse
        data{yy}.yi = yi; % salva la storia calcolata su modello identificato
        data{yy}.fdt = zpk(tf(d2c(OLi)));
        data{yy}.OLi = OLi;
        data{yy}.vc = vc(yy);
    end
    
    fdt(yy) = zpk(tf(d2c(OLi)));
    fdt(yy)
    %    bw(yy) = (bandwidth(fdt(yy)));
    
    if plt == 'y'
        figure(1)
        bode(fdt(yy)); hold on
    end
    %    bopt = balredOptions('FreqIntervals',[1,12]);
    %    fdt_red(yy) = balred(fdt(yy),1,bopt);
    %    figure(2)
    %    bode(fdt_red(yy)); hold on
end

% ci si accerta che la vaf abbia valori sensati
vc = vc .* (vc>0) .* (vc<100);

figure
subplot(1,2,2)
plot(vc,'s'); grid on
ylabel('vaf'); xlabel('Test')
title(sprintf('shift %2.0f ms',sh))
subplot(1,2,1)
for ii=1:numel(data),tmp = cell2mat(data{ii}.fdt.P)'; if numel(tmp)==2,
        poli(ii,:) = cell2mat(data{ii}.fdt.P)'; else poli(ii,:)=[0,0]; end ,end
plot(poli(:,2) ,'s'); grid on
xlabel('test'); ylabel('Polo a bassa freq')
% seleziona solo quelli che hanno vaf maggiore di 75
id = find(vc>80);
hold on;
plot(id, poli(id,2) ,'d');

% calcola qualche altra grandezza globale
mean(poli(id,2)), std(poli(id,2))

% crea struttura per il facile salvataggio dei risultati
glo.id=id; glo.vc = vc; go.poli = poli; glo.fdt = fdt;


% grafico per mostrare la risposta inversa
figure;
subplot(1,2,1);
step(OLi); grid on; title('');
subplot(1,2,2);
step(OLi);title(''); grid on


if 0
    load('casi_di_shift.mat')
    %    figure;
    for ii = 1:size(caso_sh4.vafmxx,1)-6,
        for jj = 1:size(caso_sh4.vafmxx,2)-6,
            if caso_sh4.vafmxx(ii+6,jj+6)<70,continue, end
            figure(1)
            bode(caso_sh4.tmptmp(ii,jj),'b');hold on;
            figure(2)
            rlocus(caso_sh4.tmptmp(ii,jj),'b');hold on;
            disp([ii,jj])
        end;
    end;
    disp('metà ok')
    for ii = 1:size(caso_sh5.vafmxx,1)-6,
        for jj = 1:size(caso_sh5.vafmxx,2)-6,
            if caso_sh5.vafmxx(ii+6,jj+6)<70,continue, end
            figure(1)
            bode(caso_sh5.tmptmp(ii,jj),'r');hold on;
            figure(2)
            rlocus(caso_sh5.tmptmp(ii,jj),'r');hold on;
            disp([ii,jj])
        end;
    end;
    grid on;            figure(1); grid on;
end