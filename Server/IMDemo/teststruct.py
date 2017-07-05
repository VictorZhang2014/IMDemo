# encoding=utf-8

import struct


a = 20
b = 200

buff = struct.pack('ii', a, b)
# print repr(buff)

buff2 = struct.unpack('ii', buff)
# print buff2[0]

print struct.calcsize('ii')



