DAEMON = unboxd
LIBRARY = libunbox.dylib
SYSROOT = /opt/local/var/iPhoneOS4.3.sdk

CC = arm-apple-darwin10-gcc
LD = $(CC)
CFLAGS = -isysroot $(SYSROOT) \
	 -Wall \
	 -c
LDFLAGS=-isysroot $(SYSROOT) \
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
	$(LD) $(LDFLAGS) -o $@ $^
	ldid -S $@
	chown root:wheel $@
	chmod 4777 $@

$(LIBRARY): $(LIBRARY_OBJECTS)
	$(LD) $(LDFLAGS) -dynamiclib -install_name /usr/lib/$(LIBRARY) -o $@ $^
	cp $@ /usr/lib
	cp $@ /User/sysroot/usr/lib

%.o: %.m
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -rf $(DAEMON_OBJECTS) $(DAEMON) $(LIBRARY_OBJECTS) $(LIBRARY)
