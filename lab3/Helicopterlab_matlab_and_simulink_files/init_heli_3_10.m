% FOR HELICOPTER NR 3-10
% This file contains the initialization for the helicopter assignment in
% the course TTK4115. Run this file before you execute QuaRC_ -> Build 
% to build the file heli_q8.mdl.

% Oppdatert høsten 2006 av Jostein Bakkeheim
% Oppdatert høsten 2008 av Arnfinn Aas Eielsen
% Oppdatert høsten 2009 av Jonathan Ronen
% Updated fall 2010, Dominik Breu
% Updated fall 2013, Mark Haring
% Updated spring 2015, Mark Haring


%%%%%%%%%%% Calibration of the encoder and the hardware for the specific
%%%%%%%%%%% helicopter
Joystick_gain_x = 1;
Joystick_gain_y = -1;


%%%%%%%%%%% Physical constants
g = 9.81; % gravitational constant [m/s^2]
l_c = 0.46; % distance elevation axis to counterweight [m]
l_h = 0.66; % distance elevation axis to helicopter head [m]
l_p = 0.175; % distance pitch axis to motor [m]
m_c = 1.92; % Counterweight mass [kg]
m_p = 0.72; % Motor mass [kg]
K_f = 0.199; % Motor force constant [N/V]
V_s0 = 8;
J_p = 2*m_p*l_p^2; %Moment of inertia [kg m^2]
J_e = m_c*l_c*l_c + 2*m_p*l_h*l_h;
J_lambda=(m_c*l_c*l_c) + 2*m_p*(l_h*l_h+l_p*l_p);
L_1 = l_p * K_f; %Constant
L_3 = l_h * K_f; %Constant
L_4 = (K_f * l_h)/J_lambda;
K_1 = L_1/J_p; %Constant
K_2 = L_3/J_e;
K_3 = (L_4*V_s0)/J_lambda;

%%%%%%%%%%%%%%%%%%%%%%%%
% Lab day 1 %
%%%%%%%%%%%%%%%%%%%%%%%%

lambda1 = -1; %Pole 1
lambda2 = -2; %Pole 2
K_pd = -(lambda1 + lambda2)/K_1; %K_pd
K_pp = lambda1*lambda2/K_1; %K_pp


%%%%%%%%%%%%%%%%%%%%%%%%
% LAB 2 poleplacement %
%%%%%%%%%%%%%%%%%%%%%%%%

%A = [0 1 0; 0 0 0; 0 0 0];
%B = [0 0 ; 0 K_1; K_2 0];
% p = [-1+i -1-i -1];
% K = place(A,B,p);

%%%%%%%%%%%%%%%%%%%%%%%%
% LQR without integral %
%%%%%%%%%%%%%%%%%%%%%%%%
% A = [0 1 0; 0 0 0; 0 0 0];
% B = [0 0 ; 0 K_1; K_2 0];
% Q = [10 0 0; 0 2 0; 0 0 80];
% R = [0.5 0; 0 0.6];

%%%%%%%%%%%%%%%%%%%%%
% LQR with integral %
%%%%%%%%%%%%%%%%%%%%%
% % A = [0 1 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 1 0 0 0 0; 0 0 1 0 0];
% % B = [0 0 ; 0 K_1; K_2 0; 0 0; 0 0];
% % Q = [50 0 0 0 0; 0 20 0 0 0; 0 0 170 0 0; 0 0 0 100 0; 0 0 0 0 15];
% % R = [5 0; 0 10;];
% K = lqr(A,B,Q,R);
% F = [K(1,1) K(1,3); K(2,1) K(2,3)];
% G = [0 0; 0 0; 0 0; -1 0; 0 -1];

%%%%%%%%%%%%%%%%%%%%%%%%
% LAB 3 Luenberger %
%%%%%%%%%%%%%%%%%%%%%%%%
PORT = 7;
A2 = [0 1 0 0 0;0 0 0 0 0;0 0 0 1 0;0 0 0 0 0;K_3 0 0 0 0];
B2 = [0 0 ; 0 K_1;0 0; K_2 0;0 0];
A = [0 1 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 1 0 0 0 0; 0 0 1 0 0];
B = [0 0 ; 0 K_1; K_2 0; 0 0; 0 0];
Q = [50 0 0 0 0; 0 20 0 0 0; 0 0 220 0 0; 0 0 0 100 0; 0 0 0 0 15];
R = [5 0; 0 10;];
K = lqr(A,B,Q,R);
F = [K(1,1) K(1,3); K(2,1) K(2,3)];
C = [1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0 ; 0 0 0 1 0 ; 0 0 0 0 1];
p2 = [-5+10*sqrt(3)*i -5-10*sqrt(3)*i -5-7*i -5+7*i -10];
%p2 = [-1+i -1-i -10 -10 -1];
L = place(A2.',C.',p2).';





