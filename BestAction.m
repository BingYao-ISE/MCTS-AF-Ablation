function [action_best,tr]=BestAction(node,tr,sampling,initial_hyper_para,threshold,trigger_id)
%%
s=node.state;
id=find(eq(tr,node));

if id==1
    parent_s=[];
else
    parent_node=tr.get(tr.Parent(id));
    parent_s=parent_node.state;
end

A_s=Legal_action(s,parent_s,trigger_id);
for id=1:length(A_s)
    action=A_s{id};
    [q(id),tr]=Qvalue(node,tr,action,sampling,initial_hyper_para,threshold,trigger_id);
end

max_id=find(q==max(q));
id=randi(size(max_id));
action_best=A_s{max_id(id)};