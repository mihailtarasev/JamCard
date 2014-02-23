//
//  FailCertificateDelegate.m
//  JamCard
//
//  Created by Admin on 12/30/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "FailCertificateDelegate.h"

@implementation FailCertificateDelegate
@synthesize dataDownloaded,downloaded;
-(id)init{
    self = [super init];
    if (self){
        dataDownloaded=nil;
        downloaded=[[NSCondition alloc] init];
    }
    return self;
}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:    (NSURLProtectionSpace *)protectionSpace {
    NSLog(@"canAuthenticateAgainstProtectionSpace:");
    return [protectionSpace.authenticationMethod         isEqualToString:NSURLAuthenticationMethodServerTrust];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:    (NSURLAuthenticationChallenge *)challenge {
    NSLog(@"didReceiveAuthenticationChallenge:");
    [challenge.sender useCredential:[NSURLCredential     credentialForTrust:challenge.protectionSpace.serverTrust]     forAuthenticationChallenge:challenge];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"Recived data!!!");
    dataDownloaded=data;
    [downloaded lock];
    [downloaded signal];
    [downloaded unlock];
}


-(NSData *)getData{
    NSLog(@"DATA PREPARED:%@",dataDownloaded);
    if (!dataDownloaded){
        [downloaded lock];
        [downloaded wait];
        [downloaded unlock];
    }
    NSLog(@"Data downloaded:%@",dataDownloaded);
    return dataDownloaded;
}
@end
