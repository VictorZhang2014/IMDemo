# encoding=utf-8

import threading


class VZThread(threading.Thread):

    def __init__(self, group=None, target=None, name=None,
                 args=(), kwargs=None, verbose=None):
        super(VZThread, self).__init__(group, target, name, args, kwargs, verbose)
        self.__running = threading.Event()        # 用于停止线程的标识
        self.__running.set()                      # 初始化时设置为True

    def stop(self):
        self.__running.clear()


