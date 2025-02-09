
function [prob,mu,S2]=GP_prediction(s,GPmodel,threshold,fractal_distance)

    Xtrain=GPmodel.Xtrain;
    Ytrain=GPmodel.Ytrain;
    temp=zeros([1,size(Xtrain,2)-1]);
    temp(s)=1;
    xs=[temp,floor(sum(temp))];

    [tf,id]=ismember(xs(:,1:end-1),Xtrain(:,1:end-1),'rows');
    if tf
        mu=Ytrain(id);
        S2=0;
    else
        parameter=GPmodel.parameter;
        w=GPmodel.w;
        ref_id=size(w,1);
        inv_K=GPmodel.inv_K;
        C1=GPmodel.C1train;
        C2=GPmodel.C2train;

        %% prediction
        [Cs1,Cs2] = sq_dist(xs, w, fractal_distance);
        PD_k1=PD_kernel(parameter(1),parameter(2),Cs1,Cs2,C1,C2,ref_id);
        Ks = PD_k1*parameter(4)^2; 
        PD_k2=PD_kernel(parameter(1),parameter(2),Cs1,Cs2,Cs1,Cs2,ref_id);
        Kss = PD_k2*parameter(4)^2 + parameter(3)^2*eye(size(xs,1)); 

        interm=Ks*inv_K;

        postMu =  interm*(Ytrain);
        postCov = Kss - interm*Ks';
        mu = postMu(:);
        S2 = diag(postCov);
    end
    %% Probability Calculation   
        prob=normcdf(threshold,mu,sqrt(S2));
end