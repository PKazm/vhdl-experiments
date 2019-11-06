import csv



with open('display_data_from_vhdl.txt', mode='r', newline='') as csvfile:
    reader = csv.DictReader(csvfile, fieldnames=[0,1,2,3,4,5])
    fileout = open('nokia5110_ignignokt.hex', 'w')
    adr = 0
    for col in range(0, 6):
        print("col: " + str(col))
        csvfile.seek(0)
        for row in reader:
            print("row: " + str(row))
            data = int(row[col], 2)
            chksum = (((8 + adr.to_bytes(2, 'big')[0] + adr.to_bytes(2, 'big')[1] + data) ^ 255) + 1) & 0xFF
            fileout.write(":01" + format(adr, '0>4X') + "00" + format(data, '0>2X') + format(chksum, '0>2X') + '\n')
            adr = 1 + adr

    fileout.write(':00000001FF')
    fileout.close()