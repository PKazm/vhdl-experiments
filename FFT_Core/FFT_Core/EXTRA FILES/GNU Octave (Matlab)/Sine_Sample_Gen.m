N = 2 ^ 5;
data_width = 8;
t = 0:1:N-1;
raw_sine = sin(2*pi*(t/N/2)) + 1;
sine_table = uint8(round(raw_sine*2^(data_width-1)));
raw_cosine = cos(2*pi*(t/N/2)) + 1;
cosine_table = uint8(round(raw_cosine*2^(data_width-1)));

hold on;
plot(t,sine_table);
plot(t,cosine_table);
hold off;