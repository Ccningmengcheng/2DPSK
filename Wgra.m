function  Wgra(x,Y)

i=10;
j=10000;
t=linspace(0,10,j);
k=j/i;

figure;
y=fft(x); 
n = length(x);                         
fshift = (-n/2:n/2-1)*(k/n); 
yshift = fftshift(y);%使零频率分量出现在矩阵的中心处附近

subplot(211);
plot(t,x);
axis([0,i,-Y,Y]);
title('时域图');

subplot(212);
plot(fshift,abs(yshift));
title('对称频域图');
axis([-15,15,-500,3000]);
