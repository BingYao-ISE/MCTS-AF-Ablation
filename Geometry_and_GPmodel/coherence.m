function coh=coherence(s,animation,trigger_id)
%%
load Auxiliary_data/ECG_normal_0.05.mat
ECG_AF=simulator3D(s,animation,trigger_id);
ECG_norm=electrode;
Cxy = coherence_measure_3d(ECG_norm,ECG_AF);
coh=min(Cxy);
    