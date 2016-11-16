//
//  AlbumView.m
//  Photo album Demo
//
//  Created by Gamefire on 16/10/20.
//  Copyright © 2016年 Gamefire. All rights reserved.
//

#import "AlbumView.h"
#import "MainViewController.h"
#import <Photos/Photos.h>
#import "AlbumCell.h"

@interface AlbumView()<UITableViewDelegate,UITableViewDataSource>{

    NSMutableArray *titleArray;
    NSMutableArray *imageArray;
    NSMutableArray *numberArray;
}
@end

@implementation AlbumView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        [self Setup];
        
    }
    return self;
}

- (void)Setup{
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setRowHeight:80.0];
    [self addSubview:tableView];
    
    //创建名字的数组
    titleArray = [NSMutableArray array];
    [titleArray removeAllObjects];
    //创建图片数组
    imageArray = [NSMutableArray array];
    [imageArray removeAllObjects];
    //数量的数组
    numberArray = [NSMutableArray array];
    [imageArray removeAllObjects];
    
    //列出所有智能相册
    NSMutableArray *smartAlbumsArray = [self getAllPhoto];
    
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    //设置按时间排序
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHImageRequestOptions *optionsr = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    optionsr.synchronous = YES;
    optionsr.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    //循环添加相册所有图片
    for (int i = 0; i < smartAlbumsArray.count + 1; i++) {
        //默认数据为nil
        PHFetchResult *assetsFetchResult = nil;
        //默认添加相机胶卷
        if (i == 0) {
            //
            [titleArray addObject:@"相机胶卷"];
            assetsFetchResult = [PHAsset fetchAssetsWithOptions:nil];
            
        }else{
            
            [titleArray addObject:[[smartAlbumsArray objectAtIndex:i - 1] title]];
            //获取相册中的某个相册的图片集合
            PHAssetCollection *collection = [smartAlbumsArray objectAtIndex:i - 1];
            // 获得某个相簿中的所有PHAsset对象
            assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            
        }
        
        //选取相册的最后一张图片
        PHAsset *assset = [assetsFetchResult lastObject];
        [numberArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)assetsFetchResult.count]];
        
        //读取相片
        [[PHCachingImageManager defaultManager] requestImageForAsset:assset targetSize:CGSizeMake(62.5, 62.5) contentMode:PHImageContentModeAspectFill options:optionsr resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            //判断当前是否为image,1是相片的类型
            if (assset.mediaType == 1) {
                
                [imageArray addObject:result];
                
            }
        }];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return imageArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"identifier";
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[AlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    [cell.titleLabel setText:[NSString stringWithFormat:@"%@ ( %@ )",[titleArray objectAtIndex:indexPath.row] ,[numberArray objectAtIndex:indexPath.row]]];
    [cell.headImageView setImage:[imageArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [UIView animateWithDuration:.3f animations:^{
       
        [self setFrame:CGRectMake(0, - [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
    }];
    //delegatec传值
    if (_delegate && [_delegate respondsToSelector:@selector(PushWithTitle:Index:)]) {
        [_delegate PushWithTitle:[titleArray objectAtIndex:indexPath.row] Index:indexPath.row];
    }
    
    
}

//获取所有非空的相册
- (NSMutableArray *)getAllPhoto{
    
    NSMutableArray *albumArray = [NSMutableArray array];
    //列出所有自建相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    //循环所有自建相册相册
    for (int i = 0; i < smartAlbums.count; i++) {
        //依次添加相册
        PHAssetCollection *otherCollection = [smartAlbums objectAtIndex:i];
        //判断当前的相册内容是否为0
        if (otherCollection.estimatedAssetCount == 0) {
            NSLog(@"不进行任何操作");
        }else{
            NSLog(@"添加相册");
            [albumArray addObject:otherCollection];
        }
    }
    return albumArray;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
