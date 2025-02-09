function GPmodel=GPupdate(GPmodel,s,coh,fractal_distance)
w=GPmodel.w;
temp=zeros([1,size(w,2)-1]);
temp(s)=1;
X_new=[temp,floor(sum(temp))];
X_new=sparse(X_new);
Xtrain=GPmodel.Xtrain;
Ytrain=GPmodel.Ytrain;

if ~ismember(X_new,Xtrain,'rows') 
    parameter=GPmodel.parameter;
    
    ref_id=size(w,1);
    Xtrain=[Xtrain;X_new];
    Ytrain=[Ytrain;coh];
    
    invA=GPmodel.inv_K;
    C1=GPmodel.C1train;
    C2=GPmodel.C2train;
    
    [Cs1,Cs2] = sq_dist(X_new, w, fractal_distance);
    
    if mod(size(Xtrain,1),1000)~=0
    %% function-definition
        
        PD_k=PD_kernel(parameter(1),parameter(2),Cs1,Cs2,C1,C2,ref_id);
        PD_k1=PD_kernel(parameter(1),parameter(2),Cs1,Cs2,Cs1,Cs2,ref_id);
    %% blockwise_inversion  
        B = parameter(4)^2*PD_k';
        C = B';
        D = parameter(3)^2+parameter(4)^2*PD_k1;
        invAtimesB=invA*B;
        DminusCtimesinvAtimesB=D-C*invAtimesB;
        tt=invAtimesB/DminusCtimesinvAtimesB;
        VAA=invA+tt*invAtimesB';
        VAB=-tt;
        VBA=-tt';
        VBB=1/DminusCtimesinvAtimesB;
        inv_K=[VAA,VAB;VBA,VBB];
        C1=[C1;Cs1];
        C2=[C2;Cs2];
    %% Batch update
    else
       C1=[C1;Cs1];
       C2=[C2;Cs2];
       PD_k=PD_kernel(parameter(1),parameter(2),C1,C2,C1,C2,ref_id);
       K =parameter(4)^2*PD_k+parameter(3)^2*eye(size(PD_k,1));
       inv_K=K\eye(size(K));
    end

    
%% Update GPmodel

    GPmodel.Xtrain=Xtrain;
    GPmodel.Ytrain=Ytrain;
    GPmodel.inv_K=inv_K;
    GPmodel.C1train=C1;
    GPmodel.C2train=C2;
end
