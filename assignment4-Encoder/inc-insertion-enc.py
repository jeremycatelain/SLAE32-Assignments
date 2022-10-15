#!/usr/bin/python

import sys

input = sys.argv[1] 

print 'String length : '+ str(len(input))

### Initialization of the Lists
# Retrieve the shellcode and insert it into a list
stringList = [input[i:i+4] for i in range(0, len(input), 4)]
# Empty list for our encoded shellcode
stringListEncoded = []


### First part to compute the number of set, the size of the last set and the number of value in the last set
#Counters
nbSet = 0
length = len(stringList)
valPos = 1
lengthSet = 1

print "length" + str(length)

# Compute how many set of data there will be.
while valPos <= length:
    valPos = valPos + lengthSet  
    lengthSet = lengthSet + 1
    nbSet = nbSet + 1

# Compute how many value are in the last set
l = valPos - lengthSet
supplIt = length - (valPos - lengthSet)
print(supplIt) #nb iterations supplementaires


### Second part, build the encoded shellcode   
# Counters
nbInsertion = 1
posValue = 0
nbValueToMove = 1
savedPosValue = 0

# Iteration until nbSet-1 
while nbInsertion <= (nbSet - 1): 
    nbVal = 0
    while nbVal < nbInsertion : # nb value to move = nb insertion
        val = '0x%02s' % stringList[posValue + nbVal][2:]
        stringListEncoded.append(val) # Insert the value in the list for the encoded shellcode     
        nbVal = nbVal + 1

    # Encoding insertion 0xaa
    nbEncode = 0
    while nbEncode < nbInsertion:
        encoder =  '0x%02x' % 0xaa
        stringListEncoded.append(encoder) #insert
        nbEncode = nbEncode + 1
    
    # Increment counters
    savedPosValue = posValue
    posValue = posValue + nbInsertion 
    nbInsertion = nbInsertion + 1
    
# Last iteration
it = 0
while it < supplIt:
    val = '0x%02s' % stringList[posValue+it][2:]
    stringListEncoded.append(val) #insert 
    it = it + 1


# Insertion of the Egg at the end
for i in range(4):
    encoder = '0x%02x' % 0xbb
    stringListEncoded.append(encoder) #insert 

# Convert the list into the good format and display the result
finalvalue = ""
for val in stringListEncoded:
    finalvalue = finalvalue + str(val) + ','

print finalvalue

