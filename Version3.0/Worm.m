% Meshed-Body Worm Robot Simulation
% Coded by Yifan Huang
% yxh649@case.edu
% Department of Mechanical and Aerospace Engineering
% Case Western Reserve University
clear; clc;

% Options -----------------------------------------------------------------
Option=[0    ... % 1/0: View [Top/3D]
        0    ... % 1/0: Video Recording [On/Off]
        0    ... % 1/0: Color [Future/Life]
        0];  ... % 1/0: Initial Body [Display/Undisplay]
    
% Parameters --------------------------------------------------------------
Ns=6;            % Number of segments. (Larger than 3)
Nr=6;            % Number of rhombuses per segment. (Even & Larger than 2)
Rs=8.9;          % Spool radius (mm).
Lt=73;           % Tube length (Node-Node) (mm).
StepTime=0.1;    % Simulation time step, s
TubeAngle=60;    % Minimum included angle between two tubes (degree).
Time=0;          % Global simulation time (s).
State0=[0 0 0];  % Initial state [X-coord, Y-coord, body angle].
CF=[1 1 1];      % Correction factors [Straight; Turning; Cable].
VideoName='Worm';  % If recording. Saved in MATLAB current folder.

% Constructions -----------------------------------------------------------
TubeAngle=TubeAngle/180*pi;    % Minimum included angle between two tubes (rad).
Lmax=2*Lt*cos(TubeAngle/2)*cos(pi/2/Nr);    % Maximum cable length (mm).
Lmin=2*Lt*cos((pi-TubeAngle)/2)*cos(pi/2/Nr);    % Minimum cable length (mm).
Zcenter=Lmax/4/sin(pi/2/Nr);   % Center height (constant if no gravity).
Gap0=Lt*sin(TubeAngle/2);   % Initial distance between each two rings (mm).
Lworm0=3*Gap0*(Ns-1);   % Worm initial length (mm).
theta=State0(3)*ones(Ns,3);   % Worm initial position angle (rad).
Lc=Lmax*ones(Ns,2);    % Cable length (mm).
Center=zeros(Ns,3,3);   % Segments center coords.
Node=zeros(Ns,3,Nr,3);   % #Segment, #Ring, #Node, XYZ-Coord
for iC=1:Ns     % Rings' initial center coords.
    for jC=1:3
        Center(iC,jC,:)=[State0(1);State0(2);Zcenter]-...
            (3*(iC-1)+jC-2)*Gap0*[cos(theta(iC,jC));sin(theta(iC,jC));0];
    end
end
for iI=1:Ns     % All nodes initial coords.
    for jI=1:3
        Node(iI,jI,:,:)=Ring(Nr,[Lmax Lmax],(-1)^(iI+jI-1),...
            squeeze(Center(iI,jI,:)),theta(iI,jI));
    end
end
hNode=cell(Ns,3,Nr);    % Node handles.
hCable=cell(Ns,Nr);    % Cable handles.
hTube=cell(Ns,3,Nr,2);    % Tube handles.
hVideo=VideoWriter(strcat(VideoName,'.avi'));   % Video handle.


% Plots -------------------------------------------------------------------
figure('NumberTitle','off','Name','Worm Simulation',...
    'OuterPosition',get(0,'ScreenSize'));   % Main plot.
plot3(0,0,0);
hold on; axis equal; axis on; grid on;
axis([-2*Lworm0 2*Lworm0 -2*Lworm0 2*Lworm0 -10 2*Zcenter+10])
if Option(1); view(0,90); end
if Option(4); Construct(Ns,Nr,Node,1,0,hNode,hCable,hTube); end
[hNode,hCable,hTube]=Construct(Ns,Nr,Node,0,Option(3),hNode,hCable,hTube);

% Create more figures below to read and plot various data from the motion.

% An example of the plot of 1st Seg's center X-coord vs time.
figure
hTrack=animatedline('Color',[0 0.45 0.74]);
% This is the plotting handle to read data from "Move.m".
axis([0 45 0 300])
title('Example of Reading Data:  1st Seg''s Center X-Coord vs Time')
xlabel('Time (s)')
ylabel('1st Seg''s Center X-Coord (mm)')

% An example of the slip trajectory plot.
% Make sure codes for figure3 are enabled or disabled in both "Worm.m" and "Move.m".
%figure(3)
%hold on; axis equal;
%axis([-2*Lworm0 2*Lworm0 -2*Lworm0 2*Lworm0])


% Controls ----------------------------------------------------------------
% Control=[left ratio, right ratio, #seg;
%          left ratio, right ratio, #seg;
%          ......                        ]
% Make sure #seg exists. (No larger than 'Ns' as set in parameters)
% The actuator speed in the speed function will be multiplied by the left
%   and right separately ratio in the 'Control' matrix.
% Commands inside one 'Control' matrix are excuted during the same time.
Handles={hNode,hCable,hTube,hVideo,hTrack}; % All previous handles.
Parameter={Ns,Nr,Rs,Lt,StepTime,Lmax,CF,Option}; % Parameters.
State={Node,Center,Lc,theta,Time};  % Model's state.

if Option(2); open(hVideo); end
bias=0.5;   % Controlling bias. (0 for minimum bias; 1 for maximum bias)
bias=1-bias;
Control1=[-1,-bias,1;-1,-bias,2];
Control2=[1,bias,1;-1,-bias,3];
Control3=[1,bias,2;-1,-bias,4];
Control4=[1,bias,3;-1,-bias,5];
Control5=[1,bias,4;-1,-bias,6];
Control6=[1,bias,5;1,bias,6];
for loop=1:3    % Controlling loops.
    State=Move(Control1,Parameter,State,Handles);
    State=Move(Control2,Parameter,State,Handles);
    State=Move(Control3,Parameter,State,Handles);
    State=Move(Control4,Parameter,State,Handles);
    State=Move(Control5,Parameter,State,Handles);
    State=Move(Control6,Parameter,State,Handles);
end
if Option(2); close(hVideo); end
