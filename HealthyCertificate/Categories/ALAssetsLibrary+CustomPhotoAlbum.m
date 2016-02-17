//
//  ALAssetsLibrary category to handle a custom photo album
//
//  Created by Marin Todorov on 10/26/11.
//  Copyright (c) 2011 Marin Todorov. All rights reserved.
//

#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@implementation ALAssetsLibrary(CustomPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock
{
    //write the image data to the assets library (camera roll)
    [self writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation 
                        completionBlock:^(NSURL* assetURL, NSError* error) {
                              
                          //error handling
                          if (error!=nil) {
                              completionBlock(nil, error);
                              return;
                          }

                          //add the asset to the custom photo album
                          [self addAssetURL: assetURL 
                                    toAlbum:albumName 
                        withCompletionBlock:^(NSError *error){
                                completionBlock(assetURL, error);
                          }];
                          
                      }];
}

-(void)saveVideo:(NSURL *)url toAlbum:(NSString*)albumName withCompletionBlock:(ALAssetsLibraryWriteVideoCompletionBlock)completionBlock
{
    [self writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
        //error handling
        if (error!=nil  || !assetURL) {
            completionBlock(assetURL, error);
            return;
        }
        
        //add the asset to the custom photo album
        [self addAssetURL: assetURL
                  toAlbum:albumName
      withCompletionBlock:^(NSError *error){
          completionBlock(assetURL, error);
        }];
    }];
}

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveCompletion)completionBlock
{
    __block BOOL albumWasFound = NO;
    
    //search all photo albums in the library
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum 
                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {

                            //compare the names of the albums
                            if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                                
                                //target album is found
                                albumWasFound = YES;
                                
                                //get a hold of the photo's asset instance
                                [self assetForURL: assetURL 
                                      resultBlock:^(ALAsset *asset) {
                                                  
                                          //add photo to the target album
                                          [group addAsset: asset];
                                          
                                          //run the completion block
                                          completionBlock(nil);
                                          
                                      } failureBlock: completionBlock];

                                //album was found, bail out of the method
                                return;
                            }
                            
                            if (group==nil && albumWasFound==NO) {
                                //photo albums are over, target album does not exist, thus create it

                                __weak ALAssetsLibrary* weakSelf = self;

                                // -----------   PHPhotoLibrary_class will only be non-nil on iOS 8.x.x  -----------
                                Class PHPhotoLibrary_class = NSClassFromString(@"PHPhotoLibrary");

                                if (PHPhotoLibrary_class)
                                {
                                    // dynamic runtime code for code chunk listed above
                                    id sharedPhotoLibrary = [PHPhotoLibrary_class performSelector:NSSelectorFromString(@"sharedPhotoLibrary")];

                                    SEL performChanges = NSSelectorFromString(@"performChanges:completionHandler:");

                                    NSMethodSignature *methodSig = [sharedPhotoLibrary methodSignatureForSelector:performChanges];

                                    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:methodSig];
                                    [inv setTarget:sharedPhotoLibrary];
                                    [inv setSelector:performChanges];

                                    void(^firstBlock)() = ^void() {
                                        Class PHAssetCollectionChangeRequest_class = NSClassFromString(@"PHAssetCollectionChangeRequest");
                                        SEL creationRequestForAssetCollectionWithTitle = NSSelectorFromString(@"creationRequestForAssetCollectionWithTitle:");
                                        [PHAssetCollectionChangeRequest_class performSelector:creationRequestForAssetCollectionWithTitle withObject:albumName];
                                    };

                                    void (^secondBlock)(BOOL success, NSError *error) = ^void(BOOL success, NSError *error) {
                                        if (success)
                                        {
                                            [weakSelf enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {

                                                //compare the names of the albums
                                                if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame)
                                                {
                                                    //target album is found
                                                    albumWasFound = YES;

                                                    //get a hold of the photo's asset instance
                                                    [self assetForURL: assetURL
                                                          resultBlock:^(ALAsset *asset) {

                                                              //add photo to the target album
                                                              [group addAsset: asset];

                                                              //run the completion block
                                                              completionBlock(nil);

                                                          } failureBlock: completionBlock];

                                                    //album was found, bail out of the method
                                                    return;
                                                }

                                            } failureBlock:completionBlock];
                                        }

                                        if (error)
                                        {
                                            completionBlock(nil);
                                        }
                                    };

                                    // Set the success and failure blocks.
                                    [inv setArgument:&firstBlock atIndex:2];
                                    [inv setArgument:&secondBlock atIndex:3];

                                    [inv invoke];
                                }
                                else
                                {
                                    //create new assets album
                                    [self addAssetsGroupAlbumWithName:albumName
                                                          resultBlock:^(ALAssetsGroup *group) {

                                                              //get the photo's instance
                                                              [weakSelf assetForURL: assetURL
                                                                        resultBlock:^(ALAsset *asset) {

                                                                            //add photo to the newly created album
                                                                            [group addAsset: asset];

                                                                            //call the completion block
                                                                            completionBlock(nil);

                                                                        } failureBlock: completionBlock];

                                                          } failureBlock: completionBlock];
                                }

                                //should be the last iteration anyway, but just in case
                                return;
                            }
                            
                        } failureBlock: completionBlock];
    
}

-(void)videoAssetsFromAlbumn:(NSString *)albumName withCompletionBlock:(GetAssetsCompletion)completionBlock failedBlock:(GetAssetsFailed)failedBlock
{
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //compare the names of the albums
        if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
            
            //target album is found
            *stop = YES;
            
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            __block NSMutableArray *array = [NSMutableArray array];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if ( result )
                {
                    [array addObject:result];
                }
                
                *stop = ( !result || index == ([group numberOfAssets] - 1));
                
                if ( *stop )
                {
                    completionBlock(array);
                }
            }];
            
        }
        else if ( !*stop && !group )
        {
            completionBlock(nil);
        }
    }failureBlock:failedBlock];
}

-(void)enumerateAssetsFromAlbum:(NSString *)albumName withCompletionBlock:(GetAssetsCompletion)completionBlock failedBlock:(GetAssetsFailed)failedBlock
{
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //compare the names of the albums
        if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {

            //target album is found
            *stop = YES;

            [group setAssetsFilter:[ALAssetsFilter allAssets]];
            __block NSMutableArray *array = [NSMutableArray array];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if ( result )
                {
                    [array addObject:result];
                }

                *stop = ( !result || index == ([group numberOfAssets] - 1));

                if ( *stop )
                {
                    completionBlock(array);
                }
            }];

        }
        else if ( !*stop && !group )
        {
            completionBlock(nil);
        }
    }failureBlock:failedBlock];
}

@end
