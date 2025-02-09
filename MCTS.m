function [reward,tr,GPmodel]=MCTS(node,tr,threshold,GPmodel,initial_hyper_para,fractal_distance,trigger_id)

%% Initial parameter
alpha0=initial_hyper_para(1);
beta0=initial_hyper_para(2);
mu0=initial_hyper_para(3);
lambda0=initial_hyper_para(4);
N0=initial_hyper_para(5);

%% MCTS loop
s=node.state;
h=node.h;
id=find(eq(tr,node));
parent=id;
if h==0
    reward=0;
elseif isleaf(tr,id) 
    if id==1
        parent_s=[];
    else
        parent_node=tr.get(tr.Parent(id));
        parent_s=parent_node.state; 
    end
    [reward,GPmodel,action,coh_after]=Rollout(s,parent_s,h,GPmodel,threshold,fractal_distance,trigger_id);
    s_new=[s,action];
    % Define the child state
    child.state=s_new;
    child.coherence=coh_after;
    child.h=h-1;
    child.alpha=alpha0;
    child.beta=beta0;
    child.mu=reward;
    child.lambda=lambda0;
    child.N=1;
    tr=tr.addnode(parent,child); % Add child to the tree;
  
else    
    [action,tr]=BestAction(node,tr,true,initial_hyper_para,threshold,trigger_id);

    s_new=[s,action];
    
    node_new.state=s_new;
    node_new.coherence=[];
    node_new.h=h-1;
    node_new.alpha=alpha0;
    node_new.beta=beta0;
    node_new.mu=-h;
    node_new.lambda=lambda0;
    node_new.N=N0;
    
    if ~isempty(find(eq(tr,node_new)))
        child_id=find(eq(tr,node_new));
        node_new=tr.get(child_id);
        coh=node_new.coherence;
    else
        coh=coherence(s_new,0,trigger_id);
        GPmodel=GPupdate(GPmodel,s_new,coh,fractal_distance);
        node_new.coherence=coh;
        tr=tr.addnode(parent,node_new);
    end

    if coh>=threshold
        temp_reward=binornd(1,0.95)-1;
    else
        temp_reward=-1;
    end

    node_new.N=node_new.N+1;

    [reward_remaining,tr,GPmodel]=MCTS(node_new,tr,threshold,GPmodel,initial_hyper_para,fractal_distance,trigger_id);
    reward=temp_reward+reward_remaining;
     % update posterior
     node_new.alpha=node_new.alpha+0.5;
     node_new.beta=node_new.beta+0.5*(node_new.lambda*(reward-node_new.mu)^2/(node_new.lambda+1));
     node_new.mu=((node_new.N-1)*node_new.mu+reward)/(node_new.N);
     node_new.lambda=node_new.lambda+1;
     child_id=find(eq(tr,node_new));
     tr=tr.set(child_id,node_new); 

end