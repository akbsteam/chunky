#import <Foundation/Foundation.h>

@interface NSURLSession (Ranged)

- (void)runTasksForURL:(NSURL *)url
              filePath:(NSString *)filePath
             chunkSize:(NSUInteger)chunkSize
               nChunks:(NSUInteger)nChunks;

@end

