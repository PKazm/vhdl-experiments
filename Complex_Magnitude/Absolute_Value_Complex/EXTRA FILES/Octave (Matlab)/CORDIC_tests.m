clear;
close all;


K = 1;
A = pi*.5;

Yin = 20;
Xin = 10;

Xout = K * (Xin*cos(A) - Yin*sin(A));
Yout = K * (Yin*cos(A) + Xin*sin(A));

comp_in = Xin + i*Yin;
comp_out = Xout + i*Yout;

abs_in = abs(comp_in);
abs_out = abs(comp_out);


hold on;
plot(comp_in, 'o');
plot(comp_out, 'o');

a_limit = max([abs_in, abs_out]);
axis([-a_limit a_limit -a_limit a_limit]);
legend(['in ',num2str(comp_in)], ['out ',num2str(comp_out)]);
grid on;
hold off;