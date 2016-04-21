//
//  ViewController.m
//  Acronyms
//
//  Created by Parvinder Singh on 4/20/16.
//  Copyright © 2016 Onward Technologies Inc. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "Acronyms.h"

@interface ViewController () <UISearchControllerDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation ViewController


#pragma mark - Private Methods

- (void)update:(NSArray *)items withMessage:(NSString *)message {
    [self.errorLabel setText:message];
    [self setItems:items];
    [[self tableView] reloadData];
    [[self tableView] setHidden:items.count == 0];
}


#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // Init UISearchController with the search results controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = nil;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    // Setting delegates and other stuff
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    //Reset the View
    [self update:@[] withMessage:nil];
    [self.searchController.searchBar setPlaceholder:@"Search Acronyms"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Acronyms *acronyms = [self.items objectAtIndex:indexPath.row];
    [cell.textLabel setText:[acronyms name]];
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Search Bar Delegate Method
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
     [self update:@[] withMessage:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self update:@[] withMessage:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    
    __weak ViewController *weakSelf = self;
    [[AcronymsManager sharedInstance] search:[searchBar text] withCompletionBlock:^(NSArray *items, NSString *message) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf update:items withMessage:message];
    }];
    
}

#pragma mark - Touch Method to hide keyboard 

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchController setActive:NO];
}

@end
