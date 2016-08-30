function [e,RT2,Fit]=cor(data,model,int);
    if nargin<2
        error('Number of input arguments incorrect!')
    end
    if ~isa(model,'idmodel'),
        error('model must be an idmodel object !')
    end
    if ~isa(data,'iddata'),
        error('data must be an iddata object !')
    end
    ny = data.ny;
    nu = data.nu;
    N=data.N;
    %*** Preliminary calculations ***
    if nargin<3
        int=[];
    end
    if isempty(int)
        int=([1:data.N])';
    end
    [ys,estInfo]=comparec(data,model,int);
    RT2 = estInfo.RT2;
    Fit = estInfo.Fit;
    e = data.y(int,1) - ys;
    if nargout==0
        t = data.SamplingInstants;
        if(isempty(t))
            t=[0:data.N-1]'*Ts;
        end
    end
    nz=ny+nu;
    maxsdef=idmsize(N);
    if nargin<4
        maxsize=maxsdef;
    end
    u=data.u;
    M=[];
    if isempty(M)
        M=25;
    end
    e1=[e u(int)];
    r=covf(e1,M,maxsize);
    nr=0:M-1;
    plotind=0;
    for ky=1:ny
        ind=ky+(ky-1)*nz;
        % ** Confidence interval for the autocovariance function **
        sdre=2.58*(r(ind,1))/sqrt(N)*ones(M,1);
        if nz==1
            spin=111;
        else spin=210+plotind+1;
        end
        subplot(spin)
        plot(nr,r(ind,:)'/r(ind,1),nr,[ sdre -sdre]/r(ind,1),'--r')
        title(['Autocovariance function of residuals. Output: y',int2str(ky)])
        xlabel('lag')
        plotind=rem(plotind+1,2);
        if plotind==0
            pause
            newplot;
        end
    end
    nr=-M+1:M-1;
    % *** Compute confidence lines for the cross-covariance functions **
    for ky=1:ny
        for ku=1:nu
            ind1=ky+(ny+ku-1)*nz;
            ind2=ny+ku+(ky-1)*nz;
            indy=ky+(ky-1)*nz;
            indu=(ny+ku)+(ny+ku-1)*nz;
            %corr 891007
            sdreu=2.58*sqrt(r(indy,1)*r(indu,1)+2*(r(indy,2:M)*r(indu,2:M)'))/sqrt(N)*ones(2*M-1,1); % corr 890927
            spin=210+plotind+1;
            subplot(spin);
            plot(nr,[r(ind1,M:-1:1) r(ind2,2:M) ]'/(sqrt(r(indy,1)*r(indu,1))),...
            nr,[sdreu -sdreu]/(sqrt(r(indy,1)*r(indu,1))),'--r' );
            j=1;
            title(['Cross-cov. function between input: u' int2str(ku)...
                     ' and residuals from output: y',int2str(ky)])
            xlabel('lag')
            plotind=rem(plotind+1,2);
            if ky+ku<nz & plotind==0
                pause
                newplot;
            end
        end
    end
    r(1,M+1:M+2)=[N,ny];
    set(gcf,'NextPlot','add');