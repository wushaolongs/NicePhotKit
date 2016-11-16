//
//  AlbumCell.m
//  Photo album Demo
//
//  Created by Gamefire on 16/10/19.
//  Copyright © 2016年 Gamefire. All rights reserved.
//

#import "AlbumCell.h"

@implementation AlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self Setup];
        
    }
    return self;
}

- (void)Setup{

    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 62.5, 62.5)];
    [_headImageView setBackgroundColor:[UIColor redColor]];
    [self addSubview:_headImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0 - 75, 10, 150, 30)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_titleLabel];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
