sample_exp = 6;
N = 2^sample_exp;

del_theta = 2*pi/N;
c_del = cos(del_theta);
s_del = sin(del_theta);

cosine_list = ones(1, N/2);
sine_list = zeros(1, N/2);

for m = 2:N/2
  cosine_list(m) = c_del*cosine_list(m-1) - s_del*sine_list(m-1);
  sine_list(m) = c_del*sine_list(m-1) + s_del*cosine_list(m-1);
endfor


