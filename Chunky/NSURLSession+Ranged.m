#import "NSURLSession+Ranged.h"
#import "Categories.h"
#import "FileWriter.h"

typedef void (^SessionCompletion)(BOOL success);
typedef void (^TaskCompletion)(NSData * _Nullable data,
                               NSURLResponse * _Nullable response,
                               NSError * _Nullable error);

#pragma mark - Helper Categories

@interface SessionTask: NSObject
@end

@implementation SessionTask

+ (TaskCompletion)completionWithFile:(NSString *)filePath
                   completionHandler:(SessionCompletion)completionHandler
{
    return ^(NSData * _Nullable data,
             NSURLResponse * _Nullable response,
             NSError * _Nullable error)
    {
        if (!data) {
            NSLog(@"failed");
            completionHandler(NO);
            return;
        }
        
        if ([data writeToFile:filePath atomically:YES]) {
            NSLog(@"done");
            completionHandler(YES);
            
        } else {
            NSLog(@"Could not write data to file");
            completionHandler(YES);
        }
    };
}

@end


@implementation NSMutableURLRequest (Ranged)

+ (instancetype)requestWithURL:(NSURL *)url
                   forIdentity:(NSUInteger)identity
                     chunkSize:(NSUInteger)chunkSize
{
    NSUInteger fromRange = (identity * chunkSize) + (identity > 0 ? 1 : 0);
    NSUInteger toRange = (identity + 1) * chunkSize;
    
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

@implementation NSMutableArray (Runner)

- (SessionCompletion)completionForIdentity:(NSUInteger)identity
                                  filePath:(NSString *)filePath
                                 chunkPath:(NSString *)chunkPath
{
    return ^(BOOL success) {
        self[identity] = chunkPath;
        
        if (![self hasNull]) {
            [FileWriter recombine:self path:filePath];
            exit(EXIT_SUCCESS);
        }
    };
}

@end

#pragma mark - Task Runner

@implementation NSURLSession (Ranged)

- (void)runTasksForURL:(NSURL *)url
              filePath:(NSString *)filePath
             chunkSize:(NSUInteger)chunkSize
               nChunks:(NSUInteger)nChunks
{
    NSMutableArray *array = [NSMutableArray arrayWithNulledCapacity: nChunks];
    
    for (NSUInteger identity = 0; identity < nChunks; identity++) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                                   forIdentity:identity
                                                                     chunkSize:chunkSize];
            
            NSString *chunkPath = [filePath chunkPathForIdentity: identity];
            
            SessionCompletion sessionCompletion = [array completionForIdentity:identity
                                                                      filePath:filePath
                                                                     chunkPath:chunkPath];
            
            TaskCompletion taskCompletion = [SessionTask completionWithFile:chunkPath
                                                          completionHandler:sessionCompletion];
            
            [[self dataTaskWithRequest: request completionHandler: taskCompletion] resume];
        });
    }
}

@end
