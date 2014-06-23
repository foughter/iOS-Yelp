//
//  FiltersViewController.h
//  Yelp
//
//  Created by Li Li on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>
- (void)updateFilters:(NSDictionary*) para inFiltersControllers:(FiltersViewController *)controller;
- (void)setDeal:(BOOL)hasDeal inFiltersController:(FiltersViewController *)controller;
- (void)setCategory:(NSInteger)categoryIndex check:(BOOL)isChecked inFiltersController:(FiltersViewController *)controller;
@end

@interface FiltersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (id)init;
@property (nonatomic, weak) id <FiltersViewControllerDelegate> delegate;
@end




