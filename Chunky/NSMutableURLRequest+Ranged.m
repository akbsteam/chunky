#import "NSMutableURLRequest+Ranged.h"

@implementation NSMutableURLRequest (Ranged)

+ (instancetype)requestWithURL:(NSURL *)url
                   forIdentity:(NSUInteger)identity
                     chunkSize:(NSUInteger)chunkSize
{
    NSUInteger fromRange = (identity * chunkSize);
    NSUInteger toRange = ((identity + 1) * chunkSize) - 1;
    
    return [[NSMutableURLRequest alloc] initWithURL:url from:fromRange to:toRange];
}

- (instancetype)initWithURL:(NSURL *)url
                       from:(NSUInteger)fromRange
                         to:(NSUInteger)toRange
{
    self = [self initWithURL: url];
    if (self) {
        NSString *range = [NSString stringWithFormat:@"bytes=%lu-%lu", fromRange, toRange];
        [self setValue:range forHTTPHeaderField:@"Range"];
    }
    return self;
}

@end
