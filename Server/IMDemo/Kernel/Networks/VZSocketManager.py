# encoding=utf-8

from Kernel.Networks.VZSocket import VZSocket


class VZSocketManager:

    def __init__(self):
        __host = "10.18.138.27"
        __port = 8888
        self.__socket_instance = VZSocket(__host, __port)
        self.__socket_instance.start()

    def send_data(self, data):
        self.__socket_instance.add_message(data)


