function A_s=Legal_action(s,parent_s,trigger_id)
%%
load Geometry/laplacian.mat;
Action_s=[];

%%
if isempty(s)
    load(['Action_space_reduced_trigger_',num2str(trigger_id),'.mat'])
    A_s=num2cell(Action_space_reduced); 
else % Generate 2 subsequent potential ablation site
   A_s={};
    [junk,ia,ib]=intersect(s,parent_s);   
    s(ia)=[];
    if length(s)==1
        Action_s=[Action_s,find(abs(lap(s,:))>0)];
    else
        for id=1:length(s)
            if isempty(find(abs(lap(parent_s,s(id)))>0))
                Action_s=[Action_s,find(abs(lap(s(id),:))>0)];
            end
        end
    end
    if isempty(Action_s)
        for id=1:length(s)            
            Action_s=[Action_s,find(abs(lap(s(id),:))>0)];
        end
    end
    Action_s=unique(Action_s);
    trigger=find(abs(lap(trigger_id,:))>0);
    [junk,ia,ib] = intersect(Action_s,trigger);
    Action_s(ia)=[];  
    [junk,ia,ib] = intersect(Action_s,[s,parent_s]);
    Action_s(ia)=[];

    if isempty(Action_s)
         Action_s=[Action_s,find(abs(lap(s(1),:))>0)];
         [junk,ia,ib] = intersect(Action_s,trigger);
         Action_s(ia)=[];
    end
    for id=1:length(Action_s)
        id_overlap=[];
        action=find(lap(Action_s(id),:)>0);
        [junk,ia,ib] = intersect(action,trigger);
        action(ia)=[];  
        [junk,ia,ib] = intersect(action,[s,parent_s]);
        action(ia)=[];
        for ida=1:length(action)
            if ~isempty(find(abs(lap(s,action(ida)))>0)) 
                id_overlap=[id_overlap,ida];
            end
        end
        action(id_overlap)=[];
        if ~isempty(action)
            action_p=action(1);
            
        end

        if length(action)<=1
            A_s{end+1}=[Action_s(id),action];
        else
            A_s{end+1}=[Action_s(id),action_p];
        end
    end
        if isempty(A_s)
            A_s=num2cell(Action_s);
        end

end
    