%基波参数设置，采样频率
w=2*pi/0.02; %基波频率为50Hz
A=1; %信号幅值
f=3915; %Hz,采样频率；采样区间是0.2s,每秒采样5000次，0.2秒也就是100个采样点
TimeInterval=0:1/f:((f/5)/f);%采样10个基波周期所需要的采样点数
t=TimeInterval;

figure(1);
%1正常信号
z=A*sin(w*t);
subplot(4,1,1);
plot(z);
title('正常信号');
ylabel('幅值（pu）');

%2电压暂降
T21=(1+7*rand())*0.02;  %t2-t1,扰动开始和结束的时间差,1-8T之间
t1=rand()*0.02*8+0.02;  %扰动开始时间，开始信号至多出现在第9个周期 
t2=t1+T21; %扰动结束时间
Aerfa=(1+8*rand())*0.1; %暂降幅值为0.1-0.9之间
z=zeros(1,length(t));
for j=1:length(t)
    U1=0;U2=0;%U为阶跃函数，U1=u(t-t1)\U2=u(t-t2)
    if t(j)>t1
       U1=1;
    else
       U1=0;
    end
    if t(j)>t2
       U2=1;
    else
       U2=0;
    end
    z(j)=A*(1-Aerfa*(U1-U2))*sin(w*t(j)); 
end
subplot(4,1,2);
plot(z);
title('电压暂降');
ylabel('幅值（pu）');

%3电压暂升
T21=(1+7*rand())*0.02;  %t2-t1,扰动开始和结束的时间差,1-8T之间
t1=rand()*0.02*8+0.02;  %扰动开始时间，开始信号至多出现在第9个周期 
t2=t1+T21; %扰动结束时间
Aerfa=(1+7*rand())*0.1; %暂升幅值为0.1-0.8之间
z=zeros(1,length(t));
for j=1:length(t)
    U1=0;U2=0;%U为阶跃函数，U1=u(t-t1)\U2=u(t-t2)
    if t(j)>t1
       U1=1;
    else
       U1=0;
    end
    if t(j)>t2
       U2=1;
    else
       U2=0;
    end
    z(j)=A*(1+Aerfa*(U1-U2))*sin(w*t(j)); 
end
subplot(4,1,3);
plot(z);
title('电压暂升');
ylabel('幅值（pu）');

%4电压中断
T21=(1+7*rand())*0.02;  %t2-t1,扰动开始和结束的时间差,1-8T之间
t1=rand()*0.02*8+0.02;  %扰动开始时间，开始信号至多出现在第9个周期 
t2=t1+T21; %扰动结束时间
Aerfa=0.9+rand()*0.1; %降低幅值为0.9-1之间
z=zeros(1,length(t));
for j=1:length(t)
    U1=0;U2=0;%U为阶跃函数，U1=u(t-t1)\U2=u(t-t2)
    if t(j)>t1
       U1=1;
    else
       U1=0;
    end
    if t(j)>t2
       U2=1;
    else
       U2=0;
    end
    z(j)=A*(1-Aerfa*(U1-U2))*sin(w*t(j)); 
end
subplot(4,1,4);
plot(z);
title('电压中断');
ylabel('幅值（pu）');

figure(2);
%5谐波
Aerfa3=rand()*0.98+0.02;%谐波幅值为0.02-1
Aerfa5=rand()*0.98+0.02;
Aerfa7=rand()*0.98+0.02;
Aerfa11=rand()*0.98+0.02;%暂不考虑13次以上谐波
z=A*sin(w*t)+Aerfa3*sin(3*w*t)+Aerfa5*sin(5*w*t)+Aerfa7*sin(7*w*t)+Aerfa11*sin(11*w*t);
subplot(4,1,1);
plot(z);
title('谐波');
ylabel('幅值（pu）');

%6电压波动
Aerfa=rand()*0.1+0.1; %波动幅度0.1-0.2
Beita=rand()*0.4+0.1; %波动频率相对系数0.1-0.5
z=A*(1+Aerfa*sin(Beita*w*t)).*sin(w*t);
subplot(4,1,2);
plot(z);
title('电压波动');
ylabel('幅值（pu）');

%7脉冲
T21=(0.02/20)*(1+2*rand());  %脉冲宽度t2-t1为1-3ms
t1=rand()*0.02*8+0.02;  %扰动开始时间，开始信号至多出现在第9个周期
t2=t1+T21;
Aerfa=rand()*2+1;%脉冲幅值为1-3
z=zeros(1,length(t));
for j=1:length(t)
    U1=0;U2=0;
    if t(j)>t1
       U1=1;
    else
       U1=0;
    end
    if t(j)>t2
       U2=1;
    else
       U2=0;
    end
    z(j)=A*(1+Aerfa*(U1-U2))*sin(w*t(j)); 
end
subplot(4,1,3);
plot(z);
title('脉冲');
ylabel('幅值（pu）');

%8振荡
Aerfa=0.1+rand()*0.7; %振荡最大幅度，0.1-0.8
c=0.1+rand()*0.7; %振荡衰减系数0.1-0.8
Beita=rand()*6+10; %振荡频率相对系数10-16
T21=(0.5+2.5*rand())*0.02;  %t2-t1,扰动开始和结束的时间差,0.5-3T之间
t1=rand()*0.02*8+0.02;  %扰动开始时间，开始信号至多出现在第9个周期 
t2=t1+T21; %扰动结束时间
z=zeros(1,length(t));
for j=1:length(t)
    U1=0;U2=0;
    if t(j)>t1
       U1=1;
    else
       U1=0;
    end
    if t(j)>t2
       U2=1;
    else
       U2=0;
    end
    z(j)=Aerfa*exp(-c*(t(j)-t1))*(U1-U2)*sin(Beita*w*t(j))+sin(w*t(j)); 
end
subplot(4,1,4);
plot(z);
title('振荡');
ylabel('幅值（pu）');

%9切痕
%略显复杂，暂时不做，哈哈哈哈