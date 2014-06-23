//
//  CustomCell.m
//  Yelp
//
//  Created by Li Li on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell ()
//@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.testLabel.text = @"abcd";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
