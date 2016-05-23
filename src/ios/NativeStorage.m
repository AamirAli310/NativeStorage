//
//  NativeStorage.m
//  myApp
//
//  Created by Aamir Ali on 2/16/16.
//
//

#import "NativeStorage.h"

@implementation NativeStorage


- (void)getFileContentRequest:(CDVInvokedUrlCommand*)command{
    
    CDVPluginResult* pluginResult = nil;
    
    @try {
        
        NSString* filename = [command.arguments objectAtIndex:0];
        
//        NSArray *jsonObj = (NSArray *)[self getFileContent:filename];
        NSData *dataObj = (NSData *)[self getFileContentData:filename];
        
        NSString *dataStr = [[NSString alloc] initWithData:dataObj encoding:NSUTF8StringEncoding];
        //NSString *dataStr = (NSString *)[dataObj base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
        //NSLog(@"Data String: %@",dataStr);
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:dataStr];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    @catch (NSException *exception) {
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }
}

- (NSArray *)getFileContent:(NSString *)filename {
    
    NSArray *jsonObj = NULL;
    
    if (filename != nil && [filename length] > 0) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[[filename componentsSeparatedByString:@"."] objectAtIndex:0] ofType:[[filename componentsSeparatedByString:@"."] objectAtIndex:1] inDirectory:@"www"];
        
        NSError *err = nil;
        
//        NSLog(@"FileData : %@", [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err]);
        
        NSError *deserializingError;
        
        NSURL *localFileURL = [NSURL fileURLWithPath:filePath];
        
        NSData *contentOfLocalFile = [NSData dataWithContentsOfURL:localFileURL];
        
        id fileInDic = [NSJSONSerialization JSONObjectWithData:contentOfLocalFile
                                                       options:kNilOptions
                                                         error:&deserializingError];
        
        jsonObj = [NSArray arrayWithObject:fileInDic];
    }
    return  jsonObj;
}

- (NSData *)getFileContentData:(NSString *)filename {
    
    NSData *contentOfLocalFile = NULL;
    
    if (filename != nil && [filename length] > 0) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[[filename componentsSeparatedByString:@"."] objectAtIndex:0] ofType:[[filename componentsSeparatedByString:@"."] objectAtIndex:1] inDirectory:@"www"];
        
        NSURL *localFileURL = [NSURL fileURLWithPath:filePath];
        
        contentOfLocalFile = [NSData dataWithContentsOfURL:localFileURL];
        
    }
    return  contentOfLocalFile;
}


- (void)setFileContentRequest:(CDVInvokedUrlCommand*)command{
    
    CDVPluginResult* pluginResult = nil;
    
    @try {
     
        BOOL status = [self saveFile:[command.arguments objectAtIndex:0] fileContent:[command.arguments objectAtIndex:1]];
        
        if(status)
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:status];
        else
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception Occured: %@", [exception description]);
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
        
    }
}

- (BOOL)saveFile:(NSString *)filename fileContent:(NSString *)fileContent{
    
    BOOL status = NO;

    if (filename != nil && [filename length] > 0) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[[filename componentsSeparatedByString:@"."] objectAtIndex:0] ofType:[[filename componentsSeparatedByString:@"."] objectAtIndex:1] inDirectory:@"www"];
        
        NSData *fileData =        (NSData *)[fileContent dataUsingEncoding:NSUTF8StringEncoding];
//        NSData *fileData = [NSJSONSerialization dataWithJSONObject:fileContent
//                                                           options:0
//                                                             error:nil];

        status  = [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileData attributes:nil];
        
//        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) { //JUST UPDATE
//            
//            status  = [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileData attributes:nil];
//            
//        } else { //CREATE NEW AND INSERT DATA
//            
//            status  = [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileData attributes:nil];
//        }
    }

    return  status;
}

@end
