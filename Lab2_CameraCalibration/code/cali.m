%Visual Perception
%Lab 2: Camera Calibration
%Author: Raabid Hussain

close all;
clear;
clc;

%Defining the intrinsic and extrinsic parameters
au=557.0943;
av=712.9824;
u0=326.3819;
v0=298.6679;
f=80;
Tx=100;
Ty=0;
Tz=1500;
Phix=0.8*pi/2;
Phiy=-1.8*pi/2;
Phix1=pi/5;
noise=0.5;

%loop for different number of 3D data points
for num=6:6:100
    %defining x-axis values for the accuracy graph
    acis(num/6)=num;
    %Defining the transformation matrices
    I=[au 0 u0 0;0 av v0 0;0 0 1 0];
    R=[1 0 0;0 cos(Phix) -sin(Phix);0 sin(Phix) cos(Phix)]*[cos(Phiy) 0 sin(Phiy); 0 1 0;-sin(Phiy) 0 cos(Phiy)]*[1 0 0;0 cos(Phix1) -sin(Phix1);0 sin(Phix1) cos(Phix1)];
    E=[R [Tx;Ty;Tz]];
    E=[E;0 0 0 1];

    %random 6 points
    rpts=[randi([-480, 480],num,1), randi([-480, 480],num,1), randi([-480, 480],num,1), ones(num,1)]';
    campts=I*E*rpts;
    for i=1:num
        campts(1,i)=campts(1,i)/campts(3,i);
        campts(2,i)=campts(2,i)/campts(3,i);
        campts(3,i)=campts(3,i)/campts(3,i);
        %copying the non-noisy data points in different variable for
        %further calculations
        campts1=campts;
        campts2=campts;
    end
    
    %plotting points on image plane
    figure;
    scatter(campts(1,:),campts(2,:));
    title('Projection of the random points on the image plane');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%       HALL METHOD       %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Hall method
    for i=1:num
        Qm1=[rpts(1,i) rpts(2,i) rpts(3,i) 1 0 0 0 0 -campts(1,i)*rpts(1,i) -campts(1,i)*rpts(2,i) -campts(1,i)*rpts(3,i)];
        Q(2*i-1,:)=Qm1;
        Q1=[0 0 0 0 rpts(1,i) rpts(2,i) rpts(3,i) 1 -campts(2,i)*rpts(1,i) -campts(2,i)*rpts(2,i) -campts(2,i)*rpts(3,i)];
        Q(2*i,:)=Q1;
        Bm1=campts(1,i);
        B(2*i-1,:)=Bm1;
        B1=campts(2,i);
        B(2*i,:)=B1;
    end

    %comparing with real matrix
    A=Q\B;
    A=[A;1]';
    A=reshape(A,4,3)';
    Ar=I*E;
    Ar=Ar/Ar(3,4);

    %adding noise to image coordinates
    campts=campts(1:2,:);
    campts=campts+noise*randn(2,num);
    campts=[campts;ones(1,num)];
    ncampts=campts;

    %Hall method on noisy points
    for i=1:num
        Qm1=[rpts(1,i) rpts(2,i) rpts(3,i) 1 0 0 0 0 -campts(1,i)*rpts(1,i) -campts(1,i)*rpts(2,i) -campts(1,i)*rpts(3,i)];
        Q(2*i-1,:)=Qm1;
        Q1=[0 0 0 0 rpts(1,i) rpts(2,i) rpts(3,i) 1 -campts(2,i)*rpts(1,i) -campts(2,i)*rpts(2,i) -campts(2,i)*rpts(3,i)];
        Q(2*i,:)=Q1;
        Bm1=campts(1,i);
        B(2*i-1,:)=Bm1;
        B1=campts(2,i);
        B(2*i,:)=B1;
    end

    %comparing with real matrix
    A=Q\B;
    A=[A;1]';
    A=reshape(A,4,3)';
    Ar=I*E;
    Ar=Ar/Ar(3,4);

    %plotting noisy points on image plane
    noipts=A*rpts;
    for i=1:num
        noipts(1,i)=noipts(1,i)/noipts(3,i);
        noipts(2,i)=noipts(2,i)/noipts(3,i);
        noipts(3,i)=noipts(3,i)/noipts(3,i);
    end
    hold on;
    scatter(noipts(1,:),noipts(2,:),'r+');

    %determining discrepancy among the result obtained
    accuracy=0;
    for i=1:num
        accuracy=accuracy + sqrt(((noipts(1,i)-campts1(1,i)).^2)+((noipts(2,i)-campts1(2,i)).^2));
    end
    accuracyplot(num/6)=accuracy/num;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%      FAUGERAS METHOD      %%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Faugeras method
    for i=1:num
        Qm1=[rpts(1,i) rpts(2,i) rpts(3,i) -campts1(1,i)*rpts(1,i) -campts1(1,i)*rpts(2,i) -campts1(1,i)*rpts(3,i) 0 0 0 1 0];
        Q(2*i-1,:)=Qm1;
        Q1=[0 0 0 -campts1(2,i)*rpts(1,i) -campts1(2,i)*rpts(2,i) -campts1(2,i)*rpts(3,i) rpts(1,i) rpts(2,i) rpts(3,i) 0 1];
        Q(2*i,:)=Q1;
        Bm1=campts1(1,i);
        B(2*i-1,:)=Bm1;
        B1=campts1(2,i);
        B(2*i,:)=B1;
    end

    %comparing with real matrix
    A=Q\B;
    T1=A(1:3);
    T2=A(4:6);
    T3=A(7:9);
    C1=A(10);
    C2=A(11);
    %obtained camera parameters
    u01=(T1'*T2)/((norm(T2)).^2);
    v01=(T2'*T3)/((norm(T2)).^2);
    au1=norm(cross(T1,T2)/((norm(T2)).^2));
    av1=norm(cross(T2,T3)/((norm(T2)).^2));
    r1=(norm(T2)/norm(cross(T1,T2)))*(T1-(((T1'*T2)*T2)/((norm(T2)).^2)));
    r2=(norm(T2)/norm(cross(T2,T3)))*(T3-(((T2'*T3)*T2)/((norm(T2)).^2)));
    r3=T2/norm(T2);
    Tx1=(norm(T2)/norm(cross(T1,T2)))*(C1-(((T1'*T2))/((norm(T2)).^2)));
    Ty1=(norm(T2)/norm(cross(T2,T3)))*(C2-(((T2'*T3))/((norm(T2)).^2)));
    Tz1=1/norm(T2);
    %new transformation matrix
    E1=[r1';r2';r3';0 0 0];
    Tr1=[Tx1;Ty1;Tz1;1];
    E1=[E1 Tr1];
    I1=[au1 0 u01 0;0 av1 v01 0;0 0 1 0];
    
    %adding noise to image coordinates (same ones a s used before)
    campts1=ncampts;

    %Faugeras method on noisy points
    for i=1:num
        Qm1=[rpts(1,i) rpts(2,i) rpts(3,i) -campts1(1,i)*rpts(1,i) -campts1(1,i)*rpts(2,i) -campts1(1,i)*rpts(3,i) 0 0 0 1 0];
        Q(2*i-1,:)=Qm1;
        Q1=[0 0 0 -campts1(2,i)*rpts(1,i) -campts1(2,i)*rpts(2,i) -campts1(2,i)*rpts(3,i) rpts(1,i) rpts(2,i) rpts(3,i) 0 1];
        Q(2*i,:)=Q1;
        Bm1=campts1(1,i);
        B(2*i-1,:)=Bm1;
        B1=campts1(2,i);
        B(2*i,:)=B1;
    end

    %comparing with real matrix
    A=Q\B;
    T1=A(1:3);
    T2=A(4:6);
    T3=A(7:9);
    C1=A(10);
    C2=A(11);
    %obtained camera parameters
    u01=(T1'*T2)/((norm(T2)).^2);
    v01=(T2'*T3)/((norm(T2)).^2);
    au1=norm(cross(T1,T2)/((norm(T2)).^2));
    av1=norm(cross(T2,T3)/((norm(T2)).^2));
    r1=(norm(T2)/norm(cross(T1,T2)))*(T1-(((T1'*T2)*T2)/((norm(T2)).^2)));
    r2=(norm(T2)/norm(cross(T2,T3)))*(T3-(((T2'*T3)*T2)/((norm(T2)).^2)));
    r3=T2/norm(T2);
    Tx1=(norm(T2)/norm(cross(T1,T2)))*(C1-(((T1'*T2))/((norm(T2)).^2)));
    Ty1=(norm(T2)/norm(cross(T2,T3)))*(C2-(((T2'*T3))/((norm(T2)).^2)));
    Tz1=1/norm(T2);
    %new transformation matrix
    E1=[r1';r2';r3';0 0 0];
    Tr1=[Tx1;Ty1;Tz1;1];
    E1=[E1 Tr1];
    I1=[au1 0 u01 0;0 av1 v01 0;0 0 1 0];
    A=I1*E1;
    A=A/A(3,4);
    
    %plotting noisy points on image plane
    noipts=A*rpts;
    for i=1:num
        noipts(1,i)=noipts(1,i)/noipts(3,i);
        noipts(2,i)=noipts(2,i)/noipts(3,i);
        noipts(3,i)=noipts(3,i)/noipts(3,i);
    end
    hold on;
    scatter(noipts(1,:),noipts(2,:),'y');

    %determining discrepancy among the result obtained
    accuracy=0;
    for i=1:num
        accuracy=accuracy + sqrt(((noipts(1,i)-campts2(1,i)).^2)+((noipts(2,i)-campts2(2,i)).^2));
    end
    accuracyplot1(num/6)=accuracy/num;
    
    legend('ideal points', 'hall method with noise', 'faugeras method with noise');
end

%accuracy graph for both method and different number of data points used
figure;
plot(acis,accuracyplot);
hold on;
plot(acis,accuracyplot1,'r');
title('Accuracy of the calibration methods');
xlabel('Number of data points');
ylabel('Mean error of methods');
legend('Halls method','Faugeras Method');

