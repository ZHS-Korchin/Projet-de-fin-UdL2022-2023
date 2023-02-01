function X = PRBDM_3R_DynamicsPID(in4dyn)

% Joint positions
q1 = in4dyn(1);
q2 = in4dyn(2);
q3 = in4dyn(3);

% Joint velocities
dq1 = in4dyn(4);
dq2 = in4dyn(5);
dq3 = in4dyn(6);

% Joint Torques
Tau1 = in4dyn(7);
Tau2 = in4dyn(8);
Tau3 = in4dyn(9);

% Robot Parameters
g0 = 9.81;
E = 1.38e9;

m = in4dyn(10);
L = in4dyn(11);
gama0 = in4dyn(12);
gama1 = in4dyn(13);
gama2 = in4dyn(14);
gama3 = in4dyn(15);
k1 = in4dyn(16);
k2 = in4dyn(17);
k3 = in4dyn(18);
I = in4dyn(19);
W = in4dyn(20);
theta1d = in4dyn(21);
theta2d = in4dyn(22);
theta3d = in4dyn(23);

% Joint Position, Velocity and Torque Vectors

 q = [ q1;q2;q3];
 thetad = [ theta1d;theta2d;theta3d];
 dq = [dq1;dq2;dq3];
 Tau = [ Tau1;Tau2;Tau3];
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
Rparams4rigid =[];
Rparams4rigid(1) = m*gama1;
 Rparams4rigid(2) = m*gama2;
 Rparams4rigid(3) = m*gama3;
 Rparams4rigid(4) = L*gama1;
 Rparams4rigid(5) = L*gama2;
 Rparams4rigid(6) = L*gama3;
 Rparams4rigid(7) = W;
 
Rparams4PRBDM =[];
Rparams4PRBDM(1) = m ;
Rparams4PRBDM(2) = L ;
Rparams4PRBDM(3) = gama0 ;
Rparams4PRBDM(4) = gama1;
Rparams4PRBDM(5) = gama2;
Rparams4PRBDM(6) = gama3;
Rparams4PRBDM(7) = k1;
Rparams4PRBDM(8) = k2;
Rparams4PRBDM(9) = k3;
Rparams4PRBDM(10) = I;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Dynamics of planar 3-link robot arm  (Lagrange)
[A,B,C,D] = PRBDM_3R_Dynamic_Matrices_Lagrange(q,Rparams4PRBDM);

dqi = [dq1;dq1;dq2];
dqj = [dq2;dq3;dq3]; 
dqidqj = dqi.*dqj;
% %ddq = inv(A)*(-B*(dq.^2) - C*dqidqj - D*q +T);
% disp(dq);
% ddq = A\(-B*(dq.^2) - C*dqidqj - D*q +T);
% 
% dX = [dq;ddq];

f  = [dq;          pinv(A)*(-B*(dq.^2) - C*dqidqj - D*q)];
g  = [zeros(3,3);  pinv(A)];

e = thetad - q;     Kp = 100;
de = - dq;          Kd = 20;
PID = Kp * e + Kd * de;
uk = B * [dq1^2; dq2^2; dq3^2] + C * [dq1 * dq2; dq1 * dq3; dq2 * dq3] + D*q + A*PID;
%x(:,i+1) = xk  + t_step * (f + g * uk);

X = [q;dq] + 0.001*(f+g*uk);
X = [X ; uk];
%dX = f+g*uk;
