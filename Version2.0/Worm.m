% Worm Peristaltic Motion
% Coded by Yifan Huang
% yxh649@case.edu
% Department of Mechanical and Aerospace Engineering
% Case Western Reserve University
clear; clc;

% Options -----------------------------------------------------------------
Option=[0   ... % 1/0: animation/analysis mode
    0    ... % 1/0: initial worm show/disappear
    1    ... % 1/0: view top/3D
    0    ... % 1/0: color future/life
    0];  ... % 1/0: video recording on/off
    
% Parameters --------------------------------------------------------------
Ns=6;            % number of segments
Nr=6;            % number of rhombuses per segment
StepTime=0.1;    % simulation step time, s
UnitTime=2;      % unit segment moving time, s
Wa=1;            % actuator spin velocity, rad/s
Rs=8.9;          % spool radius, mm
Lp=73;           % pipe length (node-node length), mm
betaL=46/180*pi;     % limiting angle between 2 pipes, rad
VideoName='Worm';    % if recording
IniState=[0 0 0];    % initial state, X coord / Y coord / body angle

% Constructions -----------------------------------------------------------
Lmax=2*Lp*cos(betaL/2)*cos(pi/2/Nr);    % max unit string length, mm
Lmin=2*Lp*cos((pi-betaL)/2)*cos(pi/2/Nr);    % min unit string length, mm
Zcenter=Lmax/4/sin(pi/2/Nr);   % center height (constant if no gravity)
gapIni=Lp*sin(betaL/2);   % initial distance between each two circles, mm
Lworm0=3*gapIni*(Ns-1);   % worm initial length, mm
Time=0;          % simulation time, s
theta=IniState(3)*ones(Ns,3);   % worm initial position angle, rad
Lst=Lmax*ones(Ns,2);    % string length, mm
Center=zeros(Ns,3,3);   % segments center coords
Node=zeros(Ns,3,Nr,3);   % #segment, #circle, #node, XYZ
for iC=1:Ns
    for jC=1:3
        Center(iC,jC,:)=[IniState(1);IniState(2);Zcenter]-(3*(iC-1)+jC-1)...
            *gapIni*[cos(theta(iC,jC));sin(theta(iC,jC));0];
    end
end
for iI=1:Ns
    for jI=1:3
        Node(iI,jI,:,:)=Circle(Nr,Lmax,Lmax,(-1)^(iI+jI-1),...
            squeeze(Center(iI,jI,:)),theta(iI,jI));
    end
end
hNode=cell(Ns,3,Nr);    % node handles
hString=cell(Ns,Nr);    % string handles
hPipe1=cell(Ns,3,Nr);    % pipe handles
hPipe2=cell(Ns,3,Nr);
hSkid=cell(Ns,1);        % skidmark handles
hBias=cell(Ns,2);       % bias plot handles
hAngle=cell(Ns-1,1);    % segments included angle handles
hVideo=VideoWriter(strcat(VideoName,'.avi'));

% Plots -------------------------------------------------------------------
figure('NumberTitle','off','Name','Worm Simulation',...
    'OuterPosition',get(0,'ScreenSize'));
if Option(1)
    plot3(0,0,0);
    hold on; axis equal; axis off; grid on;
    axis([-2*Lworm0 2*Lworm0 -2*Lworm0 2*Lworm0 0 2*Zcenter])
    [hNode,hString,hPipe1,hPipe2]=Construct(Ns,Nr,Node,0,Option(4),hNode,hString,hPipe1,hPipe2);
else
    subplot(3,4,[1,2,3,5,6,7,9,10,11])      % worm plot
    plot3(0,0,0);
    xlabel('X')
    ylabel('Y')
    title('Animation')
    hold on; axis equal; axis on; grid on;
    axis([-2*Lworm0 2*Lworm0 -2*Lworm0 2*Lworm0 0 2*Zcenter])
    if Option(3); view(0,90); end
    if Option(2)
        Construct(Ns,Nr,Node,1,0,hNode,hString,hPipe1,hPipe2);
    end
    [hNode,hString,hPipe1,hPipe2]=Construct(Ns,Nr,Node,0,Option(4),hNode,hString,hPipe1,hPipe2);
    hCenter=cell(Ns,3);
    for ii=1:Ns
        for jj=1:3
            hCenter{ii,jj}=plot3(Center(ii,jj,1),Center(ii,jj,2),Center(ii,jj,3),...
                'Marker','.','MarkerSize',20,'Color','m');
        end
    end
    subplot(3,4,4)      % skidmark plot
    plot3(0,0,0);
    title('SkidMark')
    axis equal; grid on;
    axis([-2*Lworm0 2*Lworm0 -2*Lworm0 2*Lworm0 0 2*Zcenter])
    if Option(3); view(0,90); end
    for iSk=1:Ns
        color=[iSk/Ns,1-iSk/Ns,Option(4)];
        hSkid{iSk}=animatedline('Color',color,'Linewidth',2);
    end
    subplot(3,4,8)      % bias plot
    for iB=1:Ns
        for jB=1:2
            hBias{iB,jB}=animatedline('Color',[iB/Ns,1-iB/Ns,Option(4)]);
        end
    end
    axis([0 50 0 1200])
    title('Bias Analysis')
    xlabel('Time/ s')
    ylabel('Segment Side Length / mm')
    subplot(3,4,12)      % included angle plot
    for iA=1:Ns-1
        hAngle{iA}=animatedline('Color','b');
    end
    axis([0 50 0 100*(Ns-1)])
    title('Turning Angle Analysis')
    xlabel('Time/ s')
    ylabel('Segments Included Angle / °')
end

% Components --------------------------------------------------------------
Handles={hNode,hString,hPipe1,hPipe2,hSkid,hBias,hAngle,hVideo,hCenter};
Parameter={Ns,Nr,StepTime,UnitTime,Lp,Lmax};
State={Node,Center,Lst,theta,Time};

% Actuator Inputs ---------------------------------------------------------
% Put in the same control methods that we put in the real actuators(AX-18A)
if Option(5); open(hVideo); end
Lleft=Lmax-UnitTime*70*pi/15*Rs/Nr;
Lright=Lmax-UnitTime*35*pi/15*Rs/Nr;
Control1=[Lleft,Lright,1;Lleft,Lright,2];
Control2=[Lmax,Lmax,1;Lleft,Lright,3];
Control3=[Lmax,Lmax,2;Lleft,Lright,4];
Control4=[Lmax,Lmax,3;Lleft,Lright,5];
Control5=[Lmax,Lmax,4;Lleft,Lright,6];
Control6=[Lmax,Lmax,5;Lleft,Lright,1];
Control7=[Lmax,Lmax,6;Lleft,Lright,2];
State=Move(Control1,Parameter,State,Option,Handles);
for loop=1:4
    State=Move(Control2,Parameter,State,Option,Handles);
    State=Move(Control3,Parameter,State,Option,Handles);
    State=Move(Control4,Parameter,State,Option,Handles);
    State=Move(Control5,Parameter,State,Option,Handles);
    State=Move(Control6,Parameter,State,Option,Handles);
    State=Move(Control7,Parameter,State,Option,Handles);
end
if Option(5); close(hVideo); end
