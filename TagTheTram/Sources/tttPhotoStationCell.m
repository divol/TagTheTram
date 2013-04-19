//
//  tttPhotoStationCell.m
//  TagTheTram
//
//  Created by divol on 14/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//
//#import <QuartzCore/QuartzCore.h>


#import "tttPhotoStationCell.h"

@implementation tttPhotoStationCell


@synthesize imageStation;
@synthesize titleStation;
@synthesize datetimeStation;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        CALayer * l = [self.imageStation layer];
//        [l setMasksToBounds:YES];
//        [l setCornerRadius:10.0];
//        l.borderWidth = 1.0;
//        l.borderColor = [[UIColor brownColor] CGColor];

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
