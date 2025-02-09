
function electrode=ForwardModel(loc,HITRI,HVER,heartEP)

%% Derive EGMs from action potentials
lent=size(heartEP,1);
no_elems=size(HITRI,1);

electrode=zeros(lent,length(loc));

for nb=1:length(loc)
    
    for elem = 1:no_elems
        % Identify nodes in element 'elem'
        n1 = HITRI(elem,1);
        n2 = HITRI(elem,2);
        n3 = HITRI(elem,3);
     
        avg=(heartEP(:,n1)+heartEP(:,n2)+heartEP(:,n3))/3;
        A=cross(HVER(n1,:)-HVER(n2,:),HVER(n1,:)-HVER(n3,:));       
        gradient=avg*A;
        center=(HVER(n1,:)+HVER(n2,:)+HVER(n3,:))/3;
        %calculate potential at the sensor locations on the heart surface    
        electrode(:,nb)=electrode(:,nb)+gradient*(HVER(loc(nb),:)-center)'/(norm(HVER(loc(nb),:)-center))^3;
    end
end
