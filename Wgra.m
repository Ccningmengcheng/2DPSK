function  Wgra(x,Y)

i=10;
j=10000;
t=linspace(0,10,j);
k=j/i;

figure;
y=fft(x); 
n = length(x);                         
fshift = (-n/2:n/2-1)*(k/n); 
yshift = fftshift(y);%ʹ��Ƶ�ʷ��������ھ�������Ĵ�����

subplot(211);
plot(t,x);
axis([0,i,-Y,Y]);
title('ʱ��ͼ');

subplot(212);
plot(fshift,abs(yshift));
title('�Գ�Ƶ��ͼ');
axis([-15,15,-500,3000]);
