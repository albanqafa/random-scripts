import socket #socket lib necessary for connection
import logging
import threading
from threading import Thread
import time
print(""" ,ggggggggggg,                           """)
print('''dP"""88""""""Y8,                      8I ''')
print('''Yb,  88      `8b                      8I   88  88888888ba     ,ad8888ba,   ''')
print(""" `"  88      ,8P                      8I   88  88      "8b   d8"'    `"8b  """)
print("""     88aaaad8P"                       8I   88  88      ,8P  d8'            """)
print('''     88""""Yb,      ,gggg,gg    ,gggg,8I   88  88aaaaaa8P'  88             ''')
print("""     88     "8b    dP"  "Y8I   dP"  "Y8I   88  88""'"88'    88             """)
print("""     88      `8i  i8'    ,8I  i8'    ,8I   88  88    `8b    Y8,            """)
print("""     88       Yb,,d8,   ,d8b,,d8,   ,d8b,  88  88     `8b    Y8a.    .a8P  """)
print("""     88        Y8P"Y8888P"`Y8P"Y8888P"`Y8  88  88      `8b    `"Y8888Y"'   """)
print('')
ircsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server = raw_input("Server: ") # Server
port = int(raw_input("Port: "))
channel = raw_input("Channel: ") # Channel
nick = raw_input("Nick: ") # Your nickname
exitcode = "bye " + nick # useless
def connect_irc():
	ircsock.connect((server, port)) # Here we connect to the server using the port
def sendnick():
	ircsock.send(bytes("USER "+ nick +" "+ nick +" "+ nick + " " + nick + "\n"))
	ircsock.send(bytes("NICK "+ nick +"\n")) # assign the nick
def joinchan(chan): # join channel(s)
	ircsock.send(bytes("JOIN "+ chan +"\n"))
def getmessage():
	getmessage.ircmsg = ircsock.recv(2048)
def sendmsg():
	msg_to_send = str("")
	msg_to_send = raw_input("msg: ")
	if msg_to_send != "":
		ircsock.send(bytes("PRIVMSG "+ channel +" :" + msg_to_send + "\n"))
	return msg_to_send
def pong(): # respond to server Pings
	ircsock.send(bytes("PONG :pingis\n"))
def checkping(ircmsg):
	if ircmsg.find("PING :") != -1: #listen for ping
		pong()
def getircinput(ircmsg):
	ircmsg = ircmsg.strip('\n\r')
	getircinput.ircmsg = ircmsg
connect_irc()
sendnick()
joinchan(channel)
def listener():
	logging.debug('Starting Listener')
	getmessage(); getircinput(getmessage.ircmsg); checkping(getmessage.ircmsg); print(getircinput.ircmsg)
	logging.debug('Exiting Listener')
def sender():
	logging.debug('Starting Sender')
	sendmsg()
	logging.debug('Exiting Sender')
msg_to_send = b""
while msg_to_send != "/exit": # run until user input /exit
	thread_listener = Thread(target=listener)
	thread_listener.setDaemon(True)
	thread_listener.start()
	msg_to_send = sendmsg()
	thread_listener.join(timeout=0)
