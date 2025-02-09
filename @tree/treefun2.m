function obj = treefun2(obj, val, fun)
%%TREEFUN2  Two-arguments function on trees, with scalar expansion.
    
%     [obj, val] = permuteIfNeeded(obj, val);
%     node_key=obj.Node;
%     for id=1:size(node_key,1)
%         node_key{id}=rmfield(node_key{id},{'state','h','alpha','beta','mu','lambda','N'});
%     end
%     val=rmfield(val,{'state','h','alpha','beta','mu','lambda','N'});
%      if isa(val, 'tree')
%         content = cellfun(fun, obj.Node, val.Node,'UniformOutput', false); 
%      else   
% %         content = cellfun(@(x) isequal(x, val), node_key,'UniformOutput', false);
%         content = cellfun(@(x) isempty(setdiff(x.action, val.action)), node_key,'UniformOutput', false);
%      end
    node_key=obj.Node;
%     content1 = cellfun(@(x) isempty(setdiff(x.action, val.action)), node_key,'UniformOutput', false);
%     content2 = cellfun(@(x) isequal(length(x.action), length(val.action)), node_key,'UniformOutput', false);
%     obj.Node = num2cell(cell2mat(content1).*cell2mat(content2));
    content = cellfun(@(x) isequal(x.state, val.state), node_key,'UniformOutput', false);
    obj.Node = num2cell(cell2mat(content));
end