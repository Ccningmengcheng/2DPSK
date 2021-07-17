%ʵ�����
i = 10;%��Ϣ����
j = 10000;%������
k = j/i;%������Ԫ�����ڵĲ�������
t = linspace(0,10,j);%������[0,10]�ֳ�10000�ݲ�����
fc = 2*pi*5;%�ز�Ƶ��=5HZ
z = 1;%��˹�ŵ������
Zb = sin(t*fc);%�ز�
Zbm = sin(t*fc+pi);%������ز�

%�������������źţ����ɳ���Ϊ10�ģ�0��1�ģ�������飬���������׶˵�ֵ���������������д��0,1
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
title('������');
axis([0,i,-1,2]);

%���������:��0Ϊ��׼�������;�����ȡ��򣬵õ���������һλ������ǰ�������ڵ�ǰ�������ǰһ�����������
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
title('�����');
axis([0,i,-1,2]);

%�ز���Ϣ
figure;
subplot(211);
plot(t,Zb);
title('�ز�');
axis([0,1,-1.5,1.5]);
subplot(212);
plot(t,Zbm);
title('���������ں��ز�');
axis([0,1,-1.5,1.5]);

%2pdsk���ط����ƣ��������Ϊ0��������ز����������Ϊ1�������������ز���ʵ��2dpsk�źŵ��ơ�
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

%��˹�ŵ����룺��������Ϊ z dB�ļ�Ȩ��˹������
W4=awgn(W3,z);

Wgra(W4,5);



%��ɽ����2dpsk�ź��뱾���ز����
W5=W4.*Zb;

Wgra(W5,5);


%��ͨ�˲�����������һ����Ƶ��ͼ�����ã�Ӧ���ý�ֹƵ��Ϊ4�ĵ�ͨ�˲�����
%��ͨ�˲������������fdatool����ʵ�֣�����Դ���dtlbq.m�ļ���
Hd=dtlbq;
lp=filter(Hd,W5);
W6=lp;

Wgra(W6,1);

%�����о�:��ͨ�˲������ӳ٣��ҵ�ͨ�˲���Ĳ��β�ƽ����
%����ÿ����Ԫ������е��ź����ȶ�������ѡ��ÿ����Ԫ������е���Ϊ�����㣬��������ֵ�����о���
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
title('�����о�����');

%�����ת�����룺����������������жϣ�����������0��1ѡ���Ƿ��߼�ȡ����
%������У�1��ʾ�����뵱ǰλ�������ǰһλ��ͬ����˵�ǰ�����ֵΪ1ʱ����ǰ������͵�����һλ�������߼�ȡ����
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
title('�����ת������');