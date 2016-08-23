%Visual Perception
%Lab Report 3: Epipolar lines
%Author:Raabid Hussain

close all;
clc;
clear;

%number of points and sigma of noise
num=20;
noise=0.5;

%step 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%defining camera 1 parameters
au1 = 100;
av1 = 120;
uo1 = 128;
vo1 = 128;
R1=eye(3);
T1=[0;0;0];

%step 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%defining camera 2 parameters
au2 = 90;
av2 = 110;
uo2 = 128;
vo2 = 128;
ax = 0.1;
by = pi/4;
cz = 0.2;
tx = -1000;
ty = 190;
tz = 230;

%step 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%defining intrinsic matrix of camera 1
A1=[au1 0 uo1;0 av1 vo1;0 0 1];

%defining intrinsic matrix of camera 2
A2=[au2 0 uo2;0 av2 vo2;0 0 1 ];

%defining transformation between two cameras
R=[1 0 0;0 cos(ax) -sin(ax);0 sin(ax) cos(ax)]*[cos(by) 0 sin(by); 0 1 0;-sin(by) 0 cos(by)]*[cos(cz) -sin(cz) 0;sin(cz) cos(cz) 0; 0 0 1];
T=[tx;ty;tz];

%step 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%antisymmetric matrix of translation
t=[0 -tz ty;tz 0 -tx;-ty tx 0];

