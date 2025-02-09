function PD_k=PD_kernel(theta1,theta2,C1,C2,D1,D2,ref_id)

 phi_x = exp(-C1/(theta1^2)-C2/(theta2^2));
 phi_y = exp(-D1/(theta1^2)-D2/(theta2^2));
 PD_k=phi_x*phi_y'/ref_id;