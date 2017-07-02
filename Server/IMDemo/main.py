# encoding=utf-8

from Kernel.Networks import VZSocket


_host = "192.168.0.103"
_port = 8888
_sock = VZSocket.VZSocket(_host, _port)
_sock.start()
_sock.add_message("hello, I am server")



