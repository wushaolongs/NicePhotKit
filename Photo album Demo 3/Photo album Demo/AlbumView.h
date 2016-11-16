//
//  AlbumView.h
//  Photo album Demo
//
//  Created by Gamefire on 16/10/20.
//  Copyright © 2016年 Gamefire. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlbumViewDelegate <NSObject>

- (void)PushWithTitle:(NSString *)titleNameString Index:(NSInteger)index;

@end

@interface AlbumView : UIView

@property (nonatomic,weak)id<AlbumViewDelegate>delegate;


@end
