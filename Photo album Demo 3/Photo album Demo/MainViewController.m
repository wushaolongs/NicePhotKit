//
//  MainViewController.m
//  Photo album Demo
//
//  Created by Gamefire on 16/10/14.
//  Copyright © 2016年 Gamefire. All rights reserved.
//

#import "MainViewController.h"
#import <Photos/Photos.h>
#import "PhotoCollectionViewCell.h"
#import "AlbumView.h"
@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PHPhotoLibraryChangeObserver,AlbumViewDelegate>
{
    //数据源
    NSMutableArray *dataArray;
    //相册图片集合
    PHFetchResult *assetsFetchResults;
    //item的宽
    CGFloat width;
    //顶部滑动的View
    AlbumView *groupView;
    //顶部的Button
    UIButton *button;
    
    PHFetchOptions *options;
    PHImageRequestOptions *optionsr;
    
}
@property (nonatomic,strong)UICollectionView *mainCollectionView;

@end



@implementation MainViewController

- (void)dealloc{
    
    //移除相册的监听
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //初始化
    dataArray = [NSMutableArray array];
    //默认item宽高
    width = ([UIScreen mainScreen].bounds.size.width - 4.0)/3.0;
    
    

    
    //判断是否权限
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                //TODO
                NSLog(@"获得权限");
            }
        }];
    }
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    //默认值为0
    _index = 0;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setItemSize:CGSizeMake(width, width)];
    [flowlayout setMinimumInteritemSpacing:2.0];
    [flowlayout setMinimumLineSpacing:2.0];
    
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 40) collectionViewLayout:flowlayout];
    [_mainCollectionView setDelegate:self];
    [_mainCollectionView setDataSource:self];
    [_mainCollectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_mainCollectionView];
    [_mainCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"jjj"];
    
    
    //滑动的tableView
    groupView = [[AlbumView alloc] initWithFrame:CGRectMake(0, - [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 40)];
    [groupView setDelegate:self];
    [self.view addSubview:groupView];
    
    //顶部的View
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    
    //顶部的title button
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0 - 60, 0, 120, 40)];
    [button setTitle:@"相机胶卷" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:button];
    
    //获取资源集合
    options = [[PHFetchOptions alloc] init];
    optionsr = [[PHImageRequestOptions alloc] init];
    
    [self AlumeupdateWithIndex:_index];
    
    //相册的监听方法
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    //默认隐藏系统的状态栏
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];


}


//读取
- (void)AlumeupdateWithIndex:(NSInteger)index{
    
    [dataArray removeAllObjects];
    //设置是否按时间排序
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    assetsFetchResults = nil;
    // 同步获得图片, 只会返回1张图片
    optionsr.synchronous = YES;
    optionsr.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    if (index == 0) {
        
        assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
        
        
    }else{
        
        PHAssetCollection *collection = [[self getAllPhoto] objectAtIndex:index - 1];
        assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        
    }
    
    //便利相册中的图片数据
    for (PHAsset *asset in assetsFetchResults) {
        //取出图片
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(width, width) contentMode:PHImageContentModeAspectFill options:optionsr resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            //判断asset是否为图片，1为图片默认的参数
            if (asset.mediaType == 1) {
                
                [dataArray addObject:result];
                
            }
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(width, width);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return dataArray.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"jjj" forIndexPath:indexPath];
    [cell.headImageView setImage:[dataArray objectAtIndex:indexPath.row]];
    
    return cell;

}



- (void)photoLibraryDidChange:(PHChange *)changeInstance{

    dispatch_async(dispatch_get_main_queue(), ^{
        //添加相册新的数据
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:assetsFetchResults];
        //判断相册是否更新
        if (collectionChanges) {
            
            [dataArray removeAllObjects];
            
            [self AlumeupdateWithIndex:_index];

            [_mainCollectionView reloadData];
            
        }
    });
    
}

- (void)PushWithTitle:(NSString *)titleNameString Index:(NSInteger)index{
    
    [button setTitle:titleNameString forState:UIControlStateNormal];
    [self AlumeupdateWithIndex:index];
    
    _index = index;
    
    [_mainCollectionView reloadData];
    
}

//顶部按钮点击事件
- (void)push:(UIButton *)sender{
    
    UIButton *topButton = sender;
    
    if (topButton.selected == NO) {
        //过度动画
        [UIView animateWithDuration:0.3f animations:^{
            [groupView setFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 40)];
        }];
        
    }else{
        //过度动画
        [UIView animateWithDuration:0.3f animations:^{
            [groupView setFrame:CGRectMake(0, -[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        }];
    }
    
    topButton.selected = !sender.selected;
}

- (NSMutableArray *)getAllPhoto{
    
    NSMutableArray *albumArray = [NSMutableArray array];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    for (int i = 0; i < smartAlbums.count; i++) {
        PHAssetCollection *otherCollection = [smartAlbums objectAtIndex:i];
        if (otherCollection.estimatedAssetCount == 0) {
            NSLog(@"不进行任何操作");
        }else{
            NSLog(@"添加相册");
            [albumArray addObject:otherCollection];
        }
    }
    return albumArray;
}


@end
