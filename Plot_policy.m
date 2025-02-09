clear all
close all
clc

%%
addpath(genpath('Geometry_and_GPmodel'))
%% initialize node
initial_state=[];
trigger_id=590;

%% Plot ablation sequence
load(strcat('action_best_trigger',num2str(trigger_id),'.mat'))
load Geometry/Atria.mat
load laplacian.mat
t = Atria.faces;
X_data = Atria.vertices;
idx=[find(abs(lap(trigger_id,:))>0)];
m=zeros([size(X_data,1),1]);
m([idx])=63;

trisurf(t,X_data(:,1),X_data(:,2),X_data(:,3),m,'facecolor','interp','facealpha',0.6);
set(gca,'Cameraposition',[10,10,25],'LineWidth',2,'FontWeight','bold');
view([5 90]);
% lighting phong
colormap jet;
%  shading interp;
axis off tight equal;
hold on

scatter3(X_data((action_best),1),X_data(action_best,2),X_data(action_best,3),50,'r','filled')

%% Plot ablated dynamics
animation = 1;
figure
title('Ablated dynamics')
ECG_AF_ablated = simulator3D(action_best,animation,trigger_id);

%% Plot unablated dynamics
figure
title('Unablated dynamics')
ECG_AF = simulator3D(initial_state,animation,trigger_id);

%% Plot ablated ECG
load ECG_normal_0.05.mat
channel=2;
T=430;
figure('Position', [50 50 900 400])
plot(-electrode(1:T,channel),'LineWidth',1.5,'Color',[0.46,0.67,0.19]);
hold on 
ECG_AF_ablated=ECG_AF_ablated+normrnd(0,0.05*std(ECG_AF_ablated(:)),size(ECG_AF_ablated));      
ECG_AF=ECG_AF+normrnd(0,0.05*std(ECG_AF(:)),size(ECG_AF));

plot(-ECG_AF_ablated(1:T,channel),'LineWidth',1.5,'Color',[0.00,0.45,0.74])
plot(-ECG_AF(1:T,channel),'LineWidth',1.5,'Color',[0.50,0.50,0.50])
hold off
legend_ecg = legend('NSR', 'Ablated\_AF-optimal','Unablated\_AF');
xlabel('Time (unitless)')
ylabel('Electric potential (unitless)')
axis tight
set(gca,'FontSize',16,'LineWidth',1.5)
set(legend_ecg,'Position',[0.42 0.67 0.25 0.21]);