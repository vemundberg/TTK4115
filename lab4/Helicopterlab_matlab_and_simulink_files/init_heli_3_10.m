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
V_s0 = 9; % Elevation equilibrium
J_p = 2*m_p*l_p^2; %Moment of inertia [kg m^2]
J_e = m_c*l_c*l_c + 2*m_p*l_h*l_h; %Moment of inertia [kg m^2]
J_lambda=(m_c*l_c*l_c) + 2*m_p*(l_h*l_h+l_p*l_p); %Moment of inertia [kg m^2]
L_1 = l_p * K_f; %Constant
L_3 = l_h * K_f; %Constant
L_4 = (K_f * l_h)/J_lambda; %Constant
K_1 = L_1/J_p; %Constant
K_2 = L_3/J_e; %Constant
K_3 = (L_4*V_s0)/J_lambda; %Constant


%%%%%%%%%%%%%%%%%%%%%%%%
% Lab day 1 %
%%%%%%%%%%%%%%%%%%%%%%%%

lambda1 = -1; %Pole 1
lambda2 = -2; %Pole 2
K_pd = -(lambda1 + lambda2)/K_1;
K_pp = lambda1*lambda2/K_1;


%%%%%%%%%%%%%%%%%%%%%%%%
% Task 2 poleplacement %
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
% A = [0 1 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 1 0 0 0 0; 0 0 1 0 0];
% B = [0 0 ; 0 K_1; K_2 0; 0 0; 0 0];
% Q = [50 0 0 0 0; 0 20 0 0 0; 0 0 170 0 0; 0 0 0 100 0; 0 0 0 0 15];
% R = [5 0; 0 10;];
% K = lqr(A,B,Q,R);
% G = [0 0; 0 0; 0 0; -1 0; 0 -1];
% 
% A2 = [0 1 0 0 0;0 0 0 0 0;0 0 0 1 0;0 0 0 0 0;K_3 0 0 0 0];
% B2 = [0 0 ; 0 K_1;0 0; K_2 0;0 0];
% C = [1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0; 0 0 0 1 0;0 0 0 0 1];
% p2 = [-5+5*sqrt(3)*i -5-5*sqrt(3)*i -5-5*i -5+5*i -10];
% L = place(A2.',C.',p2).';
% K = lqr(A,B,Q,R);
% F = [K(1,1) K(1,3); K(2,1) K(2,3)];
% PORT = 7;

%%%%%%%%%%%%%%%%%%%%%
% Kalmanfilter %
%%%%%%%%%%%%%%%%%%%%%
% A_d = [0 1 0 0 0 0;0 0 0 0 0 0;0 0 0 1 0 0;0 0 0 0 0 0;0 0 0 0 0 0;K_3 0 0 0 0 0];
% B_d = [0 0 ; 0 K_1;0 0; K_2 0;0 0;0 0];
% C_d = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 0 1];
% 
% R_d = cov([pitch' pitchrate' elev' elevrate' travrate']);
% D = 0;
% sys = ss(A_d, B_d, C_d, D);
% sys_d = c2d(sys,0.002);
% 
% [A_d,B_d,C_d] = ssdata(sys_d);
% Q_d = [0.00002 0 0 0 0 0;0 0.00005 0 0 0 0;0 0 0.00001 0 0 0;0 0 0 0.00005 0 0;0 0 0 0 0.00005 0;0 0 0 0 0 0.00005];



% %plot kalmanfilter
% kalmanfilter = load('Q_matrix_switch.mat');
% t = kalmanfilter.ans(1,:);
% 
% %IMU
% apitch = kalmanfilter.ans(2,:);
% eulpitchrate = kalmanfilter.ans(5,:);
% aelev = kalmanfilter.ans(8,:);
% eulelevrate = kalmanfilter.ans(11,:);
% eultravrate = kalmanfilter.ans(14,:);
% 
% 
% 
% %Kalman
% kpitch = kalmanfilter.ans(3,:);
% kpitchrate = kalmanfilter.ans(6,:);
% kelev = kalmanfilter.ans(9,:);
% kelevrate = kalmanfilter.ans(12,:);
% ktravrate = kalmanfilter.ans(15,:);
% 
% %encoder
% enpitch = kalmanfilter.ans(4,:);
% enpitchrate = kalmanfilter.ans(7,:);
% enelev = kalmanfilter.ans(10,:);
% enelevrate = kalmanfilter.ans(13,:);
% entravrate = kalmanfilter.ans(16,:);
% 
% 
% 
% subplot(5,1,1);
% plot(t,apitch,'g');
% hold on;
% plot(t,enpitch,'b');
% hold on;
% plot(t,kpitch,'r');
% hold off;
% title('Pitch');
% xlabel('t [s]');
% ylabel('Pitch [rad]');
% legend('Measure', 'Encoder', 'Kalman');
% grid on;
% 
% subplot(5,1,2);
% 
% plot(t,eulpitchrate,'g');
% hold on;
% plot(t,enpitchrate,'b');
% hold on;
% plot(t,kpitchrate,'r');
% hold off;
% title('Pitch rate');
% xlabel('t [s]');
% ylabel('Pitch rate [rad/s]');
% legend('Measure', 'Encoder', 'Kalman');
% grid on;
% 
% subplot(5,1,3);
% plot(t,aelev,'g');
% hold on;
% plot(t,enelev,'b');
% hold on;
% plot(t,kelev,'r')
% hold off;
% title('Elevation');
% xlabel('t [s]');
% ylabel('Elevation [rad]');
% legend('Measure', 'Encoder', 'Kalman');
% grid on;
% 
% subplot(5,1,4);
% plot(t,eulelevrate,'g');
% hold on;
% plot(t,enelevrate,'b');
% hold on;
% plot(t,kelevrate,'r');
% hold off;
% title('Elevation rate');
% xlabel('t [s]');
% ylabel('Elevation rate [rad/s]');
% legend('Measure', 'Encoder', 'Kalman');
% grid on;
% 
% subplot(5,1,5);
% plot(t,eultravrate,'g');
% hold on;
% plot(t,entravrate,'b');
% hold on;
% plot(t,ktravrate,'r');
% hold off;
% title('Travel rate');
% xlabel('t [s]');
% ylabel('Travel rate [rad/s]');
% legend('Measure', 'Encoder', 'Kalman');
% grid on;

elev1 = load('integral_elevation');
elev2 = load('uten_integral_elevation');

t1 = elev1.ans(1,:);
t2 = elev2.ans(1,:);

elevintegral = elev1.ans(2,:);
elevnei = elev2.ans(2,:);

subplot(2,1,1);
plot(t2,elevnei);
xlabel('t [s]');
ylabel('elevation [rad]');
grid on;
legend('Elevation');
title('No Integral');


subplot(2,1,2);
plot(t1,elevintegral);
xlabel('t [s]');
ylabel('elevation [rad]');
grid on;
legend('Elevation');
title('Integral');






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


