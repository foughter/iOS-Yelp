//
//  FiltersViewController.m
//  Yelp
//
//  Created by Li Li on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"

#define CELL_HEIGHT 55

@interface FiltersViewController ()

@property (strong, nonatomic) NSMutableDictionary* para;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISwitch* dealSwitch;
@property (strong, nonatomic) NSArray* categoryNameArray;
@end

BOOL categoryCheckArray[10];
BOOL categorySectionCollapsed;

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {

        // Custom initialization
        for (int i = 0;i < 10; i++)
            categoryCheckArray[i] = NO;
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.para setObject:@"chinese" forKey:@"category"];
    self.dealSwitch = [[UISwitch alloc] init];
    [self.dealSwitch addTarget:self action:@selector(dealSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.categoryNameArray = [NSArray arrayWithObjects: @"American", @"Brazilian", @"Chinese", @"French", @"German", @"Hawaiian", @"Japanese", @"Korean", @"Mexican", @"Vietnamese", nil];
    
    categorySectionCollapsed = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 1;
    else if (section == 1)
        if (categorySectionCollapsed)
            return 4;
        return self.categoryNameArray.count + 1;
    
    return 0;
}

- (UITableViewCell *) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section == 0){
        UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 160, 30)];
        textLabel.text = @"Offering a Deal";
        [cell addSubview:textLabel];
        
        self.dealSwitch.frame = CGRectMake(cell.frame.size.width - 60, 10, 50, 30);
        [cell addSubview:self.dealSwitch];
//        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(dealSwitch);
//        [dealSwitch setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [cell addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"|-100-[dealSwitch]-100-|"
//                                                options:0 metrics:nil views:viewsDictionary]];
//        [cell addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[dealSwitch(30)]"
//                                                                      options:0 metrics:nil views:viewsDictionary]];
//        [cell addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:[dealSwitch(==50)]"
//                                                                      options:0 metrics:nil views:viewsDictionary]];
//        [cell addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dealSwitch(==30)]"
//                                                                      options:0 metrics:nil views:viewsDictionary]];
    }
    else if(indexPath.section ==1){

        UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 160, 30)];
        [cell addSubview:textLabel];
        
        if (categorySectionCollapsed && indexPath.row ==3)
        {
                textLabel.text = @"See More";
        }
        else if (!categorySectionCollapsed && indexPath.row == self.categoryNameArray.count)
        {
            textLabel.text = @"Collapse";
        }
        else {
            textLabel.text = self.categoryNameArray[indexPath.row];
        
            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 60, 10, 35, 35)];
            [imgView setImage:[UIImage imageNamed:@"Green-Checkmark"]];
            if (categoryCheckArray[indexPath.row])
                [cell addSubview:imgView];
        }
    }
    
    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Most Popular";
    else if (section == 1)
        return @"Category";
    return @"Sort";
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        if (categorySectionCollapsed && indexPath.row == 3)
        {
            categorySectionCollapsed = NO;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]  withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        else if(!categorySectionCollapsed && indexPath.row == self.categoryNameArray.count)
        {
            categorySectionCollapsed = YES;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            categoryCheckArray[indexPath.row] = !categoryCheckArray[indexPath.row];
            [self.delegate setCategory:indexPath.row check:categoryCheckArray[indexPath.row] inFiltersController:self];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

-(void) dealSwitchValueChanged:(id)sender{
    if ([sender isOn])
        [self.delegate setDeal:YES inFiltersController:self];
    else  [self.delegate setDeal:NO inFiltersController:self];
}


@end
