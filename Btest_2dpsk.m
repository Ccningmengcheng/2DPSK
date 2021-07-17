%实验参数
i = 10;%信息长度
j = 10000;%采样数
k = j/i;%单个码元区间内的采样点数
t = linspace(0,10,j);%将区间[0,10]分成10000份采样点
fc = 2*pi*5;%载波频率=5HZ
z = 1;%高斯信道信噪比
Zb = sin(t*fc);%载波
Zbm = sin(t*fc+pi);%移相后载波

%产生基带方波信号：生成长度为10的（0到1的）随机数组，根据区间首端点值，区间内逐采样点写入0,1
a=round(rand(1,i));
W1=zeros(1,j);
for n=1:i
    if a(n)<1
        for m=k*(n-1)+1:k*n
            W1(m)=0;
        end
    else
        for m=k*(n-1)+1:k*n
            W1(m)=1;
        end
    end
end
figure;
subplot(211);
plot(t,W1);
title('绝对码');
axis([0,i,-1,2]);

%产生相对码:以0为基准，相对码和绝对码取亦或，得到相对码的下一位。即当前相对码等于当前绝对码和前一个相对码的异或。
b=zeros(1,i);
b(1)=a(1);
for n=2:i
    if a(n)==b(n-1)
        b(n)=0;
    else
        b(n)=1;
    end
end
W2=zeros(1,j);
for n=1:i
    if b(n)==0
        for m=k*(n-1)+1:k*n
            W2(m)=0;
        end
    else
        for m=k*(n-1)+1:k*n
            W2(m)=1;
        end
    end
end
subplot(212);
plot(t,W2);
title('相对码');
axis([0,i,-1,2]);

%载波信息
figure;
subplot(211);
plot(t,Zb);
title('载波');
axis([0,1,-1.5,1.5]);
subplot(212);
plot(t,Zbm);
title('移相半个周期后载波');
axis([0,1,-1.5,1.5]);

%2pdsk键控法调制：若相对码为0，则加载载波，若相对码为1，则加载移相后载波，实现2dpsk信号调制。
W3=zeros(1,j);
for n=1:i
    if b(n)==0
        for m=k*(n-1)+1:k*n
            W3(m)=Zb(m);
        end
    else
        for m=k*(n-1)+1:k*n
            W3(m)=Zbm(m);
        end
    end
end

Wgra(W3,2);

%高斯信道加噪：添加信噪比为 z dB的加权高斯白噪声
W4=awgn(W3,z);

Wgra(W4,5);



%相干解调：2dpsk信号与本地载波相乘
W5=W4.*Zb;

Wgra(W5,5);


%低通滤波器：根据上一步的频域图分析得，应采用截止频率为4的低通滤波器。
%低通滤波器的设计利用fdatool工具实现，导出源码见dtlbq.m文件。
Hd=dtlbq;
lp=filter(Hd,W5);
W6=lp;

Wgra(W6,1);

%抽样判决:低通滤波器有延迟，且低通滤波后的波形不平整。
%由于每个码元区间的中点信号最稳定，于是选择每个码元区间的中点作为抽样点，根据正负值进行判决。
c=zeros(1,i);
W7=zeros(1,j);
if W6(k/2)>0
    c(1)=1;
    for m=1:k
        W7(m)=1;
    end
else
    c(1)=0;
    for m=1:k
        W7(m)=0;
    end
end
for n=1:i-1
    if W6(n*k+k/2)>0
        c(n+1)=1;
        for m=n*k:n*k+k-1
            W7(m)=1;
        end
    else
        c(n+1)=0;
        for m=n*k:n*k+k-1
            W7(m)=0;
        end
    end
end
figure;
subplot(211);
plot(t,W7);
axis([0,i,-1,2]);
title('抽样判决波形');

%相对码转绝对码：对相对码数组逐项判断，根据相对码的0，1选择是否逻辑取反。
%相对码中，1表示绝对码当前位与相对码前一位不同，因此当前相对码值为1时，当前绝对码就等于上一位相对码的逻辑取反。
d=zeros(1,i);
if(c(1)==1)
    d(1)=0;
else
    d(1)=1;
end

for n=2:10
    if (c(n)==1)
        if(c(n-1)==1)
            d(n)=0;
        else
            d(n)=1;
        end
    else
        d(n)=c(n-1);
    end
end
W8=zeros(1,j);
for n=1:10
    if d(n)==1
        for m=k*(n-1)+1:k*n
            W8(m)=1;
        end
    else
        for m=k*(n-1)+1:k*n
            W8(m)=0;
        end
    end
end
subplot(212);
plot(t,W8);
axis([0,i,-1,2]);
title('相对码转绝对码');