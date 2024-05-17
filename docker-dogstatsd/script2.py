import socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP
sock.sendto(b"custom_metric:60|g|#shell", ("localhost", 8125))