% FOR HELICOPTER NR 3-10
% This file contains the initialization for the helicopter assignment in
% the course TTK4115. Run this file before you execute QuaRC_ -> Build 
% to build the file heli_q8.mdl.

% Oppdatert h�sten 2006 av Jostein Bakkeheim
% Oppdatert h�sten 2008 av Arnfinn Aas Eielsen
% Oppdatert h�sten 2009 av Jonathan Ronen
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
L_1 = l_p * K_f; %Constant
L_3 = l_h * K_f; %Constant
J_p = 2*m_p*l_p^2; %Moment of inertia [kg m^2]
J_e = m_c*l_c*l_c + 2*m_p*l_h*l_h;
K_1 = L_1/J_p; %Constant
K_2 = L_3/J_e;

%%%%%%%%%%%%%%%%%%%%%%%%
% Lab day 1 %
%%%%%%%%%%%%%%%%%%%%%%%%

lambda1 = -1; %Pole 1
lambda2 = -2; %Pole 2
K_pd = -(lambda1 + lambda2)/K_1; %K_pd
K_pp = lambda1*lambda2/K_1; %K_pp


%%%%%%%%%%%%%%%%%%%%%%%%
% Task 2 poleplacement %
%%%%%%%%%%%%%%%%%%%%%%%%

% A = [0 1 0; 0 0 0; 0 0 0];
% B = [0 0 ; 0 K_1; K_2 0];
% p = [-1+i -1-i -1];
% K = place(A,B,p);
% F = [K(1,1) K(1,3); K(2,1) K(2,3)];

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
A = [0 1 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 1 0 0 0 0; 0 0 1 0 0];
B = [0 0 ; 0 K_1; K_2 0; 0 0; 0 0];
Q = [50 0 0 0 0; 0 20 0 0 0; 0 0 170 0 0; 0 0 0 100 0; 0 0 0 0 15];
R = [5 0; 0 10;];


K = lqr(A,B,Q,R);
F = [K(1,1) K(1,3); K(2,1) K(2,3)];
G = [0 0; 0 0; 0 0; -1 0; 0 -1];

elevrate = load('test216_elev_rate.mat');
pitch = load('test216_pitch.mat');

t1 = elevrate.ans(1,:);
t2 = pitch.ans(1,:);
elevr = elevrate.ans(2,:);
pitc = pitch.ans(2,:);

% subplot(2,1,1);
% plot(t1,integralelevation,'b');
% hold on;
% plot(t1,integralref,'r');
% hold off;
% title('Integral');
% xlabel('t [s]');
% ylabel('Elevation rate [rad/s]');
% legend('Elevation', 'Elevation rate ref');
% 
% subplot(2,1,2);
% plot(t2,nointegralelevation,'b');
% hold on;
% plot(t2,nointegralref,'r');
% title('No integral');
% xlabel('t [s]');
% ylabel('Elevation rate [rad/s]');
% legend('Elevation', 'Elevation rate ref');
