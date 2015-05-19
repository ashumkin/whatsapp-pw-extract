CC=gcc
# both SSL and Crypto libraries are set
# one of them must to work
LIBS=-lssl -lcrypto
all:
	$(CC) $(LIBS) wa_pbkdf4.c -o wa_pbkdf2
