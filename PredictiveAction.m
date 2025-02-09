function [selected_action,GPmodel]=PredictiveAction(s0,parent_s,h0,GPmodel,threshold,fratal_distance,trigger_id)
%%
%generate 10 ablation sequence
const=1;
mseq=10;
Action_sequence{mseq,1}=[];

for i=1:mseq
    h=h0;
    s=s0;
    GP_mu=0;
    GP_var=0;
    A_s=Legal_action(s,parent_s,trigger_id);
    if isempty(A_s)
        continue
    end
    a_id=randi(length(A_s));
    action=A_s{a_id};
    Action_sequence{i,1}=action;         
    s_new=[s,action];
     [prob,mu S2]=GP_prediction(s_new,GPmodel,threshold,fratal_distance);
    GP_mu=GP_mu+prob;
    GP_var=GP_var+prob*(1-prob);
    h=h-1;
    while h>0
        A_s=Legal_action(s_new,s,trigger_id);
        if isempty(A_s)
            h=h-1;
            continue
        end
        a_id=randi(length(A_s));
        action=A_s{a_id};               
        s=s_new;
        s_new=[s,action];
        [prob,mu,S2]=GP_prediction(s_new,GPmodel,threshold,fratal_distance);   
        
        GP_mu=GP_mu+prob;
        GP_var=GP_var+prob*(1-prob);
        h=h-1;
    end
    UCT_GP(i)=(-GP_mu+const*sqrt(GP_var))/(h0-h);
end

if exist('UCT_GP','var') == 1
    max_id=find(UCT_GP==max(UCT_GP));
    selected_id=randi(size(max_id));
    selected_action=Action_sequence{max_id(selected_id)};
    
else
    selected_action=[];
end
