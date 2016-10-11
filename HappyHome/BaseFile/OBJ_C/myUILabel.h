//
//  myUILabel.h
//  HappyHome
//
//  Created by kaka on 16/10/7.
//  Copyright © 2016年 kaka. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface myUILabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
