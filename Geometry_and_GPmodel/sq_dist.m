
function [C1,C2] = sq_dist(a, b, distance_L2)
%%
%load distance_L2.mat

d_1=size(a,1);
d_2=size(b,1);
for i=1:d_1
    for j=1:d_2
        temp1=a(i,1:end-1);
        temp2=b(j,1:end-1);        
        C1(i,j)=(max(max(min(distance_L2(temp1==1,temp2==1),[],2)),max(min(distance_L2(temp2==1,temp1==1),[],2))))^2/2;
        C2(i,j)=(a(i,end)-b(j,end))^2/2;
    end
end
