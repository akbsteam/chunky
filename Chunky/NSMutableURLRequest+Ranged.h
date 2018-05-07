#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (Ranged)

+ (instancetype)requestWithURL:(NSURL *)url
                   forIdentity:(NSUInteger)identity
                     chunkSize:(NSUInteger)chunkSize;

- (instancetype)initWithURL:(NSURL *)url
                       from:(NSUInteger)fromRange
                         to:(NSUInteger)toRange;

@end
