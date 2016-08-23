%Visual Perception
%Lab Report 3: Epipolar lines
%Author:Raabid Hussain
%optional part

close all;
clc;
clear;

%defining transformation parameters
au1 = 100;
av1 = 120;
uo1 = 128;
vo1 = 128;
R1=eye(3);
T1=[0;0;0];
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
f=80;

%defining transformation between two cameras
A1=[au1 0 uo1;0 av1 vo1;0 0 1];
A2=[au2 0 uo2;0 av2 vo2;0 0 1 ];
R=[1 0 0;0 cos(ax) -sin(ax);0 sin(ax) cos(ax)]*[cos(by) 0 sin(by); 0 1 0;-sin(by) 0 cos(by)]*[cos(cz) -sin(cz) 0;sin(cz) cos(cz) 0; 0 0 1];
T=[tx;ty;tz];
E=[R T];
E=[E;0 0 0 1];
t=[0 -tz ty;tz 0 -tx;-ty tx 0];
F=inv(A2')*R'*t*inv(A1);
F=F/F(3,3);

%defining 3D data points
V(:,1) = [100;400;2000;1];
V(:,2) = [500;-400;4000;1];


%intrinsics
I1=[au1 0 uo1 0;0 av1 vo1 0;0 0 1 0];
I2=[au2 0 uo2 0;0 av2 vo2 0;0 0 1 0];
E2=[R' -R'*T];
E2=[E2;0 0 0 1];
E1=[R1 T1];
E1=[E1;0 0 0 1];
%Transformation from 3d to 2d camera planes using intirinsic approach
cc1=I1*E1*V;
cc2=I2*E2*V;
%normalizing the 2d points
for i=1:2
    cc1(1,i)=cc1(1,i)/cc1(3,i);
    cc1(2,i)=cc1(2,i)/cc1(3,i);
    cc1(3,i)=cc1(3,i)/cc1(3,i);
    cc2(1,i)=cc2(1,i)/cc2(3,i);
    cc2(2,i)=cc2(2,i)/cc2(3,i);
    cc2(3,i)=cc2(3,i)/cc2(3,i);
end

%defining 2D points on image planes
c1(1,:)=f*V(1,:)./V(3,:);
c1(2,:)=f*V(2,:)./V(3,:);
c1(3,:)=f;
c1(4,:)=1;
c2=E*c1;

%drawing points
plot3(V(1,:),V(2,:),V(3,:),'bo');
hold on;
plot3(c1(1,:),c1(2,:),c1(3,:),'bo');
plot3(c2(1,:),c2(2,:),c2(3,:),'bo');


%World coordinate system
z0=[0 0 0 0 0 0 0 0 0 0 0];
xw=0:20:200;
xw=[xw;z0;z0];
yw=0:20:200;
yw=[z0;yw;z0];
zw=0:20:200;
zw=[z0;z0;zw];

plot3(xw(1,:),xw(2,:),xw(3,:),'m')
plot3(yw(1,:),yw(2,:),yw(3,:),'m')
plot3(zw(1,:),zw(2,:),zw(3,:),'m')


%Camera 2 coordinate system
xc=E*[xw;z0+1];
yc=E*[yw;z0+1];
zc=E*[zw;z0+1];

plot3(xc(1,:),xc(2,:),xc(3,:),'c')
plot3(yc(1,:),yc(2,:),yc(3,:),'c')
plot3(zc(1,:),zc(2,:),zc(3,:),'c')

%origins of camera coordinate system
c=[0;0;0;1];
c=[c c];
co=E*c;

%drawing triangulation
plot3([V(1,:);c(1,:)],[V(2,:);c(2,:)],[V(3,:);c(3,:)],'k')
plot3([V(1,:);co(1,:)],[V(2,:);co(2,:)],[V(3,:);co(3,:)],'k')
plot3([co(1,:);c(1,:)],[co(2,:);c(2,:)],[co(3,:);c(3,:)],'k')


%2D points to 3d points
C1=F*cc1(1:3,:);
C2=F'*cc2(1:3,:);

%epipolar lines
for i=1:2
    m2(i)=-C1(1,i)/C1(2,i);
    d2(i)=-C1(3,i)/C1(2,i);
    m1(i)=-C2(1,i)/C2(2,i);
    d1(i)=-C2(3,i)/C2(2,i);
end

%plotting epipolar lines on cameras
for i=1:2
    y11(i)=m1(i)*-500 + d1(i);
    y12(i)=m1(i)*500 + d1(i);
    poin1=[[(-500-128)/(au1/f); (y11(i)-128)/(av1/f); f; 1],[(500-128)/(au1/f); (y12(i)-128)/(av1/f); 80; 1]];
    poin2=E*poin1;
    line([poin2(1,:)],[poin2(2,:)],[poin2(3,:)]);
    line([poin1(1,:)],[poin1(2,:)],[poin1(3,:)]);
    hold on;
end


%epipolar points
[ep1x ep1y]=polyxpoly([(-500-128)/(au1/f) (500-128)/(au1/f)],[(y11(1)-128)/(av1/f) (y12(1)-128)/(av1/f)],[(-500-128)/(au1/f) (500-128)/(au1/f)],[(y11(2)-128)/(av1/f) (y12(2)-128)/(av1/f)])
ep1=[ep1x;ep1y;f;1]
ep2=E*ep1
scatter3(ep1x,ep1y,f,'go')
plot3(ep2(1),ep2(2),ep2(3),'go')

%image plane
plane=[-128; -128; f];
plane=[plane [-128; 128 ;f]];
plane=[plane [128; 128 ;f]];
plane=[plane [128; -128 ;f]];
plane=[plane [-128; -128 ;f]];
plot3(plane(1,:), plane(2,:), plane(3,:),'r');
plane=E*[plane;1 1 1 1 1];
plot3(plane(1,:), plane(2,:), plane(3,:),'r');
