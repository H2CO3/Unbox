DAEMON = unboxd
LIBRARY = libunbox.dylib

CC = gcc
LD = $(CC)
CFLAGS = -isysroot /User/sysroot \
	 -Wall \
	 -std=gnu99 \
	 -c
LDFLAGS=-isysroot /User/sysroot \
	-w \
	-F/System/Library/PrivateFrameworks \
	-lobjc \
	-framework Foundation \
	-framework CoreFoundation \
	-framework AppSupport

DAEMON_OBJECTS = UBServer.o UBDelegate.o
LIBRARY_OBJECTS = UBClient.o

all: $(DAEMON) $(LIBRARY)

$(DAEMON): $(DAEMON_OBJECTS)
	$(LD) $(LDFLAGS) -o $(DAEMON) $(DAEMON_OBJECTS)
	chown root:wheel $(DAEMON)
	chmod 4777 $(DAEMON)

$(LIBRARY): $(LIBRARY_OBJECTS)
	$(LD) $(LDFLAGS) -dynamiclib -install_name /usr/lib/$(LIBRARY) -o $(LIBRARY) $(LIBRARY_OBJECTS)
	cp $(LIBRARY) /usr/lib
	cp $(LIBRARY) /User/sysroot/usr/lib

%.o: %.m
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -rf $(DAEMON_OBJECTS) $(DAEMON) $(LIBRARY_OBJECTS) $(LIBRARY)
