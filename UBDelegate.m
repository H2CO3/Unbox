//
// UBDelegate.m
// Unbox
//
// Created by Árpád Goretity on 07/11/2011
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "UBDelegate.h"

@implementation UBDelegate

- (id) init {
	if ((self = [super init]))
	{
		center = [CPDistributedMessagingCenter centerNamed:@"org.h2co3.unbox"];
		[center registerForMessageName:@"org.h2co3.unbox.move" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"org.h2co3.unbox.copy" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"org.h2co3.unbox.symlink" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"org.h2co3.unbox.delete" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"org.h2co3.unbox.attributes" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"org.h2co3.unbox.dircontents" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"org.h2co3.unbox.chmod" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"org.h2co3.unbox.exists" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"org.h2co3.unbox.isdir" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"org.h2co3.unbox.mkdir" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center runServerOnCurrentThread];
		fileManager = [[NSFileManager alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[fileManager release];
	[super dealloc];
}

- (NSDictionary *) handleMessageNamed:(NSString *)name userInfo:(NSDictionary *)info
{
	NSString *sourceFile = [info objectForKey:@"UBSourceFile"];
	NSString *targetFile = [info objectForKey:@"UBTargetFile"];
	NSNumber *modeNumber = [info objectForKey:@"UBFileMode"];
	const char *source = [sourceFile UTF8String];
	const char *target = [targetFile UTF8String];
	mode_t mode = [modeNumber intValue];
	NSMutableDictionary *result = [NSMutableDictionary dictionary];

	if ([name isEqualToString:@"org.h2co3.unbox.move"]) {
		[fileManager moveItemAtPath:sourceFile toPath:targetFile error:NULL];
	} else if ([name isEqualToString:@"org.h2co3.unbox.copy"]) {
		[fileManager copyItemAtPath:sourceFile toPath:targetFile error:NULL];
	} else if ([name isEqualToString:@"org.h2co3.unbox.symlink"]) {
		symlink(source, target);
	} else if ([name isEqualToString:@"org.h2co3.unbox.delete"]) {
		[fileManager removeItemAtPath:targetFile error:NULL];
	} else if ([name isEqualToString:@"org.h2co3.unbox.attributes"]) {
		[result setDictionary:[fileManager attributesOfItemAtPath:targetFile error:NULL]];
	} else if ([name isEqualToString:@"org.h2co3.unbox.dircontents"]) {
		NSArray *contents = [fileManager contentsOfDirectoryAtPath:targetFile error:NULL];
		if (contents)
			[result setObject:contents forKey:@"UBDirContents"];

	} else if ([name isEqualToString:@"org.h2co3.unbox.chmod"]) {
		chmod(target, mode);
	} else if ([name isEqualToString:@"org.h2co3.unbox.exists"]) {
		BOOL exists = access(target, F_OK);
		NSNumber *num = [[NSNumber alloc] initWithBool:exists];
		[result setObject:num forKey:@"UBFileExists"];
		[num release];
	} else if ([name isEqualToString:@"org.h2co3.unbox.isdir"]) {
		struct stat buf;
		stat(target, &buf);
		BOOL isDir = S_ISDIR(buf.st_mode);
		NSNumber *num = [[NSNumber alloc] initWithBool:isDir];
		[result setObject:num forKey:@"UBIsDirectory"];
		[num release];
	} else if ([name isEqualToString:@"org.h2co3.unbox.mkdir"]) {
		[fileManager createDirectoryAtPath:targetFile withIntermediateDirectories:YES attributes:NULL error:NULL];
	}

	return result;
}

- (void)dummy
{
	// Keep the timer alive ;)
}

@end

