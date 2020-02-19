import pdb
import math

# Determined by uSRAM size. Each location can store up to 18 bits.
# real + complex values each at 8 bits can be stored in 1 location
# 4 bit * 4 bit = 8 bit result. (e.g. 4 bit twiddle * 4 bit real data & 4 bit twiddle * 4 bit imag data)
# low resolution isn't an issue to me for this project.
data_width = 8
N_exp = 8

def main():
    get_param_input()
    do_cos_out()
    do_sin_out()

#==============================================================================
def get_param_input():
    global data_width
    global N_exp
    data_width = int(input('Data Width (2 < natural < 32): '))
    N_exp = int(input('N^exp; (2 < exp < 16): '))
#==============================================================================
def do_cos_out():
    file = open('twiddle_table_cosine_generated.vhd', 'w')
    print(file.name)

    file.write('case g_data_samples_exp is\n')
    # i is the (exp - 1) in 2^exp where the sample size N is 2^exp
    for i in range(1, N_exp):
        data_cnt = 2**(i+1)
        twiddle_cnt = 2**(i)
        print('i: ' + str(i) + ", data_cnt: " + str(data_cnt))
        file.write('\twhen ' + str(i+1) + ' =>\n')
        file.write('\t\tout_cos := (\n')
        # twiddle list is half the sample size N/2 = 2^(exp - 1)
        file.write('\t\t\t')
        for k in range(0, twiddle_cnt):
            #pdb.set_trace()
            cos_value = math.cos(2*math.pi*k/data_cnt)
            cos_value = round(cos_value * (2 ** data_width - 1))
            file.write('to_signed(' + str(cos_value) + ', 9), ')

        file.write('\n\t\t);\n')
    file.write('\twhen others =>\n')
    file.write('\t\tout_cos := (others => "011111111");\n')
    file.write('end case;')

    file.close()
#==============================================================================
def do_sin_out():
    file = open('twiddle_table_sine_generated.vhd', 'w')
    print(file.name)

    file.write('case g_data_samples_exp is\n')
    # i is the (exp - 1) in 2^exp where the sample size N is 2^exp
    for i in range(1, N_exp):
        data_cnt = 2**(i+1)
        twiddle_cnt = 2**(i)
        print('i: ' + str(i) + ", data_cnt: " + str(data_cnt))
        file.write('\twhen ' + str(i+1) + ' =>\n')
        file.write('\t\tout_sin := (\n')
        # twiddle list is half the sample size N/2 = 2^(exp - 1)
        file.write('\t\t\t')
        for k in range(0, twiddle_cnt):
            #pdb.set_trace()
            sin_value = math.sin(2*math.pi*k/data_cnt)
            sin_value = round(sin_value * (2 ** data_width - 1))
            file.write('to_signed(' + str(sin_value) + ', 9), ')
        file.write('\n\t\t);\n')

    file.write('\twhen others =>\n')
    file.write('\t\tout_sin := (others => "000000000");\n')
    file.write('end case;')

    file.close()

main()