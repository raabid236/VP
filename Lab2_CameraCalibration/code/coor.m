%Visual Perception Lab 2
%Author: Raabid Hussain
%Image planes

clc;
close all;
clear;

%Define parameters
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
num=10;

%Transformation Matrix
I=[au 0 u0 0;0 av v0 0;0 0 1 0];
R=[1 0 0;0 cos(Phix) -sin(Phix);0 sin(Phix) cos(Phix)]*[cos(Phiy) 0 sin(Phiy); 0 1 0;-sin(Phiy) 0 cos(Phiy)]*[1 0 0;0 cos(Phix1) -sin(Phix1);0 sin(Phix1) cos(Phix1)];
E=[R [Tx;Ty;Tz]];
E=[E;0 0 0 1];

%World coordinate system
figure;
z0=[0 0 0 0 0 0 0 0 0 0 0];
xw=0:20:200;
xw=[xw;z0;z0];
yw=0:20:200;
yw=[z0;yw;z0];
zw=0:20:200;
zw=[z0;z0;zw];

plot3(xw(1,:),xw(2,:),xw(3,:),'r')
hold on;
plot3(yw(1,:),yw(2,:),yw(3,:),'y')
hold on;
plot3(zw(1,:),zw(2,:),zw(3,:),'b')
hold on;

%Camera coordinate system
xc=E*[xw;z0+1];
yc=E*[yw;z0+1];
zc=E*[zw;z0+1];

plot3(xc(1,:),xc(2,:),xc(3,:),'g')
hold on;
plot3(yc(1,:),yc(2,:),yc(3,:),'c')
hold on;
plot3(zc(1,:),zc(2,:),zc(3,:),'m')
hold on;


%focal point
focal=[xw(1,1);yw(1,1);zw(1,1)+f];
focal=E*[focal;1];

plot3(focal(1), focal(2), focal(3),'o');
hold on;

%image plane
plane=[0; 0; 80];
plane=[plane [0; 480 ;80]];
plane=[plane [640; 480 ;80]];
plane=[plane [640; 0 ;80]];
plane=[plane [0; 0 ;80]];

plane=E*[plane;1 1 1 1 1];
plot3(plane(1,:), plane(2,:), plane(3,:),'k');
hold on;

%3D points
rpts=[randi([-480, 480],num,1), randi([-480, 480],num,1), randi([-480, 480],num,1), ones(num,1)]';
scatter3(rpts(1,:), rpts(2,:), rpts(3,:),'r+');
hold on;

%2D points
A=I*E;
campts=A*rpts;
for i=1:num
    campts(1,i)=2*u0-(campts(1,i)/campts(3,i));
    campts(2,i)=2*v0-(campts(2,i)/campts(3,i));
    campts(3,i)=f*(campts(3,i)/campts(3,i));
end
campts=E*[campts;ones(1,num)];
scatter3(campts(1,:),campts(2,:),campts(3,:),'b+');
hold on;

%third point on line (extending the projection lines)
mir=rpts;
for i=1:num
    mir(1,i)=campts(1,i)-(rpts(1,i)-campts(1,i));
    mir(2,i)=campts(2,i)-(rpts(2,i)-campts(2,i));
    mir(3,i)=campts(3,i)-(rpts(3,i)-campts(3,i));
end

%optical rays
for i=1:num
    line1=[rpts(1,i) campts(1,i) mir(1,i);rpts(2,i) campts(2,i) mir(2,i);rpts(3,i) campts(3,i) mir(3,i)];
    plot3(line1(1,:),line1(2,:),line1(3,:))
    hold on;
end


%labelling all lines
legend('xw','yw','zw','xc','yc','zc','f', 'plane','3D points','2D points');

%axis([-500 1000 -500 1000 -500 2000]);

