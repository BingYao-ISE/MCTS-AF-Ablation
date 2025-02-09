function [q,tr]=Qvalue(node,tr,action,sampling,initial_hyper_para,threshold,trigger_id)

alpha0=initial_hyper_para(1);
beta0=initial_hyper_para(2);
lambda0=initial_hyper_para(4);
N0=initial_hyper_para(5);
mu0=initial_hyper_para(3);
s=node.state;
h=node.h;
N=node.N;

s_new=[s,action];

%% child state
child.state=s_new;
child.coherence=[];
child.h=h-1;
child.alpha=alpha0;
child.beta=beta0;
child.mu=mu0;
child.lambda=lambda0;
child.N=N0;
if isempty(find(eq(tr,child)))
    mu=-h;
    beta=beta0;
    alpha=alpha0;
    lambda=lambda0;
    coh=coherence(s_new,0,trigger_id);
    child.coherence=coh;

    parent=find(eq(tr,node));
    tr=tr.addnode(parent,child);
else
    child_id=find(eq(tr,child));
    child=tr.get(child_id);
    mu=child.mu;
    beta=child.beta;
    alpha=child.alpha;
    lambda=child.lambda;
end

%%
if sampling==true
    q=mu+sqrt(1*log(N)*beta/(alpha*lambda));
else
    q=mu;
end