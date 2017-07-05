# encoding=utf-8

from Kernel.Networks import VZSocket


_host = "10.18.138.27"
_port = 8888
_sock = VZSocket.VZSocket(_host, _port)
_sock.start()
_sock.add_message("hello, I am server")



