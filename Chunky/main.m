#import <Foundation/Foundation.h>
#import "NSURLSession+Ranged.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
        
        NSString *urlString = [args stringForKey:@"urlString"];
        NSString *filePath = [args stringForKey:@"output"];
        
        NSInteger chunkSize = [args integerForKey:@"chunkSize"];
        if (chunkSize == 0) {
            chunkSize = 1024*1024;
        }
        
        NSInteger nChunks = [args integerForKey:@"nChunks"];
        if (nChunks == 0) {
            nChunks = 4;
        }
        
        if (!filePath) {
            NSString *currentpath = [fileManager currentDirectoryPath];
            filePath = [currentpath stringByAppendingPathComponent:@"data.dat"];
        }
        
        if (!urlString) {
            NSLog(@"\n\nUsage:\n\n./Chunky /\n  -urlString <URL String> /\n  -output <File Path> (optional, default ./data.dat) /\n  -chunkSize <Size of chunks> (optional, default 1048576) /\n  -nChunks <Number of chunks> (optional, default 4)\n\n");
            exit(EXIT_SUCCESS);
        }
        
        NSURL *url = [[NSURL alloc] initWithString: urlString];
        if (!url) {
            NSLog(@"Invalid url");
            exit(EXIT_SUCCESS);
        }
        
        if ([fileManager fileExistsAtPath: filePath]) {
            NSLog(@"Will not overwrite existing file");
            exit(EXIT_SUCCESS);
        }
        
        NSURLSession *session = [NSURLSession sharedSession];
        [session runTasksForURL:url filePath:filePath chunkSize:chunkSize nChunks:nChunks];
        
        dispatch_main();
    }
    
    return 0;
}
