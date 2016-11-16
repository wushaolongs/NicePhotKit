//
//  PhotoCollectionViewCell.m
//  Photo album Demo
//
//  Created by Gamefire on 16/10/19.
//  Copyright © 2016年 Gamefire. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
@interface PhotoCollectionViewCell (){

   


}

@end
@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self Setup];
    }

    return self;
}

- (void)Setup{
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_headImageView setOpaque:NO];
    [self addSubview:_headImageView];
    
}



@end
