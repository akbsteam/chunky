#pragma mark NSString category

@interface NSString (Chunky)

- (NSString *)chunkPathForIdentity:(NSUInteger)identity;

@end

#pragma mark NSArray category

@interface NSArray (Chunky)

- (BOOL)hasNull;

@end

#pragma mark NSMutableArray category

@interface NSMutableArray (Chunky)

+ (instancetype)arrayWithNulledCapacity:(NSUInteger)numItems;
- (instancetype)initWithNulledCapacity:(NSUInteger)numItems;

@end

#pragma mark FileManager category

@interface NSFileManager (Chunky)

- (void)removeFileIfExistsAtPath:(NSString *)path;

@end
