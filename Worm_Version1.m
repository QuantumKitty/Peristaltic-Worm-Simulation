% Worm Peristaltic Motion
% Coded by Yifan Huang
% yxh649@case.edu
% Department of Mechanical and Aerospace Engineering
% Case Western Reserve University
function []=Worm()
clear; clc;
promptPara={'#Segments: [3,+inf)','#Rhombuses/Segment: [6,+inf) (even)'...
    ,'WaveLength: [3,+inf)','Turn Unit:','StepTime:','Motor Speed:',...
    'Spool Radius:','Pipe Length:','Angle Limit: [15,90)'};
defPara={'6','6','3','10','0.1','1','38','70','60'};
parameter=inputdlg(promptPara,'Parameters',repmat([1 40],9,1),defPara);
Ns=str2double(parameter{1});
Nr=str2double(parameter{2});
WaveLength=str2double(parameter{3});
Unit=str2double(parameter{4})*pi/180;
StepTime=str2double(parameter{5});
Wa=str2double(parameter{6});
Rs=str2double(parameter{7});
Lp=str2double(parameter{8});
betaL=str2double(parameter{9})*pi/180;
if ~(Ns>3&&Nr>4&&~mod(Nr,2)&&betaL>14*pi/180&&betaL<90*pi/180)
    errordlg('Input Error!','Error');
    error('Input Error');
end
MoIns='Motion Instruction: (P-Progress, T-Turn, Minus-backward or left)';
promptMO={MoIns,'View: (1/top , 0/3D)',...
    'SkidMark: (1/on , 0/off)','Color: (1/future , 0/life)'};
defMO={'P1 T120 P1.5','0','1','0'};
MO=inputdlg(promptMO,'Motion&Option',repmat([1 40],4,1),defMO);
Option=[str2double(MO{2}) str2double(MO{3}) str2double(MO{4})];
Motion=MO{1};
for iE=1:length(Motion)
    e=Motion(iE);
    if strcmp(num2str(str2double(e)),'NaN')...
            &&e~='P'&&e~='T'&&e~=' '&&e~='-'&&e~='+'&&e~='.'
        errordlg('Input Error!','Error');
        error('Input Error');
    end
end
Lmax=2*Lp*cos(betaL/2)*cos(pi/2/Nr);
Lmin=2*Lp*cos((pi-betaL)/2)*cos(pi/2/Nr);
Zcenter=Lmax/4/sin(pi/2/Nr);
Vstring=2*Wa*Rs/Nr;
step=Vstring*StepTime;
gap=3*Lp*sin(betaL/2);
Lworm0=gap*(Ns-1);
Center=zeros(Ns,3);
theta=-pi/3;
Time=0;
for iS=1:Ns
    Center(iS,:)=[0;0;Zcenter]-(iS-1)*gap*[cos(theta);sin(theta);0];
end
Node=Nodes(Ns,Nr,Lmax*ones(1,Ns),Center,theta);
hNode=cell(Ns,3,Nr);
hString=cell(Ns,Nr);
hPipe1=cell(Ns,3,Nr);
hPipe2=cell(Ns,3,Nr);
hSkid=cell(Ns,1);
hBias=cell(Ns,2);
figure('NumberTitle','off','Name','Worm Simulation',...
    'OuterPosition',get(0,'ScreenSize'));
subplot(2,3,[1,2,4,5])
plot3(0,0,0);
hold on; axis equal; axis on; grid on;
axis([-2*Lworm0 2*Lworm0 -2*Lworm0 2*Lworm0 0 2*Zcenter]);
if Option(1); view(90,90); else view(-37.5,30); end
for iN=1:Ns
    for jN=1:3
        for kN=1:Nr
            hNode{iN,jN,kN}=plot3(Node(iN,jN,kN,1),Node(iN,jN,kN,2),...
                Node(iN,jN,kN,3),'Color','k','Marker','.','MarkerSize',25);
        end
    end
