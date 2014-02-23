//
//  FailCertificateDelegate.h
//  JamCard
//
//  Created by Admin on 12/30/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FailCertificateDelegate : NSObject <NSURLConnectionDataDelegate>
@property(atomic,retain)NSCondition *downloaded;
@property(nonatomic,retain)NSData *dataDownloaded;
-(NSData *)getData;
@end
