# encoding=utf-8


class ProtocolType:

    PROTOCOL_TYPE_None                  =  0

    # 发送与接收协议
    PROTOCOL_TYPE_HeartBeats            =  101010  # 心跳
    PROTOCOL_TYPE_Login                 =  200001  # 登录


    # 仅服务器推送到客户端协议
    PROTOCOL_TYPE_SessionId             =  800001  # 服务器端发送 sessionId 到客户端