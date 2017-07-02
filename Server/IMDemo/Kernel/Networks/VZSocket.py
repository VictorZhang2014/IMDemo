# encoding=utf-8

import socket
import threading

from Kernel.Utilities import VZThread


class VZSocket:

    __run_accepting_client = True
    __sock_instance = None

    def __init__(self, host, port):
        self.__host = host
        self.__port = port

        self.__send_thread_lock = threading.Lock()
        self.__send_message_queue = []
        self.__send_message_thread_list = []
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
            print "Accepted a client, address = ", address

            __receive_thread_instance = self.__create_thread(self.__receive_message, conn)
            self.__receive_message_thread_list.append({"connection": conn, "thread": __receive_thread_instance})
            __send_thread_instance = self.__create_thread(self.__send_message, conn)
            self.__send_message_thread_list.append({"connection": conn, "thread": __send_thread_instance})

    def __receive_message(self, conn):
        while True:
            self.__MAX_BYTES = 2048
            __result = conn.recv(self.__MAX_BYTES)

            print "Receive Packages is : ", __result

    def __send_message(self, conn):
        while True:
            if len(self.__send_message_queue) > 0:
                self.__send_message_queue.reverse()
                for message in self.__send_message_queue:
                    conn.send(message)
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


