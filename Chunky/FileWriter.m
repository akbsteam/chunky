#import "FileWriter.h"
#import "Categories.m"

@implementation FileWriter

+ (void)recombine:(NSArray *)array path:(NSString *)path
{
    NSOutputStream *outputStream = [FileWriter openForWriting: path];
    
    for (NSString *fp in array) {
        NSData *data = [NSData dataWithContentsOfFile: fp];
        [outputStream write:[data bytes] maxLength:[data length]];
        
        [[NSFileManager defaultManager] removeFileIfExistsAtPath: fp];
    }
    
    [outputStream close];
    
    exit(EXIT_SUCCESS);
}

+ (NSOutputStream *)openForWriting:(NSString*)path
{
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath: path append: YES];
    [outputStream open];
    return outputStream;
}

@end
