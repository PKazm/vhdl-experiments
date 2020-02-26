close all;

sample_exp = 5;
N = 2^sample_exp;
data_width = 8;
t = 0:1:N-1;
t2 = 0:1:N/2 - 1;

carrier_amp = 3;
sample1 = carrier_amp*sin(2*pi*3*t/N);
sample2 = (1/2)*sin(2*pi*50*(t/N));
noise_multi = .1;
noise = noise_multi*randn(size(t));

signal = sample1+sample2+noise;

freq_multi = ones(1, N/2+1)*2;
freq_multi(1) = 1;
freq_multi(end) = 1;

subplot(2,4,1);
title('input signals 1, 2, combined');
hold on;
plot(t,signal);
plot(t,sample1);
plot(t,sample2);
plot(t,noise);

#legend('signal','sample1','sample2','noise');
hold off;

#==============================================================================

# BEGIN built in FFT (sanity check)

Y = fft(signal);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1 = P1 .* freq_multi;

f = (0:(N/2))/N;


# END built in FFT (sanity check)
#==============================================================================
# BEGIN custom FFT

pkg load signal;

# this is super easy in FPGA, no need to do it manually here
decomp_samples = bitrevorder(signal);
real_samples = decomp_samples;
imaginary_samples = zeros(1, N);

complex_samples = decomp_samples - i*imaginary_samples;



# precompute sines and cosines for twiddle factors
#twiddle_cosine = cos(2*pi*t2/N/2)
#twiddle_sine = sin(2*pi*t2/N/2)
#twiddle_complex = twiddle_cosine - i*twiddle_sine;
twiddle_cosine = ones(1,N/2-1);
twiddle_sine = zeros(1,N/2-1);
twiddle_complex = ones(1,N/2-1);
for m = 2:N/2
    twiddle_cosine(m) = cos(2*pi/N) * twiddle_cosine(m-1) - sin(2*pi/N) * twiddle_sine(m-1);
    twiddle_sine(m) = cos(2*pi/N) * twiddle_sine(m-1) + sin(2*pi/N) * twiddle_cosine(m-1);
end
twiddle_complex = twiddle_cosine - i*twiddle_sine;

subplot(2,4,2);
title('twiddle outputs');
hold on;
plot(t2,twiddle_cosine);
plot(t2,twiddle_sine);
#plot(twiddle_complex);

#legend('twiddle cosine','twiddle sine');
hold off;

subplot(2,4,3);
title('twiddle complex');
hold on;
plot(twiddle_complex, '-o');
axis([-1 1 -1 1]);
grid on;
hold off;

real_output = real_samples;
imag_output = imaginary_samples;


# iterate through each stage in the frequency synthesis process
# number of stages = log2(N) (e.g. 5 stages for N = 32)
for stage = 1:sample_exp
    DFT_cnt = N/(2^stage);
    # iterate through each sub-DFT
    twiddle_index_step = N/2^(stage);
    output = ['stage: ', num2str(stage)];
    disp(output);
    for DFT = 1:DFT_cnt
        # iterate through each butterfly
        # number of butterflies per DFT increasese with the stage number but the total remains the same (N/2)
        output = ['DFT: ', num2str(DFT)];
        disp(output);
        for butterfly = 1:(2^(stage - 1))
            # reference index for stage 1: 1, 3, 5, 7; stage 2: 1, 2, 5, 6, stage 3: 1, 2, 3, 4; matlab index start at 1
            index_ref = butterfly + (DFT - 1) * 2^(stage);
            index_other = index_ref + 2^(stage - 1);
            twiddle_index = (butterfly - 1) * twiddle_index_step + 1;
            
            # calc intermediate product of sample 2 and twiddle factor
            real_temp = real_output(index_other) * twiddle_cosine(twiddle_index) + imag_output(index_other) * twiddle_sine(twiddle_index);
            imag_temp = imag_output(index_other) * twiddle_cosine(twiddle_index) - real_output(index_other) * twiddle_sine(twiddle_index);

            # calc final sum of sample 2
            real_output(index_other) = real_output(index_ref) - real_temp;
            imag_output(index_other) = imag_output(index_ref) - imag_temp;
            
            # calc final sum of sample 1
            real_output(index_ref) = real_output(index_ref) + real_temp;
            imag_output(index_ref) = imag_output(index_ref) + imag_temp;
            
            output = ['i_ref ', num2str(index_ref), ', o_ref ', num2str(index_other), ', t_index ', num2str(twiddle_index)];
            disp(output);
        end
    end
end

# END custom FFT
#==============================================================================
# quantized FFT

twiddle_cos_quant = int32(round((twiddle_cosine) * (2^(data_width)-1)));
twiddle_sin_quant = int32(round((twiddle_sine) * (2^(data_width)-1)));

subplot(2,4,4);
title('twiddle complex int9');
hold on;
plot(twiddle_cos_quant, -twiddle_sin_quant, '-o');
#plot(t2, twiddle_cos_quant);
#plot(t2, twiddle_sin_quant);
a_limit = max(max(abs(twiddle_cos_quant)),max(abs(twiddle_sin_quant)));
axis([-a_limit a_limit -a_limit a_limit]);
grid on;
hold off;

real_output_quant = int32(round((real_samples/carrier_amp)*(2^data_width-1)));
imag_output_quant = int32(round(imaginary_samples*(2^data_width-1)));

