function [reward,GPmodel,action_selected,coh_after]=Rollout(s,parent_s,h,GPmodel,threshold,distance_L2,trigger_id)
reward=0;
h0=h;
while h>0 %&& coh<threshold
    action=PredictiveAction(s,parent_s,h,GPmodel,threshold,distance_L2,trigger_id);
    if isempty(action)
        reward=-h+reward;
        break
    end
    parent_s=s;       
    s=[parent_s,action];

    coh=coherence(s,0,trigger_id);

    if coh>=threshold
       temp_reward=binornd(1,0.95)-1;
    else
       temp_reward=-1;
    end
    reward=reward+temp_reward;
    
    if h==h0
       action_selected=action;
       coh_after=coh;
    end
    h=h-1;
    GPmodel=GPupdate(GPmodel,s,coh,distance_L2);
end