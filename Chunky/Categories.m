#import <Foundation/Foundation.h>

#pragma mark NSString category

@implementation NSString (Chunky)

- (NSString *)chunkPathForIdentity:(NSUInteger)identity
{
    return [self stringByAppendingString:[NSString stringWithFormat:@"-%lu", identity]];
}

@end

#pragma mark NSArray category

@implementation NSArray (Chunky)

- (BOOL)hasNull
{
    for (id obj in self) {
        if ([obj isEqual:[NSNull null]]) {
            return YES;
        }
    }
    
    return NO;
}

@end

#pragma mark NSMutableArray category

@implementation NSMutableArray (Chunky)

+ (instancetype)arrayWithNulledCapacity:(NSUInteger)numItems
{
    return [[NSMutableArray alloc] initWithNulledCapacity:numItems];
}

- (instancetype)initWithNulledCapacity:(NSUInteger)numItems
{
    self = [self initWithCapacity:numItems];
    if (self) {
        for (NSUInteger i = 0; i < numItems; i++) {
            [self addObject:[NSNull null]];
        }
    }
    return self;
}

@end

#pragma mark FileManager category

@implementation NSFileManager (Chunky)

- (void)removeFileIfExistsAtPath:(NSString *)path
{
    if ([self fileExistsAtPath: path]) {
        NSError *error;
        if (![self removeItemAtPath:path error: &error]) {
            NSLog(@"Delete file error: %@", error);
        }
    }
}

@end
