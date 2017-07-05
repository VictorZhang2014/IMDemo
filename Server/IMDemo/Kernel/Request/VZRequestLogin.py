# encoding=utf-8

from Kernel.Request.VZRequest import VZRequest


class VZRequestLogin(VZRequest):

    def __init__(self, account, password):
        self.__init__()
        self.__account = account
        self.__password = password