diary on;
for stage = 1:sample_exp
    DFT_cnt = N/(2^stage);
    # iterate through each sub-DFT
    twiddle_index_step = N/2^(stage);
    output = ['stage_q: ', num2str(stage)];
    disp(output);
    for DFT = 1:DFT_cnt
        # iterate through each butterfly
        # number of butterflies per DFT increasese with the stage number but the total remains the same: N/2
        output = ['DFT_q: ', num2str(DFT)];
        disp(output);
        for butterfly = 1:(2^(stage - 1))
            # reference index for stage 1: 1, 3, 5, 7; stage 2: 1, 2, 5, 6, stage 3: 1, 2, 3, 4
            index_ref = butterfly + (DFT - 1) * 2^(stage);
            index_other = index_ref + 2^(stage - 1);
            twiddle_index = (butterfly - 1) * twiddle_index_step + 1;
            
            output = ['quant: i_ref ', num2str(index_ref), ', o_ref ', num2str(index_other), ', t_index ', num2str(twiddle_index)];
            disp(output);
            #output = ['ref: ',num2str(complex(real_output_quant(index_ref), imag_output_quant(index_ref))),', other: ',num2str(complex(real_output_quant(index_other), imag_output_quant(index_other))),', twiddle: ',num2str(complex(twiddle_cos_quant(twiddle_index), twiddle_sin_quant(twiddle_index)))];
            #disp(output);
            # calc intermediate product of sample 2 and twiddle factor
            real_temp = floor(((real_output_quant(index_other) * twiddle_cos_quant(twiddle_index)) + (imag_output_quant(index_other) * twiddle_sin_quant(twiddle_index)))/(2^(data_width)));
            imag_temp = floor(((imag_output_quant(index_other) * twiddle_cos_quant(twiddle_index)) - (real_output_quant(index_other) * twiddle_sin_quant(twiddle_index)))/(2^(data_width)));

            output = [num2str(real_temp),' = ',num2str(real_output_quant(index_other)),' * ',num2str(twiddle_cos_quant(twiddle_index)),' + ',num2str(imag_output_quant(index_other)),' * ',num2str(twiddle_sin_quant(twiddle_index))];
            disp(output);
            output = [num2str(imag_temp),' = ',num2str(imag_output_quant(index_other)),' * ',num2str(twiddle_cos_quant(twiddle_index)),' - ',num2str(real_output_quant(index_other)),' * ',num2str(twiddle_sin_quant(twiddle_index))];
            disp(output);

            # calc final sum of sample 2
            real_output_quant(index_other) = floor((real_output_quant(index_ref) - real_temp)/4);
            imag_output_quant(index_other) = floor((imag_output_quant(index_ref) - imag_temp)/4);

            output = [num2str(complex(real_output_quant(index_other), imag_output_quant(index_other))),' = ',num2str(complex(real_output_quant(index_ref), imag_output_quant(index_ref))),' - ',num2str(complex(real_temp, imag_temp))];
            disp(output);
            
            # calc final sum of sample 1
            real_temp2 = floor((real_output_quant(index_ref) + real_temp)/4);
            imag_temp2 = floor((imag_output_quant(index_ref) + imag_temp)/4);

            output = [num2str(complex(real_temp2, imag_temp2)),' = ',num2str(complex(real_output_quant(index_ref), imag_output_quant(index_ref))),' + ',num2str(complex(real_temp, imag_temp))];
            disp(output);

            real_output_quant(index_ref) = real_temp2;
            imag_output_quant(index_ref) = imag_temp2;
            
            #output = ['quant: i_ref ', num2str(index_ref), ', o_ref ', num2str(index_other), ', t_index ', num2str(twiddle_index),' = ', num2str(complex(real_output_quant(index_ref), imag_output_quant(index_ref))), '; ', num2str(complex(real_output_quant(index_other), imag_output_quant(index_other)))];
            #disp(output);
        end
    end
end
diary off;

# END quantized FFT
#==============================================================================
# compare FFT outputs
complex_synth = real_output + i*imag_output;
myP2 = abs(complex_synth/N);
myP1 = myP2(1:N/2+1);
myP1 = myP1 .* freq_multi;

complex_synth_quant = complex(real_output_quant, imag_output_quant);
myP2_quant = uint32(hypot(real_output_quant, imag_output_quant));#/(data_width));
myP1_quant = myP2_quant(1:N/2+1);
myP1_quant = myP1_quant .* freq_multi;

#==============================================================================
subplot(2,4,5);
title('quantized FFT');
hold on;

stem(f, myP1_quant);
hold off;
#==============================================================================
subplot(2,4,6);
title('compare FFTs');
hold on;
#plot(f, decomp_samples(1:N/2+1));
#plot(f, imaginary_samples(1:N/2+1));
plot(f, P1);
stem(f, myP1);

#legend('Matlab FFT','my FFT','my FFT quant');
hold off;
#==============================================================================
#subplot(2,4,7);
#title('FFT error');
#hold on;
#plot(f, P1 - myP1);
#hold off;
#==============================================================================
subplot(2,4,7);
title('compare complex outputs');
hold on;
plot(Y);
plot(complex_synth);
hold off;
#==============================================================================
subplot(2,4,8);
title('quantized complex');
hold on;

plot(complex_synth_quant);

#legend('Matlab FFT', 'My FFT');
hold off;

# END custom FFT