end
for iP=1:Ns
    for jP=1:3
        if iP==Ns&&jP==3; break;end
        color=[(3*(iP-1)+jP)/3/Ns,1-(3*(iP-1)+jP)/3/Ns,Option(3)];
        for kP=1:Nr
            if jP==2; hString{iP,kP}=plot3(...
                    [Node(iP,jP,kP,1),Node(iP,jP,mod(kP,Nr)+1,1)],...
                    [Node(iP,jP,kP,2),Node(iP,jP,mod(kP,Nr)+1,2)],...
                    [Node(iP,jP,kP,3),Node(iP,jP,mod(kP,Nr)+1,3)],...
                    'Color','b','LineWidth',1);
            end
            iP1=iP+floor(jP/3);
            jP1=mod(jP,3)+1;
            kP1=kP+(-1)^(iP+jP);
            kP2=kP1+Nr*(fix((Nr-kP1)/Nr)-fix(kP1/(Nr+1)));
            hPipe1{iP,jP,kP}=plot3(...
                [Node(iP,jP,kP,1),Node(iP1,jP1,kP,1)],...
                [Node(iP,jP,kP,2),Node(iP1,jP1,kP,2)],...
                [Node(iP,jP,kP,3),Node(iP1,jP1,kP,3)],...
                'Color',color,'LineWidth',2);
            hPipe2{iP,jP,kP}=plot3(...
                [Node(iP,jP,kP,1),Node(iP1,jP1,kP2,1)],...
                [Node(iP,jP,kP,2),Node(iP1,jP1,kP2,2)],...
                [Node(iP,jP,kP,3),Node(iP1,jP1,kP2,3)],...
                'Color',color,'LineWidth',2);
        end
    end
end
if Option(2)
    for iSk=1:Ns
        color=[iSk/Ns,1-iSk/Ns,Option(3)];
        hSkid{iSk}=animatedline('Color',color,'Linewidth',2);
    end
end
subplot(2,3,3)
for iB=1:Ns
    for jB=1:2
        hBias{iB,jB}=animatedline('Color',[iB/Ns,1-iB/Ns,Option(3)]);
    end
end
axis([0 200 0 1200]);
xlabel('time/ s');
ylabel('segment side length/ mm');
subplot(2,3,6)
hDisp=animatedline('Color','b');
axis([0 200 0 1400]);
xlabel('time/ s');
ylabel('displacement/ mm');
Parameter={Ns,Nr,WaveLength,Unit,StepTime,step,Lmax,Lmin,Lp};
State={Node,Center,theta,Time};
Handles={hNode,hString,hPipe1,hPipe2,hSkid,hBias,hDisp};
pause(1);
for iM=1:length(Motion)
    if Motion(iM)=='P'
        for jM=iM:length(Motion)
            if Motion(jM)==' '
                Journey=str2double(Motion(iM+1:jM-1))*Lworm0; break
            elseif jM==length(Motion)
                Journey=str2double(Motion(iM+1:jM))*Lworm0; break
            end
        end
        State=Progress(Journey,Parameter,State,Handles);
    elseif Motion(iM)=='T'
        for jM=iM:length(Motion)
            if Motion(jM)==' '
                Angle=str2double(Motion(iM+1:jM-1))*pi/180; break
            elseif jM==length(Motion)
                Angle=str2double(Motion(iM+1:jM))*pi/180; break
            end
        end
        State=Turn(Angle,Parameter,State,Handles);
    end
end

