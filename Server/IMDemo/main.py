# encoding=utf-8

from Kernel.Networks.VZSocketManager import VZSocketManager



_sock = VZSocketManager()
_sock.send_data("hello, I am server")







'''
import struct

package_size = 78
vztag = "VZDM"
ptclVersion = 1
ptclEncrypt=1
ptclCmpreType=1
msgAction=1
bodyFormat=1
time =9809994873209857432
statusCode=0
ptclType=4323

__package = bytearray(27)
__offset = 0
struct.pack_into('!I', __package, __offset, package_size)
__offset += 4
struct.pack_into('!c', __package, __offset, vztag[0])
__offset += 1
struct.pack_into('!c', __package, __offset, vztag[1])
__offset += 1
struct.pack_into('!c', __package, __offset, vztag[2])
__offset += 1
struct.pack_into('!c', __package, __offset, vztag[3])
__offset += 1
struct.pack_into('!B', __package, __offset, ptclVersion)
__offset += 1
struct.pack_into('!B', __package, __offset, ptclEncrypt)
__offset += 1
struct.pack_into('!B', __package, __offset, ptclCmpreType)
__offset += 1
struct.pack_into('!B', __package, __offset, msgAction)
__offset += 1
struct.pack_into('!B', __package, __offset, bodyFormat)
__offset += 1
struct.pack_into('!Q', __package, __offset, time)
__offset += 8
struct.pack_into('!H', __package, __offset, statusCode)
__offset += 2
struct.pack_into('!I', __package, __offset, ptclType)
__offset += 4


# print __package

__offset = 0
__package_size, = struct.unpack_from('!I', __package, __offset)
__offset += 4
__vztag1, = struct.unpack_from('!c', __package, __offset)
__offset += 1
__vztag2, = struct.unpack_from('!c', __package, __offset)
__offset += 1
__vztag3, = struct.unpack_from('!c', __package, __offset)
__offset += 1
__vztag4, = struct.unpack_from('!c', __package, __offset)
__offset += 1
__ptclVersion, = struct.unpack_from('!B', __package, __offset)
__offset += 1
__ptclEncrypt, = struct.unpack_from('!B', __package, __offset)
__offset += 1
__ptclCmpreType, = struct.unpack_from('!B', __package, __offset)
__offset += 1
__msgAction, = struct.unpack_from('!B', __package, __offset)
__offset += 1
__bodyFormat, = struct.unpack_from('!B', __package, __offset)
__offset += 1
__time, = struct.unpack_from('!Q', __package, __offset)
__offset += 8
__statusCode, = struct.unpack_from('!H', __package, __offset)
__offset += 2
__ptclType, = struct.unpack_from('!I', __package, __offset)
__offset += 4
print "__package_size=", __package_size
print "__vztag=", __vztag1 + __vztag2 + __vztag3 + __vztag4
print "__ptclVersion=", __ptclVersion
print "__ptclEncrypt=", __ptclEncrypt
print "__ptclCmpreType=", __ptclCmpreType
print "__msgAction=", __msgAction
print "__bodyFormat=", __bodyFormat
print "__time=", __time
print "__statusCode=", __statusCode
print "__ptclType=", __ptclType

'''

