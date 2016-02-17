//
//  ALAssetsLibrary category to handle a custom photo album
//
//  Created by Marin Todorov on 10/26/11.
//  Copyright (c) 2011 Marin Todorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>

typedef void(^SaveCompletion)(NSError* error);
typedef void(^GetAssetsCompletion)(NSArray *result);
typedef void(^GetAssetsFailed)(NSError *error);

@interface ALAssetsLibrary(CustomPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock;
-(void)saveVideo:(NSURL *)url toAlbum:(NSString*)albumName withCompletionBlock:(ALAssetsLibraryWriteVideoCompletionBlock)completionBlock;
-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveCompletion)completionBlock;
-(void)videoAssetsFromAlbumn:(NSString *)albumName withCompletionBlock:(GetAssetsCompletion)completionBlock failedBlock:(GetAssetsFailed)failedBlock;
-(void)enumerateAssetsFromAlbum:(NSString *)albumName withCompletionBlock:(GetAssetsCompletion)completionBlock failedBlock:(GetAssetsFailed)failedBlock;

@end