function State=Progress(Journey,Parameter,State,Handles)
[Ns,Nr,WaveLength,StepTime,step,Lmax,Lmin,Lp]=Parameter{[1:3,5:9]};
[Node,Center,theta,Time]=State{:};
[Lst,Lst0]=deal(Lmax*ones(1,Ns));
period=3*(Lmax-Lmin)/WaveLength;
dir=sign(Journey);
head=((1-Ns)*dir+1+Ns)/2;
headC=Center(head,:);
Center0=Center;
[iM,iR]=deal(0);
while iR<Ns
    iM=iM+1;
    for jM=0.01:step:period
        for iB=1:Ns
            for jB=1:2
                kNr=3*jB-1/2+(-1)^iB/2;
                Lside=norm(squeeze(Node(iB,1,kNr,1:2)-Node(iB,3,kNr,1:2)));
                addpoints(Handles{6}{iB,jB},Time,Lside+200*(iB-1));
            end
        end
        addpoints(Handles{7},Time,norm(Center(1,1:2)-[0 0]));
        for kM=1:Ns
            iM1=ceil((mod(iM-kM,WaveLength)*period+jM)/(Lmax-Lmin));
            kMM=~(dir+1)*(Ns+1)+dir*kM;
            if kM<=iM && iM1~=3
                Lst0(kMM)=Lst0(kMM)+(-1)^iM1*step;
            else   Lst0(kMM)=Lmax;
            end
        end
        Center1=Center0;
        [kM3,kM6]=deal(0);
        for kM1=1:Ns
            if Lst0(kM1)==Lmax
                if kM3==0; kM3=kM1; end
                for kM2=kM1-1:-1:1
                    if Lst0(kM2)==Lmax; break
                    else deltaL=sqrt(9*Lp^2-(6*pi*Lst0(kM2)*Lst0(kM2+1)...
                            /Nr/(Lst0(kM2)+Lst0(kM2+1)))^2);
                        Center0(kM2,:)=Center0(kM2+1,:)'+...
                            [cos(theta);sin(theta);0]*deltaL;
                    end
                end
            end
        end
        for kM4=Ns:-1:1
            if Lst0(kM4)==Lmax
                if kM6==0; kM6=kM4; end
                for kM5=kM4+1:Ns
                    if Lst0(kM5)==Lmax; break
                    else deltaL=sqrt(9*Lp^2-(6*pi*Lst0(kM5)*Lst0(kM5-1)...
                            /Nr/(Lst0(kM5)+Lst0(kM5-1)))^2);
                        Center1(kM5,:)=Center1(kM5-1,:)'-...
                            [cos(theta);sin(theta);0]*deltaL;
                    end
                end
            end
        end
        Center0(kM6+1:Ns,:)=Center1(kM6+1:Ns,:);
        Center0(kM3:kM6,:)=(Center0(kM3:kM6,:)+Center1(kM3:kM6,:))/2;
        sub=[~(dir-1)*iR+1,Ns-~(dir+1)*iR];
        sub0=sub(-dir/2+3/2);
        if norm(Center0(head,:)-headC)>abs(Journey)&&Lst0(sub0)<Lmax
            Center(sub(1):sub(2),:)=Center0(sub(1):sub(2),:);
            Lst(sub(1):sub(2))=Lst0(sub(1):sub(2));
        elseif norm(Center0(head,:)-headC)>abs(Journey)&&Lst0(sub0)>=Lmax
            iR=iR+1;
            Center(sub0,:)=Center0(sub0,:);
            Center(sub(1):sub(2),:)=Center0(sub(1):sub(2),:);
            Lst(sub0)=Lmax;
            Lst(sub(1):sub(2))=Lst0(sub(1):sub(2));
        else Center=Center0;
            Lst=Lst0;
        end
        Node=Nodes(Ns,Nr,Lst,Center,theta);
        Update(Ns,Nr,Node,Handles{1:4});
        Time=Time+StepTime;
        drawnow;
        if iR==Ns; break; end
    end
end
State={Node,Center,theta,Time};

function State=Turn(Angle,Parameter,State,Handles)
[Ns,Nr,Unit,Lmax]=Parameter{[1 2 4 7]};
[Node,Center,theta,Time]=State{:};
dir=sign(Angle);
NoSegT=round(abs(Angle)/Unit/2);  
Rem=mod(NoSegT,Ns);
Round=ceil(NoSegT/Ns);
gap=norm(Center(1,:)-Center(2,:))/3;
Rst=Lmax/2/sin(pi/Nr);
[Center1,Rcenter]=deal(zeros(3*Ns,3));
for iC=1:3*Ns
    Center1(iC,:)=Center(1,:)'-(iC-2)*gap*[cos(theta);sin(theta);0];
    Rcenter(iC,:)=Center1(iC,:)'+dir*Rst*[sin(theta);-cos(theta);0];
end
StateT={Node,Center1,theta,Time,Rcenter};
for iR=1:Round
    if iR==Round&&Rem~=0; SegT=Rem; else SegT=Ns; end
    for order=1:2
        for iS=1:SegT
            StateT=TurnSeg(Parameter,StateT,order,iS,dir,Handles);
        end
        if order==1; StateT{3}=StateT{3}-dir*SegT*Unit*2; end
    end
end
for k=1:Ns
    Center(k,:)=StateT{2}(3*k-1,:);
end
StateT{2}=Center;
State=StateT(1:4);