%fundamental matrix
F=inv(A2')*R'*t*inv(A1);
F=F/F(3,3);


%step 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%defining data points
V(:,1) = [100;-400;2000;1];
V(:,2) = [300;-400;3000;1];
V(:,3) = [500;-400;4000;1];
V(:,4) = [700;-400;2000;1];
V(:,5) = [900;-400;3000;1];
V(:,6) = [100;-50;4000;1];
V(:,7) = [300;-50;2000;1];
V(:,8) = [500;-50;3000;1];
V(:,9) = [700;-50;4000;1];
V(:,10) = [900;-50;2000;1];
V(:,11) = [100;50;3000;1];
V(:,12) = [300;50;4000;1];
V(:,13) = [500;50;2000;1];
V(:,14) = [700;50;3000;1];
V(:,15) = [900;50;4000;1];
V(:,16) = [100;400;2000;1];
V(:,17) = [300;400;3000;1];
V(:,18) = [500;400;4000;1];
V(:,19) = [700;400;2000;1];
V(:,20) = [900;400;3000;1];

%for changing the points comment above 20 lines and uncomment the next
%three lines
% for i=1:num
%     V(:,i)=[round(rand*1000);round(rand*800)-400;round(randn*2000)+2000;1];
% end


%step 6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Intrinsic and Extrinsic matrices
I1=[au1 0 uo1 0;0 av1 vo1 0;0 0 1 0];
I2=[au2 0 uo2 0;0 av2 vo2 0;0 0 1 0];
E2=[R' -R'*T];
E2=[E2;0 0 0 1];
E1=[R1 T1];
E1=[E1;0 0 0 1];
%Transformation from 3d to 2d camera planes
c1=I1*E1*V;
c2=I2*E2*V;
%normalizing the 2d points
for i=1:num
    c1(1,i)=c1(1,i)/c1(3,i);
    c1(2,i)=c1(2,i)/c1(3,i);
    c1(3,i)=c1(3,i)/c1(3,i);
    c2(1,i)=c2(1,i)/c2(3,i);
    c2(2,i)=c2(2,i)/c2(3,i);
    c2(3,i)=c2(3,i)/c2(3,i);
end


%step 7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plotting 2D camera planes
figure(1);
scatter(c1(1,:),c1(2,:));
title('camera 1 without noise');

figure(2);
scatter(c2(1,:),c2(2,:));
title('camera 2 without noise');



%step 8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%8 point linear least square methods
for i=1:num
    U(i,:)=[c1(1,i)*c2(1,i) c1(2,i)*c2(1,i) c2(1,i) c1(1,i)*c2(2,i) c1(2,i)*c2(2,i) c2(2,i) c1(1,i) c1(2,i)];
end

A=-(U'*U);
b=U'*ones(num,1);
f=A\b;
f=[f; 1];
f8LMS=reshape(f,3,3)';

%step 9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%comparing fundamental matrices
F
f8LMS

%step 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C1=f8LMS*c1;
C2=f8LMS'*c2;

%epipolar lines
for i=1:num
    m2(i)=-C1(1,i)/C1(2,i);
    d2(i)=-C1(3,i)/C1(2,i);
    m1(i)=-C2(1,i)/C2(2,i);
    d1(i)=-C2(3,i)/C2(2,i);
end

%plotting epipolar lines on camera 1
figure(1);
for i=1:num
    y11(i)=m1(i)*-500 + d1(i);
    y12(i)=m1(i)*500 + d1(i);
    line([-500 500],[y11(i) y12(i)]);
    hold on;
end

%plotting epipolar lines on camera 2
figure(2);
for i=1:num
    y21(i)=m2(i)*-500 + d2(i);
    y22(i)=m2(i)*500 + d2(i);
    line([-500 500],[y21(i) y22(i)]);
    hold on;
end

%epipolar points
[ep1x ep1y]=polyxpoly([-500 500],[y11(1) y12(1)],[-500 500],[y11(num) y12(num)])
[ep2x ep2y]=polyxpoly([-500 500],[y21(1) y22(1)],[-500 500],[y21(num) y22(num)])


%step 11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%adding noise to 2d points
n1=c1(1:2,:);
n1=n1+noise*randn(2,num)
n1=[n1;ones(1,num)]
n2=c2(1:2,:);
n2=n2+noise*randn(2,num);
n2=[n2;ones(1,num)];


%plotting 2D noisy points on new camera planes
figure(3);
scatter(n1(1,:),n1(2,:));
title('camera 1 noisy LMS');

figure(4);
scatter(n2(1,:),n2(2,:));
title('camera 2 noisy LMS');


%step 12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%8 point linear least square methods with noisy points
for i=1:num
    U(i,:)=[n1(1,i)*n2(1,i) n1(2,i)*n2(1,i) n2(1,i) n1(1,i)*n2(2,i) n1(2,i)*n2(2,i) n2(2,i) n1(1,i) n1(2,i)];
end

A=-(U'*U);
b=U'*ones(num,1);
f=A\b;
f=[f; 1];
f8LMS=reshape(f,3,3)';

%comparing fundamental matrices
F
f8LMS

C1=f8LMS*n1;
C2=f8LMS'*n2;

%epipolar lines without SVD
for i=1:num
    m2(i)=-C1(1,i)/C1(2,i);
    d2(i)=-C1(3,i)/C1(2,i);
    m1(i)=-C2(1,i)/C2(2,i);
    d1(i)=-C2(3,i)/C2(2,i);
end

%plotting epipolar lines on camera 1 without SVD
figure(3);
for i=1:num
    y11(i)=m1(i)*-500 + d1(i);
    y12(i)=m1(i)*500 + d1(i);
    line([-500 500],[y11(i) y12(i)]);
    hold on;
end

%plotting epipolar lines on camera 2 without SVD
figure(4);
for i=1:num
    y21(i)=m2(i)*-500 + d2(i);
    y22(i)=m2(i)*500 + d2(i);
    line([-500 500],[y21(i) y22(i)]);
    hold on;
end

%measuring distance errors
dS1=zeros(num,1);
dS2=zeros(num,1);
for i=1:num
    Q2=[500;y12(i)];
    Q1=[-500;y11(i)];
    P=[n1(1,i);n1(2,i)];
    dS1(i) = abs(det([Q2-Q1,P-Q1]))/norm(Q2-Q1); % for col. vectors
end
for i=1:num
    Q2=[500;y22(i)];
    Q1=[-500;y21(i)];
    P=[n2(1,i);n2(2,i)];
    dS2(i) = abs(det([Q2-Q1,P-Q1]))/norm(Q2-Q1); % for col. vectors
end

%using SVD to force rank of F to 2
[Us,S,V] = svd(f8LMS);
[~,i]=min(diag(S));
S(i,i)=0;
f8LMS=Us*S*V'

%replotting epipolar geometry
C1=f8LMS*n1;
C2=f8LMS'*n2;

%epipolar lines
for i=1:num
    m2(i)=-C1(1,i)/C1(2,i);
    d2(i)=-C1(3,i)/C1(2,i);
    m1(i)=-C2(1,i)/C2(2,i);
    d1(i)=-C2(3,i)/C2(2,i);
end

%plotting epipolar lines on camera 1
figure(3);
for i=1:num
    y11(i)=m1(i)*-500 + d1(i);
    y12(i)=m1(i)*500 + d1(i);
    plot([-500 500],[y11(i) y12(i)],'r');
    hold on;
end

%approximating the epipolar point
[ep1x ep1y]=polyxpoly([-500 500],[y11(1) y12(1)],[-500 500],[y11(num) y12(num)])
scatter(ep1x,ep1y)

%plotting epipolar lines on camera 2
figure(4);
for i=1:num
    y21(i)=m2(i)*-500 + d2(i);
    y22(i)=m2(i)*500 + d2(i);
    plot([-500 500],[y21(i) y22(i)],'r');
    hold on;
end

%approximating the epipolar point
[ep2x ep2y]=polyxpoly([-500 500],[y21(1) y22(1)],[-500 500],[y21(num) y22(num)])
scatter(ep2x,ep2y)



%step 13
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%change noise variable from 0.5 to 1 in the beginning of code and rerun


%step 14
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%using eigen analysis to coumpute fundamental matrix
for i=1:num
    U2(i,:)=[c1(1,i)*c2(1,i) c1(2,i)*c2(1,i) c2(1,i) c1(1,i)*c2(2,i) c1(2,i)*c2(2,i) c2(2,i) c1(1,i) c1(2,i) 1];
end
%eigen decompositon
[U,D,V]=svd(U2);
f9Eig=reshape(V(:,9),3,3)';
f9Eig=f9Eig/f9Eig(3,3);
%comparing the results
F
f9Eig


%step 15
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plotting 2D noisy points on new camera planes
figure(5);
scatter(n1(1,:),n1(2,:));
title('camera 1 noisy Eigen');

figure(6);
scatter(n2(1,:),n2(2,:));
title('camera 2 noisy Eigen');


%Egien Analysis methods with noisy points
for i=1:num
    U2(i,:)=[n1(1,i)*n2(1,i) n1(2,i)*n2(1,i) n2(1,i) n1(1,i)*n2(2,i) n1(2,i)*n2(2,i) n2(2,i) n1(1,i) n1(2,i) 1];
end
%eigen decompositon
[U,D,V]=svd(U2);
f9Eig=reshape(V(:,9),3,3)';
f9Eig=f9Eig/f9Eig(3,3);
%comparing the results
F
f9Eig

%3D points from 2d poiints
C1=f9Eig*n1;
C2=f9Eig'*n2;

%epipolar lines without SVD
for i=1:num
    m2(i)=-C1(1,i)/C1(2,i);
    d2(i)=-C1(3,i)/C1(2,i);
    m1(i)=-C2(1,i)/C2(2,i);
    d1(i)=-C2(3,i)/C2(2,i);
end

%plotting epipolar lines on camera 1 without SVD
figure(5);
for i=1:num
    y11(i)=m1(i)*-500 + d1(i);
    y12(i)=m1(i)*500 + d1(i);
    line([-500 500],[y11(i) y12(i)]);
    hold on;
end

%plotting epipolar lines on camera 2 without SVD
figure(6);
for i=1:num
    y21(i)=m2(i)*-500 + d2(i);
    y22(i)=m2(i)*500 + d2(i);
    line([-500 500],[y21(i) y22(i)]);
    hold on;
end

%mean distance
dE1=zeros(num,1);
dE2=zeros(num,1);

for i=1:num
    Q2=[500;y12(i)];
    Q1=[-500;y11(i)];
    P=[n1(1,i);n1(2,i)];
    dE1(i) = abs(det([Q2-Q1,P-Q1]))/norm(Q2-Q1); % for col. vectors
end
for i=1:num
    Q2=[500;y22(i)];
    Q1=[-500;y21(i)];
    P=[n2(1,i);n2(2,i)];
    dE2(i) = abs(det([Q2-Q1,P-Q1]))/norm(Q2-Q1); % for col. vectors
end


%using SVD to force rank of F to 2
[Us,S,V] = svd(f9Eig);
[~,i]=min(diag(S));
S(i,i)=0;
f9Eig=Us*S*V'

%replotting epipolar geometry
C1=f9Eig*n1;
C2=f9Eig'*n2;

%epipolar lines
for i=1:num
    m2(i)=-C1(1,i)/C1(2,i);
    d2(i)=-C1(3,i)/C1(2,i);
    m1(i)=-C2(1,i)/C2(2,i);
    d1(i)=-C2(3,i)/C2(2,i);
end

%plotting epipolar lines and point on camera 1
figure(5);
for i=1:num
    y11(i)=m1(i)*-500 + d1(i);
    y12(i)=m1(i)*500 + d1(i);
    plot([-500 500],[y11(i) y12(i)],'r');
    hold on;
end
%approximating epipolar point
[ep1x ep1y]=polyxpoly([-500 500],[y11(1) y12(1)],[-500 500],[y11(num) y12(num)])
scatter(ep1x,ep1y)

%plotting epipolar lines and point on camera 2
figure(6);
for i=1:num
    y21(i)=m2(i)*-500 + d2(i);
    y22(i)=m2(i)*500 + d2(i);
    plot([-500 500],[y21(i) y22(i)],'r');
    hold on;
end
%approximating epipolar point
[ep2x ep2y]=polyxpoly([-500 500],[y21(1) y22(1)],[-500 500],[y21(num) y22(num)])
scatter(ep2x,ep2y)

%change noise variable at the beginning of code to increase the noise
%accordingly

%step 16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%mean errors
dE=(mean(dE1)+mean(dE2))/2
dS=(mean(dS1)+mean(dS2))/2


%standard deviation
sE1=0;
sS1=0;
sE2=0;
sS2=0;

for i=1:num
    sE1=sE1+ (dE1(i)-mean(dE1)).^2;
    sE2=sE2+ (dE2(i)-mean(dE2)).^2;
    sS1=sS1+ (dS1(i)-mean(dS1)).^2;
    sS2=sS2+ (dS2(i)-mean(dS2)).^2;
end

sE=sqrt((sE1+sE2)/(2*num))
sS=sqrt((sS1+sS2)/(2*num))


