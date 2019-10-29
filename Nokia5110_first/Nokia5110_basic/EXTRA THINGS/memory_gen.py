import pdb

mem_X = 84
mem_Y = 6

pdb.set_trace()
fileout = open('pyout.txt', 'w')
for i in range(0, mem_X):
    if((i % 2) == 0):
        fileout.write("(X\"FF\", X\"00\", X\"FF\", X\"00\", X\"FF\", X\"00\"),\t\t-- X = " + str(i) + '\n')
    else:
        fileout.write("(X\"00\", X\"FF\", X\"00\", X\"FF\", X\"00\", X\"FF\"),\t\t-- X = " + str(i) + '\n')
	
fileout.close()