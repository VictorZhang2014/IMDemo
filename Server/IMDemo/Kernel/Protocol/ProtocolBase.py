# encoding=utf-8

import ctypes


# 粘包，分包的处理
#http://blog.csdn.net/yannanxiu/article/details/52096465

class PACKAGE_HEADER:
    vzTag = ""           # "VZDM"
    ptclVersion = 0      # 协议的版本号 1
    ptclEncrypt = 0      # 加密类型, 1:不加密  2:加密
    ptclCmpreType = 0    # 压缩类型, 1:不压缩  2:gzip
    bodyFormat = 0       # 消息内容格式类型, 1:JSON 2:xml
    statusCode = 0       # 响应消息中针对请求中消息头信息的问题给出的状态码，请求消息中此字段直接填 0 即可。
    time = 0             # 表示自 1970 年 1 月 1 日以来的毫秒数

    packageSize = 0      # 包的总长度
    ptclType = 0         # 协议ID
    msgAction = 0        # 消息的动作指向类型,  1:请求（request） 2:响应（response）



class ProtocolBase:

    session_id = ""

    def __init__(self):
        pass

    def pack(self):
        pass

    def parse(self):
        pass