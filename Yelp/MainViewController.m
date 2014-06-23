//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "CustomCell.h"
#import "UIImageView+AFNetworking.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic) NSArray* resturants;
@property(strong, nonatomic) UISearchBar* searchBar;
@property(strong, nonatomic) NSDictionary* parameters;
@property(strong, nonatomic) NSString* keyword;

@property (assign, nonatomic) BOOL hasDeal;

@property (strong, nonatomic) NSArray* categoryNameArray;
@end

BOOL categoryCheckArray[10];


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        for (int i = 0;i < 10; i++)
            categoryCheckArray[i] = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.hasDeal = NO;
    self.keyword = @"Chinese";
    
    UINavigationBar* naviBar = [[self navigationController] navigationBar];
    [naviBar setBackgroundColor:[UIColor redColor]];
    
    self.searchBar= [[UISearchBar alloc] init];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    self.searchBar.text = self.keyword;
    
    UIButton* filterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.categoryNameArray = [NSArray arrayWithObjects: @"newamerican", @"brazilian", @"chinese", @"french", @"german", @"hawaiian", @"japanese", @"korean", @"mexican", @"vietnamese", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self searchWithKeyword];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib: [UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"MyCustomCell"];
    
    CustomCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyCustomCell"];
    
    NSDictionary* restaurant = self.resturants[indexPath.row];
    
    cell.testLabel.text = restaurant[@"name"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:restaurant[@"image_url"] ]];
    if ([restaurant[@"location"][@"address"] count]== 0)
        // sometimes address is empty
        cell.addressLabel.text = restaurant[@"location"][@"display_address"][0];
    else cell.addressLabel.text = restaurant[@"location"][@"address"][0];
    [cell.ratingImageView setImageWithURL:[NSURL URLWithString:restaurant[@"rating_img_url"]]];
    
    NSMutableString* category = [[NSMutableString alloc] init];
    NSArray* categoryArray = restaurant[@"categories"];
    for (int i= 0; i< [categoryArray count]; i++){
        [category appendString:categoryArray[i][0]];
        if (i<[categoryArray count]-1)
            [category appendString:@", "];
    }
    cell.categoryLabel.text = category;
    
    cell.distanceLabel.text = @"";
    cell.expenseLabel.text = @"";
    
    cell.reviewCountLabel.text = [NSString stringWithFormat:@"%@ Reviews", restaurant[@"review_count"]] ;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (int)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"resturants #: %d", self.resturants.count);

    if (self.resturants != nil)
        return self.resturants.count;
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
    NSLog(@"did end editing!");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    self.keyword = [searchBar text];
    [self searchWithKeyword];
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];

}

-(void) updateFilters:(NSDictionary *)para inFiltersControllers:(FiltersViewController *)controlle{
    self.parameters = para;
}

- (void)setDeal:(BOOL)hasDeal inFiltersController:(FiltersViewController *)controller{
    self.hasDeal = hasDeal;
}

- (void)setCategory:(NSInteger)categoryIndex check:(BOOL)isChecked inFiltersController:(FiltersViewController *)controller
{
    categoryCheckArray[categoryIndex] = isChecked;
}

- (void) searchWithKeyword{
    
    //- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term Deal:(BOOL)hasDeal CategoryList:(NSArray*)categoryList CategoryCheckArray:(BOOL[])categoryChechArray
    [self.client searchWithTerm:self.keyword Deal:self.hasDeal CategoryList:self.categoryNameArray CategoryCheckArray:categoryCheckArray success:^(AFHTTPRequestOperation *operation, id response) {
        
        self.resturants = response[@"businesses"];
        NSLog(@"resturants: %@", self.resturants);
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    /*
    [self.client searchWithTerm:self.keyword Deal:self.hasDeal CategoryList:self.categoryNameArray CategoryChechArray:categoryCheckArray success:^(AFHTTPRequestOperation *operation, id response) {
        
        self.resturants = response[@"businesses"];
        NSLog(@"resturants: %@", self.resturants);
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
     */
}

-(void) filterButtonTouchUpInside{
    NSLog(@"button touch up inside");
    
    FiltersViewController* fvc = [[FiltersViewController alloc] init];
    fvc.delegate = self;
    [self.navigationController pushViewController:fvc animated:YES];
}
@end
