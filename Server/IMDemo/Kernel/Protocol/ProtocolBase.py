# encoding=utf-8

import struct

from Kernel.Utilities.VZUtilTime import VZUtilTime


# Python struct的格式化字符定义
# https://docs.python.org/2/library/struct.html

# 粘包，分包的处理
#http://blog.csdn.net/yannanxiu/article/details/52096465

# 定义协议包头的结构体 共27个字节
class PACKAGE_HEADER:
    vzTag = []           # "VZDM"
    ptclVersion = 0      # 协议的版本号 1
    ptclEncrypt = 0      # 加密类型, 1:不加密  2:加密
    ptclCmpreType = 0    # 压缩类型, 1:不压缩  2:gzip
    bodyFormat = 0       # 消息内容格式类型, 1:JSON 2:xml
    statusCode = 0       # 响应消息中针对请求中消息头信息的问题给出的状态码，请求消息中此字段直接填 0 即可。
    time = 0             # 表示自 1970 年 1 月 1 日以来的毫秒数

    packageSize = 0      # 包的总长度
    ptclType = 0         # 协议ID
    msgAction = 0        # 消息的动作指向类型,  1:请求（request） 2:响应（response） 3: 推送（push）



class ProtocolBase:

    _session_id = ""
    __package_header = None

    def __init__(self):
        self.__package_header = PACKAGE_HEADER()

    def pack(self):
        self.__init_package_header()

        self.__packed_header()


    # 初始化协议包头部
    def __init_package_header(self):
        self.__package_header.vzTag[0] = 'V'
        self.__package_header.vzTag[1] = 'Z'
        self.__package_header.vzTag[2] = 'D'
        self.__package_header.vzTag[3] = 'M'

        self.__package_header.ptclVersion = 1
        self.__package_header.ptclEncrypt = 1
        self.__package_header.ptclCmpreType = 1
        self.__package_header.bodyFormat = 1
        self.__package_header.statusCode = 0

        self.__package_header.time = VZUtilTime.get_current_timestamp()

    # 打包协议包头部
    def __packed_header(self):
        __package = bytearray(27)
        __offset = 0
        struct.pack_into('!I', __package, __offset, self.__package_header.packageSize)
        __offset += 4
        struct.pack_into('!c', __package, __offset, self.__package_header.vzTag[0])
        __offset += 1
        struct.pack_into('!c', __package, __offset, self.__package_header.vzTag[1])
        __offset += 1
        struct.pack_into('!c', __package, __offset, self.__package_header.vzTag[2])
        __offset += 1
        struct.pack_into('!c', __package, __offset, self.__package_header.vzTag[3])
        __offset += 1
        struct.pack_into('!B', __package, __offset, self.__package_header.ptclVersion)
        __offset += 1
        struct.pack_into('!B', __package, __offset, self.__package_header.ptclEncrypt)
        __offset += 1
        struct.pack_into('!B', __package, __offset, self.__package_header.ptclCmpreType)
        __offset += 1
        struct.pack_into('!B', __package, __offset, self.__package_header.msgAction)
        __offset += 1
        struct.pack_into('!B', __package, __offset, self.__package_header.bodyFormat)
        __offset += 1
        struct.pack_into('!Q', __package, __offset, self.__package_header.time)
        __offset += 8
        struct.pack_into('!H', __package, __offset, self.__package_header.statusCode)
        __offset += 2
        struct.pack_into('!I', __package, __offset, self.__package_header.ptclType)
        __offset += 4

    # 解析协议包头部及内容
    def parse(self, __result):
        # 1.解析协议包头
        __offset = 0
        __package_size, = struct.unpack_from('!I', __result, __offset)
        __offset += 4
        __vztag1, = struct.unpack_from('!c', __result, __offset)
        __offset += 1
        __vztag2, = struct.unpack_from('!c', __result, __offset)
        __offset += 1
        __vztag3, = struct.unpack_from('!c', __result, __offset)
        __offset += 1
        __vztag4, = struct.unpack_from('!c', __result, __offset)
        __offset += 1
        __ptclVersion, = struct.unpack_from('!B', __result, __offset)
        __offset += 1
        __ptclEncrypt, = struct.unpack_from('!B', __result, __offset)
        __offset += 1
        __ptclCmpreType, = struct.unpack_from('!B', __result, __offset)
        __offset += 1
        __msgAction, = struct.unpack_from('!B', __result, __offset)
        __offset += 1
        __bodyFormat, = struct.unpack_from('!B', __result, __offset)
        __offset += 1
        __time, = struct.unpack_from('!Q', __result, __offset)
        __offset += 8
        __statusCode, = struct.unpack_from('!H', __result, __offset)
        __offset += 2
        __ptclType, = struct.unpack_from('!I', __result, __offset)
        __offset += 4

        # 2.解析协议包内容
        __content_size = __package_size - __offset
        __content_fmt = str('!' + str(__content_size) + 's')
        __package_json, = struct.unpack_from(__content_fmt, __result, __offset)

        print "---------------------------------------------------------------------------------------"
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
        print "__package_json=", __package_json
        print "---------------------------------------------------------------------------------------"