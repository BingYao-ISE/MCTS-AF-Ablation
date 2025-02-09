clear all
close all
clc
%% initialize parameters

initial_hyper_para = [1,10,-1,0.01,0];
alpha0 = initial_hyper_para(1);
beta0 = initial_hyper_para(2);
mu0 = initial_hyper_para(3);
lambda0 = initial_hyper_para(4);
N0 = initial_hyper_para(5);
threshold = 0.97;
maxiter = 10000;
H = 8;
%% Specify trigger ID
trigger_id=590;
%% Add search path and load necessary data
addpath(genpath('Geometry_and_GPmodel'))
load(['GPmodel_sparse_trigger_',num2str(trigger_id),'.mat'])
load Auxiliary_data/fractal_distance.mat
fractal_distance=D;

%% initialize node and tree
initial_state=[];
help tree/findpath

%%

tic
cumulative_reward=[];
cumulative_mu=[];
for step=H%:-1:1
    iter=0;
    coh0=coherence(initial_state,0,trigger_id);
    node.state=initial_state;
    node.coherence=coh0; % store the coherence of each state in the tree
    node.h=step;
    node.alpha=alpha0;
    node.beta=beta0;
    node.mu=mu0;
    node.lambda=lambda0;
    node.N=N0;
    tr=tree(node);
    while iter<maxiter
        node=tr.get(1);
        [reward,tr,GPmodel]=MCTS(node,tr,threshold,GPmodel,initial_hyper_para,fractal_distance,trigger_id);
        
        node.N=node.N+1;
        node.mu=((node.N-1)*node.mu+reward)/(node.N);
        
        cumulative_mu=[cumulative_mu,node.mu];
        iter=iter+1;
        if mod(iter,5)==0
            iter
        end
        id=find(eq(tr,node));
        tr=tr.set(id,node);
    end
end
toc

%% Identify the optimal ablation path
s_new = initial_state;
 for step=H-1:-1:1
    if coh0>=threshold
        break;
    end
    action_best=BestAction(node,tr,false,initial_hyper_para,threshold,trigger_id);    
    
    s_new=[s_new,action_best];
    coherence(s_new,0,trigger_id);
    node.state=s_new;
    node.h=step;
    node.alpha=alpha0;
    node.beta=beta0;
    node.mu=mu0;
    node.lambda=lambda0;
    node.N=N0;
    
    if ~isempty(find(eq(tr,node)))
        child_id=find(eq(tr,node));
        node=tr.get(child_id);
        coh0=node.coherence;
    else
        coh0=coherence(s_new,0,trigger_id);
    end
end
action_best=s_new;
save(strcat('action_best_trigger',num2str(trigger_id),'.mat'),'action_best')
