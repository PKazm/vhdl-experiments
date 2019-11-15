x_min = 0;
x_max = 2*pi;
samples = 64;
x_steps = x_max.samples;

x=x_min:x_steps:x_max;

plot(x, (sin(x+.5)+1)*1.5, '-o');

lvds_value = @lvds_comparator

function y = lvds_comparator(x)
    y = 2;
end