function StateT=TurnSeg(Parameter,StateT,order,seq,dir,Handles)
[Node,Center1,theta,Time,Rcenter]=StateT{:};
[Ns,Nr,Unit,StepTime,step,Lmax,Lmin]=Parameter{[1:2,4:8]};
itera=round((Lmax-Lmin)/2/step);
stepT=-dir*Unit/itera;
Rotate=[cos(stepT) -sin(stepT) 0; sin(stepT) cos(stepT) 0; 0 0 1];
[Rc20,Rc30]=deal(Rcenter(3*seq-1,:)',Rcenter(3*seq,:)');
[Rc2,Rc3]=deal(repmat(Rc20,1,Nr),repmat(Rc30,1,Nr));
for iT=1:itera
    if ~isempty(Handles{5}{1})
        for iSk=1:Ns
            addpoints(Handles{5}{iSk},Node(iSk,2,1,1),Node(iSk,2,1,2));
        end
    end
    for iB=1:Ns
        for jB=1:2
            kNr=3*jB-1/2+(-1)^iB/2;
            Lside=norm(squeeze(Node(iB,1,kNr,1:2)-Node(iB,3,kNr,1:2)));
            addpoints(Handles{6}{iB,jB},Time,Lside+200*(iB-1));
        end
    end
    addpoints(Handles{7},Time,norm(Center1(2,1:2)-[0 0]));
    if order==1
        for iT1=1:seq
            for jT1=1:3
                if iT1==seq&&jT1==3; break;end
                sub1=3*(iT1-1)+jT1;
                Node(iT1,jT1,:,:)=(Rotate*(squeeze...
                    (Node(iT1,jT1,:,:))'-Rc3)+Rc3)';
                Center1(sub1,:)=Rotate*(Center1(sub1,:)'-Rc30)+Rc30;
                Rcenter(sub1,:)=Rotate*(Rcenter(sub1,:)'-Rc30)+Rc30;
            end
        end
        for iT2=1:seq
            for jT2=1:3
                if iT2==seq&&jT2==2; break;end
                sub2=3*(iT2-1)+jT2;
                Node(iT2,jT2,:,:)=(Rotate*(squeeze...
                    (Node(iT2,jT2,:,:))'-Rc2)+Rc2)';
                Center1(sub2,:)=Rotate*(Center1(sub2,:)'-Rc20)+Rc20;
                Rcenter(sub2,:)=Rotate*(Rcenter(sub2,:)'-Rc20)+Rc20;
            end
        end
        Lst1=Lmax-iT*step/2;
        Lst2=Lmax-iT*step;
        for iN=1:3
            Node(seq,iN,:,:)=TurnCircle(Nr,Lst1,Lst2,(-1)^(seq+iN-1),...
                dir,Center1(3*(seq-1)+iN,:),theta+iT*(3-iN)*stepT);
        end
    elseif order==2
        for iT1=seq:Ns
            for jT1=1:3
                if iT1==seq&&jT1==1; continue; end
                sub1=3*(iT1-1)+jT1;
                Node(iT1,jT1,:,:)=(Rotate*(squeeze...
                    (Node(iT1,jT1,:,:))'-Rc2)+Rc2)';
                Center1(sub1,:)=Rotate*(Center1(sub1,:)'-Rc20)+Rc20;
                Rcenter(sub1,:)=Rotate*(Rcenter(sub1,:)'-Rc20)+Rc20;
            end
        end
        for iT2=seq:Ns
            for jT2=1:3
                if iT2==seq&&jT2~=3; continue; end
                sub2=3*(iT2-1)+jT2;
                Node(iT2,jT2,:,:)=(Rotate*(squeeze...
                    (Node(iT2,jT2,:,:))'-Rc3)+Rc3)';
                Center1(sub2,:)=Rotate*(Center1(sub2,:)'-Rc30)+Rc30;
                Rcenter(sub2,:)=Rotate*(Rcenter(sub2,:)'-Rc30)+Rc30;
            end
        end
        Lst1=Lmax-itera*step/2+iT*step/2;
        Lst2=Lmax-itera*step+iT*step;
        for iN=1:3
            Node(seq,iN,:,:)=TurnCircle(Nr,Lst1,Lst2,(-1)^(seq+iN-1),...
                dir,Center1(3*(seq-1)+iN,:),theta-(itera-iT)*(iN-1)*stepT);
        end
    end
    Update(Ns,Nr,Node,Handles{1:4});
    Time=Time+StepTime;
    drawnow;
end
StateT={Node,Center1,theta,Time,Rcenter};

function Node0=TurnCircle(Nr,Lst1,Lst2,position,dir,Center0,theta)
Node0=zeros(Nr,3);
alpha0=pi/2/Nr;
Lst=linspace(Lst2,Lst1,Nr/2);
Rst=Lst/2/sin(pi/Nr);
Rst=[fliplr(Rst),Rst];
for i=1:Nr
    alpha=2*pi*(i-1)/Nr-alpha0*position;
    j=mod(i-floor(Nr/4)+1+(dir+1)*Nr/4,Nr)+1;
    Node0(i,:)=[cos(theta) -sin(theta) 0;sin(theta) cos(theta) 0;0 0 1]...
        *[0; -Rst(j)*sin(alpha); -Rst(j)*cos(alpha)]+Center0';
end

function Node=Nodes(Ns,Nr,Lst,Center,theta)
Node=zeros(Ns,3,Nr,3);
for i=1:Ns
    r1=sign(3-2*i);
    r2=sign(2*Ns-1-2*i);
    Node(i,2,:,:)=Circle(Nr,Lst(i),(-1)^(i-1),Center(i,:),theta);
    Lst1=Lst(i)-(Lst(i)-Lst(i+r1))/3;
    Center1=Center(i,:)+r1*(Center(i,:)-Center(i+r1,:))/3;
    Node(i,1,:,:)=Circle(Nr,Lst1,(-1)^i,Center1,theta);
    Lst3=Lst(i)-(Lst(i)-Lst(i+r2))/3;
    Center3=Center(i,:)-r2*(Center(i,:)-Center(i+r2,:))/3;
    Node(i,3,:,:)=Circle(Nr,Lst3,(-1)^i,Center3,theta);
end

function Node0=Circle(Nr,Lst0,position,Center0,theta)
Node0=zeros(Nr,3);
alpha0=pi/2/Nr;
Rst=Lst0/2/sin(pi/Nr);
for i=1:Nr
    alpha=2*pi*(i-1)/Nr-alpha0*position;
    Node0(i,:)=[cos(theta) -sin(theta) 0;sin(theta) cos(theta) 0;0 0 1]...
        *[0; -Rst*sin(alpha); -Rst*cos(alpha)]+Center0';
end

function []=Update(Ns,Nr,Node,hNode,hString,hPipe1,hPipe2)
for iN=1:Ns
    for jN=1:3
        for kN=1:Nr
            set(hNode{iN,jN,kN},'XData',Node(iN,jN,kN,1),'YData',...
                Node(iN,jN,kN,2),'ZData',Node(iN,jN,kN,3));
        end
    end
end
for iP=1:Ns
    for jP=1:3
        if iP==Ns&&jP==3; break;end
        for kP=1:Nr
            if jP==2; set(hString{iP,kP},...
                 'XData',[Node(iP,jP,kP,1),Node(iP,jP,mod(kP,Nr)+1,1)],...
                 'YData',[Node(iP,jP,kP,2),Node(iP,jP,mod(kP,Nr)+1,2)],...
                 'ZData',[Node(iP,jP,kP,3),Node(iP,jP,mod(kP,Nr)+1,3)]);
            end
            iP1=iP+floor(jP/3);
            jP1=mod(jP,3)+1;
            kP1=kP+(-1)^(iP+jP);
            kP2=kP1+Nr*(fix((Nr-kP1)/Nr)-fix(kP1/(Nr+1)));
            set(hPipe1{iP,jP,kP},...
                'XData',[Node(iP,jP,kP,1),Node(iP1,jP1,kP,1)],...
                'YData',[Node(iP,jP,kP,2),Node(iP1,jP1,kP,2)],...
                'ZData',[Node(iP,jP,kP,3),Node(iP1,jP1,kP,3)]);
            set(hPipe2{iP,jP,kP},...
                'XData',[Node(iP,jP,kP,1),Node(iP1,jP1,kP2,1)],...
                'YData',[Node(iP,jP,kP,2),Node(iP1,jP1,kP2,2)],...
                'ZData',[Node(iP,jP,kP,3),Node(iP1,jP1,kP2,3)]);
        end
    end
end
