function ECG_AF=simulator3D(s,animation,trigger_id)
%%
load Geometry/Atria.mat
load Geometry/laplacian.mat

t = Atria.faces;
X_data = Atria.vertices;

sensor_location=[2328,1460,2256,1524,2383,823,1049,2231];
%% Parameter setting
para=[0.15,8,0.002,0.2,0.3];
e0=para(3); mu1=para(4); mu2=para(5); delta = 100;
a=para(1);
c=para(2);
deltaT = 0.05; % time-step delta T
T = 2150;

%% Set the conductivity of ablated locations as zero
ablation=s;
lap(ablation,:)=0;
lap(:,ablation)=0;
%%
lent = 2;
n = size(X_data,1);
warm_up_cycle=1;
 
%%  Initialize arrays
    u=zeros(n,1);    v=zeros(n,1);         
         
%%  Time-stepping procedure 

step=0;

N = T*(lent+warm_up_cycle); % total time steps


for nt=1:N        
    % stimulus current
    Iex=zeros(n,1);
    if rem(nt,T) < 10 && rem(nt,T)>0          
         idx=find(abs(lap(107,:))>0);
         Iex(idx) = 1;
    end  
    if nt>0
        if rem(nt,T/4)< 20      % AF stimulus       
            idx=find(abs(lap(trigger_id,:))>0);
            Iex(idx) = 1;           
        end
    end
    % Update right-hand-side of linear system---reaction
    F = c.*u.*(u-a).*(1-u)-u.*v +Iex;
    G = (e0+mu1*v./(u+mu2)).*(-v-c.*u.*(u-a-1));
    u = u + deltaT*(F+delta*(lap*u));
    v = v + deltaT*G;
   
    
    
     if animation==1 && nt>warm_up_cycle*T    
        m=1+round(63*u); m=max(m,1); m=min(m,64);
        m(ablation)=65;
               
        trisurf(t,X_data(:,1),X_data(:,2),X_data(:,3),m,'facecolor','interp');
        set(gca,'Cameraposition',[10,10,25],'LineWidth',2,'FontWeight','bold');
%         view([-225 -4]);
        view([57 86])
        lighting phong
%         colormap([jet(64);0 0 0]);
        colormap(jet(64));
        shading interp;
        axis off tight equal;
        drawnow
    end
    if rem(nt,10) == 1 && nt>warm_up_cycle*T    
        step=step+1;
        U(step,:) = u;  
    end
    
end

clear u v m Iex

ECG_AF=ForwardModel(sensor_location,t,X_data,U);


