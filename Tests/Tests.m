//
//  Tests.m
//  Tests
//
//  Created by Andy Bennett on 07/05/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Categories.h"
#import "FileWriter.h"
#import "NSURLSession+Ranged.h"
#import "NSMutableURLRequest+Ranged.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)test_createsCorrectHeader
{
    NSArray *expected = @[@"bytes=0-1048575",
                          @"bytes=1048576-2097151",
                          @"bytes=2097152-3145727",
                          @"bytes=3145728-4194303"];
    
    for (NSUInteger identity = 0; identity < 4; identity++) {
        NSUInteger chunkSize = 1024*1024;
        NSURL *url = [NSURL URLWithString:@"http://someurl.com"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               forIdentity:identity
                                                                 chunkSize:chunkSize];
        
        NSString *expectedHeader = expected[identity];
        XCTAssert([request.allHTTPHeaderFields[@"Range"] isEqualToString:expectedHeader]);
    }
}

@end
