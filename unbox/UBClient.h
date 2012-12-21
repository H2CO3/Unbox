//
// UBClient.h
// Unbox
//
// Created by Árpád Goretity on 07/11/2011
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import <unistd.h>
#import <stdlib.h>
#import <sys/types.h>
#import <sys/stat.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

@interface UBClient: NSObject {
	CPDistributedMessagingCenter *center;
}

+ (id)sharedInstance;

- (NSString *)temporaryFile;
- (void)moveFile:(NSString *)file1 toFile:(NSString *)file2;
- (void)copyFile:(NSString *)file1 toFile:(NSString *)file2;
- (void)symlinkFile:(NSString *)file1 toFile:(NSString *)file2;
- (void)deleteFile:(NSString *)file;
- (NSDictionary *)attributesOfFile:(NSString *)file;
- (NSArray *)contentsOfDirectory:(NSString *)dir;
- (void)chmodFile:(NSString *)file mode:(mode_t)mode;
- (BOOL)fileExists:(NSString *)file;
- (BOOL)fileIsDirectory:(NSString *)file;
- (void)createDirectory:(NSString *)dir;

@end
