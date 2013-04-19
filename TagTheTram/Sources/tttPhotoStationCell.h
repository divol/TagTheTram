//
//  tttPhotoStationCell.h
//  TagTheTram
//
//  Created by divol on 14/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tttPhotoStationCell : UITableViewCell
    @property (nonatomic, strong) IBOutlet UIImageView* imageStation;
    @property (nonatomic, strong) IBOutlet UILabel    * titleStation;
    @property (nonatomic, strong) IBOutlet UILabel    * datetimeStation;


@end
