# encoding=utf-8

import socket
import threading

from Kernel.Utilities import VZThread
from Kernel.Utilities.VZUtilCommon import VZUtilCommon
from Kernel.Networks.VZSocketDelegate import VZSocketDelegate


class VZSocket(VZSocketDelegate):

    __run_accepting_client = True  # Whether accepting clients
    __sock_instance = None

    def __init__(self, host, port):
        self.__host = host
        self.__port = port

        self.__send_thread_lock = threading.Lock()

        # 发送消息队列
        self.__send_message_queue = []

        # 发送消息的线程列表，所有客户端的
        self.__send_message_thread_list = []

        # 接收消息的线程列表，所有的客户端的
        self.__receive_message_thread_list = []

    def start(self):
        self.__close()
        self.__sock_instance = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.__sock_instance.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.__sock_instance.bind((self.__host, self.__port))
        self.__sock_instance.listen(10)
        print "I'm going to accept 10 clients..."
        self.__accept_clients()
        # self.__create_thread(target_func=self.__accept_clients, arg1=None)

    def __accept_clients(self):
        while self.__run_accepting_client:
            (conn, address) = self.__sock_instance.accept()
            print "Accepted a client, address = ", address,

            __sessionId = VZUtilCommon.generate_session_id(address[0])
            print "and session Id is", __sessionId

            __receive_thread_instance = self.__create_thread(self.__receive_message, (conn, __sessionId))
            self.__receive_message_thread_list.append({"sessionId": __sessionId, "connection": conn, "thread": __receive_thread_instance})

            __send_thread_instance = self.__create_thread(self.__send_message, (conn, __sessionId))
            self.__send_message_thread_list.append({"sessionId": __sessionId, "connection": conn, "thread": __send_thread_instance})

    def __receive_message(self, tupleconn):
        while True:
            self.__MAX_BYTES = 2048
            __result = tupleconn[0].recv(self.__MAX_BYTES)

            self.socket_recv(self, __result)

            print "Receive Packages is : ", __result

            self.add_message("sessionId=" + tupleconn[1])

    def __send_message(self, tupleconn):
        while True:
            if len(self.__send_message_queue) > 0:
                self.__send_message_queue.reverse()
                for message in self.__send_message_queue:
                    tupleconn[0].send(message)
                    print "Send Packages is ：", message

                    self.__send_thread_lock.acquire()
                    self.__send_message_queue.remove(message)
                    self.__send_thread_lock.release()

    def add_message(self, message):
        self.__send_thread_lock.acquire()
        self.__send_message_queue.append(message)
        self.__send_thread_lock.release()

    def stop_accept(self):
        self.__run_accepting_client = False

    def __close(self):
        if self.__sock_instance is not None:
            self.__sock_instance.close()

    @staticmethod
    def __create_thread(target_func, arg1):
        __thread_instance = VZThread.VZThread(target=target_func, args=(arg1,))
        __thread_instance.setDaemon(True)
        __thread_instance.start()
        return __thread_instance


