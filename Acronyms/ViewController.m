//
//  ViewController.m
//  Acronyms
//
//  Created by Parvinder Singh on 4/20/16.
//  Copyright © 2016 Onward Technologies Inc. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "AcronymsService.h"
#import "AcronymsModel.h"

@interface ViewController () <UISearchControllerDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation ViewController

#pragma mark - Private Methods
//Method for error message to show on label
- (void)update:(NSArray *)items withMessage:(NSString *)message {
    [self.errorLabel setText:message];
    [self setItems:items];
    [[self tableView] reloadData];
    [[self tableView] setHidden:items.count == 0];
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Inititiating UISearchController for acronyms values to search
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = nil;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    //Setting delegates and other properties of UISearchController
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    //Updating search view according to initial value of acronyms
    [self update:@[] withMessage:nil];
    [self.searchController.searchBar setPlaceholder:@"Search Acronyms"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
     AcronymsModel *acronymsObj = [self.items objectAtIndex:indexPath.row];
    [cell.textLabel setText:[acronymsObj name]];
    return cell;
}


#pragma mark - Search Bar Delegate Method
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
     [self update:@[] withMessage:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self update:@[] withMessage:nil];
}

//Calling service API for acronyms search result and processing of networking indicator
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    
    __weak ViewController *weakSelf = self;
    [[AcronymsService sharedInstance] search:[searchBar text] withCompletionBlock:^(NSArray *items, NSString *message) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf update:items withMessage:message];
    }];
}

#pragma mark - Touch Method to hide keyboard 
//Disabling search controller by tapping anywhere in view
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchController setActive:NO];
}

@end
