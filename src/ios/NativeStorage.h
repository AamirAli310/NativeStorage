//
//  NativeStorage.h
//  myApp
//
//  Created by Aamir Ali on 2/16/16.
//
//

#import <Cordova/CDV.h>

@interface NativeStorage : CDVPlugin

- (void)getFileContentRequest:(CDVInvokedUrlCommand*)command;
- (void)setFileContentRequest:(CDVInvokedUrlCommand*)command;

- (NSDictionary *)getFileContent:(NSString *)filename;
- (NSData *)getFileContentData:(NSString *)filename;

- (BOOL)saveFile:(NSString *)filename fileContent:(NSString *)fileContent;

@end
