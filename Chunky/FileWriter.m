#import "FileWriter.h"
#import "Categories.h"

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
}

+ (NSOutputStream *)openForWriting:(NSString*)path
{
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath: path append: YES];
    [outputStream open];
    return outputStream;
}

@end
