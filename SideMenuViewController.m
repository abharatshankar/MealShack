

//
//  SideMenuViewController.m
//  SportAlbums
//
//  Created by POSSIBILLION on 17/01/14.
//  Copyright (c) 2014 POSSIBILLION. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SWRevealViewController.h"
#import "SlideMenuTableViewCell.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "Utilities.h"
#import "ImageCache.h"
#import "UIImageView+WebCache.h"

#import "ServiceManager.h"
#import "RestaurantsViewController.h"
#import "OffersViewController.h"
#import "OrdersViewController.h"
#import "AddressesViewController.h"
#import "FavouritesViewController.h"
#import "ContactUsViewController.h"
#import "AboutUsViewController.h"
#import "EditProfileViewController.h"
#import "AppDelegate.h"
#import "ServiceManager.h"
#import "UIImageView+WebCache.h"
#import "WalletViewController.h"
#import "SingleTon.h"




 @interface SideMenuViewController ()<ServiceHandlerDelegate>
{
    UIAlertView *LogoutAlert;
    NSArray *arrImagesActivel;
    NSInteger rowSelectVal;
    AppDelegate *app;
    NSDictionary *requestDict,* ProfileDict;
    NSData * imageData ;
    NSString * imageString;
    BOOL * isRestaurants,*isOffers,*isOrders,*isAddress,*isFava,*isWallet,*isContactUs,*isAboutUs;
    int varNumber;
     SingleTon * singleToninstance;

}
@end

@implementation SideMenuViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
     singleToninstance = [SingleTon singleTonMethod];
    ProfileDict =[[NSMutableDictionary alloc]init];
    
    [super viewDidLoad];
    self.view.backgroundColor = BGNavigationCOLOR;
    self.navigationController.navigationBarHidden = YES;//Nani
    
    UIColor *color1 =  [Utilities getUIColorObjectFromHexString:@"#fd6565" alpha:1];
    
    Logout.backgroundColor = color1;
    
    NSString * getNameStr = [Utilities getName];
    NSString * getEmailStr = [Utilities getEmail];
    NSString * getProfileImgStr = [Utilities getimageurl];
    
    if (getNameStr.length>0 && getEmailStr.length>0)
    {
        lblname.text= [Utilities getName];
        lblemail.text = [Utilities getEmail];
    }
    else
    {
        lblname.text= @"None";
        lblemail.text = @"None";
    }
    
  

 
    
    arrMenu = [NSArray arrayWithObjects:@"Restaurants",@"Offers",@"Orders",@"Addresses",@"Favourites",@"Wallet",@"Contact Us",@"About Us",nil];
    arrImages = [NSArray arrayWithObjects:@"rgray.png",@"dgray.png",@"orders.png",@"address.png",@"fvgray.png",@"wallet_gray.png",@"contactus.png",@"aboutus.png",nil];
    
    
     arrImagesRed = [NSArray arrayWithObjects:@"restaurantsact.png",@"discountact.png",@"ordersact.png",@"addressact.png",@"heartyy.png",@"wallet_red.png",@"contactusact.png",@"aboutusact.png",nil];
    
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 64)];
    img.image = [UIImage imageNamed:@"RightAway"];
    img.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:img];
    
    
    
   
    
    tblMenu = [[UITableView alloc] initWithFrame:CGRectMake(0, profilepic.frame.origin.y+profilepic.frame.size.height+115, 500, [[Utilities sharedManager] screenRect].size.height-200) style:UITableViewStylePlain];
    
    tblMenu.delegate = self;
    tblMenu.dataSource = self;
    tblMenu.backgroundView = nil;
    //tblMenu.backgroundView = nil;
    
    
    tblMenu.scrollEnabled = NO;   //Nani
    
    UIImage *image = [UIImage imageNamed:@""];
    CGSize newSize =  CGSizeMake([[Utilities sharedManager] screenRect].size.height, [[Utilities sharedManager] screenRect].size.height);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    tblMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    // [tblMenu setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tblMenu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    

    //[tblMenu setSeparatorColor:[UIColor colorWithRed:21.0/241 green:128.0/241 blue:57.0/241 alpha:1.0]];
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:newImage]];
     tblMenu.backgroundColor = CLEARCOLOR;
   //tblMenu.backgroundColor = REDCOLOR;
    [self.view addSubview:tblMenu];
    self.view.backgroundColor = WHITECOLOR;
    
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@",[Utilities getimageurl]];
    if ([[[ImageCache sharedManager] imageCache] objectForKey:imageUrl])
    {
        ProfileImg.image =[[[ImageCache sharedManager] imageCache] objectForKey:imageUrl];
        
    }
    else
    {
        [ProfileImg sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                         placeholderImage:[UIImage imageNamed:@"bottom_gradient.png"]];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSString * name = [Utilities getName];
    NSString * email = [Utilities getEmail];
    NSString *profileimage = [Utilities getimageurl];
    
    if (name.length>0 && email.length>0)
    {
        lblname.text= [Utilities getName];
        lblemail.text = [Utilities getEmail];
    }
    else
    {
        lblname.text= @"None";
        lblemail.text = @"None";
    }
     [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)UserdetailsBtn_Clicked:(id)sender
{
    NSLog(@"Tapped");
    SWRevealViewController *revealController = self.revealViewController;
    // We know the frontViewController is a NavigationController
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
    
    NSLog(@"VC: %@", frontNavigationController.topViewController);
    UINavigationController *navigationController;
    
    // Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
    navigationController.navigationBar.barTintColor = YELLOW_COLOR_RBGVALUE;
    navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
    
    
    EditProfileViewController *frontViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    frontViewController = [storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    navigationController.navigationBar.barTintColor = YELLOW_COLOR_RBGVALUE;
    navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
    
    [navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName :GREEN_COLOR_RBGVALUE}];
    navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : GREEN_COLOR_RBGVALUE};
    [revealController setFrontViewController:navigationController animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
[self.revealViewController.frontViewController.view setUserInteractionEnabled:YES  ];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrMenu count];
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SlideMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SlideMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = CLEARCOLOR;
    //    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:MENUBG]]];
    cell.textLabel.text = [arrMenu objectAtIndex:indexPath.row];
    cell.textLabel.textColor = GrayColor; //Nani
    
    cell.layer.borderWidth=0.3f;
    cell.layer.borderColor=[UIColor grayColor].CGColor;
    

    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        cell.textLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18];
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:34];
    }
    
    
    //[tblMenu setSeparatorColor:BLACKCOLOR];
    cell.textLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16];
    
    cell.iconImage.tag = indexPath.row;
    cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
    
    cell.imgLine.image = [UIImage imageNamed:@"line.png"];
    
   
    UIView *bgColorView = [[UIView alloc] init];
    // [bgColorView setBackgroundColor:YELLOW_COLOR_RBGVALUE];
    [cell setSelectedBackgroundView:bgColorView];
    
    
    if (indexPath.row==0)
    {
        if (varNumber==0)
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
            isWallet = NO;
            isContactUs = NO;
            isAboutUs =NO;
            
        }
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    
    else if (indexPath.row==1)
    {
        if (varNumber==1) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
            isWallet = NO;
            isContactUs = NO;
            isAboutUs =NO;

            
    
        }
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    else if (indexPath.row ==2)
    {
        if (varNumber==2) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
            isWallet = NO;
            isContactUs = NO;
            isAboutUs =NO;

        }
    
        
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    else if (indexPath.row ==3)
    {
        if (varNumber==3) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
            isWallet = NO;
            isContactUs = NO;
            isAboutUs =NO;
            
        }
        
        
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }

    else if (indexPath.row ==4)
    {
        if (varNumber==4) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
             isWallet = NO;
            isContactUs = NO;
            isAboutUs =NO;
            
        }
        
        
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    else if (indexPath.row ==5)
    {
        if (varNumber==5) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
            isWallet = NO;
            isContactUs = NO;
            isAboutUs =NO;
            
        }
        
        
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }

    else if (indexPath.row ==6)
    {
        if (varNumber==6) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
            isWallet = NO;
            isContactUs = NO;
            isAboutUs =NO;
            
        }
        
        
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    else if (indexPath.row ==7)
    {
        if (varNumber==7) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
            isWallet = NO;
            isContactUs = NO;
            isAboutUs =NO;
            
        }
        
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 200, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];                                                                                                                                                                                                                                                     
    
    [view addSubview:titleLabel];
    return view;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (IS_STANDARD_IPHONE_6_PLUS || IS_ZOOMED_IPHONE_6_PLUS || IS_STANDARD_IPHONE_6 )
    {
        return 45.0f; //Nani
    }
    
    else
    {
        return 45.0f;   //Nani
        
    }
    
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"TestNotification"])
    {
        NSLog (@"Successfully received the test notification!");
        singleToninstance.isResetFilter = YES;
        [self tableView:tblMenu didSelectRowAtIndexPath:0];
    }
    
}
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *tableSelection = [tblMenu indexPathForSelectedRow];
    [tblMenu deselectRowAtIndexPath:tableSelection animated:YES];
  
    SlideMenuTableViewCell *cell =(SlideMenuTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIView *bgColorView = [[UIView alloc] init];
    [cell setSelectedBackgroundView:bgColorView];
    
    cell.iconImage.image = nil;
    cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [arrImages objectAtIndex:indexPath.row]]];
    
    
    rowSelectVal = indexPath.row;
    
    NSMutableArray *indexArr = [[NSMutableArray alloc] init];
    for (int i=0; i<[arrImagesActivel count]; i++) {
        NSIndexPath *indexPath11 = [NSIndexPath indexPathForRow:i inSection:0];
        if(indexPath11.row != indexPath.row){
            [indexArr addObject:indexPath11];
        }
        //Do something with your indexPath. Maybe you want to get your cell,
        // like this:
        //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    }
    
    [tableView reloadRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationNone];
    
    UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
    // bgView.backgroundColor = [MENUSELECTEDCOLOR colorWithAlphaComponent:1.0];
    cell.selectedBackgroundView = bgView;
    
    SWRevealViewController *revealController = self.revealViewController;
    
   
        if (indexPath.section == 0)
        {
           
            
            
            
            // We know the frontViewController is a NavigationController
            UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
            
            NSInteger row = indexPath.row;
            
            NSLog(@"VC: %@", frontNavigationController.topViewController);
            UINavigationController *navigationController;
            
            // Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
            navigationController.navigationBar.barTintColor = YELLOW_COLOR_RBGVALUE;
            navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
            
            if (row == 0)
            {
                varNumber  = 0;
                isRestaurants = YES;
                
                [USERDEFAULTS removeObjectForKey:@"strValue"];
                [USERDEFAULTS removeObjectForKey:@"strRating"];
                [USERDEFAULTS removeObjectForKey:@"strCusines"];
                singleToninstance.isResetFilter = YES;
                RestaurantsViewController *frontViewController;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                frontViewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantsViewController"];
                frontViewController.isFromSideMenu = YES;
                navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                navigationController.navigationBar.barTintColor = YELLOW_COLOR_RBGVALUE;
                navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
                
                [navigationController.navigationBar
                 setTitleTextAttributes:@{NSForegroundColorAttributeName :GREEN_COLOR_RBGVALUE}];
                navigationController.navigationBar.translucent = YES;
                self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : GREEN_COLOR_RBGVALUE};
                [revealController setFrontViewController:navigationController animated:YES];
               
                
                
                
            }
            else if (row == 1)
            {
                varNumber  = 1;
                isOffers = YES;
                OffersViewController *frontViewController;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                frontViewController = [storyboard instantiateViewControllerWithIdentifier:@"OffersViewController"];
                
                navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                navigationController.navigationBar.barTintColor = YELLOW_COLOR_RBGVALUE;
                navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
                
                [navigationController.navigationBar
                 setTitleTextAttributes:@{NSForegroundColorAttributeName :GREEN_COLOR_RBGVALUE}];
                navigationController.navigationBar.translucent = YES;
                self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : GREEN_COLOR_RBGVALUE};
                [revealController setFrontViewController:navigationController animated:YES];
                
                

                
            }
            else if (row == 2)
            {
                
                varNumber  = 2;
                isOrders = YES;

               OrdersViewController *frontViewController;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                frontViewController = [storyboard instantiateViewControllerWithIdentifier:@"OrdersViewController"];
                
                navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                navigationController.navigationBar.barTintColor = YELLOW_COLOR_RBGVALUE;
                navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
                
                [navigationController.navigationBar
                 setTitleTextAttributes:@{NSForegroundColorAttributeName :GREEN_COLOR_RBGVALUE}];
                navigationController.navigationBar.translucent = YES;
                self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : GREEN_COLOR_RBGVALUE};
                [revealController setFrontViewController:navigationController animated:YES];
                
                
                
            }
            else if (row == 3)
            {
                varNumber  = 3;
                isAddress = YES;

                AddressesViewController *frontViewController;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                frontViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddressesViewController"];
                
                navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                navigationController.navigationBar.barTintColor = YELLOW_COLOR_RBGVALUE;
                navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
                
                [navigationController.navigationBar
                 setTitleTextAttributes:@{NSForegroundColorAttributeName :GREEN_COLOR_RBGVALUE}];
                navigationController.navigationBar.translucent = YES;
                self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : GREEN_COLOR_RBGVALUE};
                [revealController setFrontViewController:navigationController animated:YES];
                
                
                
            }
            else if (row == 4)
            {
                
                varNumber  = 4;
                isFava = YES;

                FavouritesViewController *frontViewController;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                frontViewController = [storyboard instantiateViewControllerWithIdentifier:@"FavouritesViewController"];
                
                navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                navigationController.navigationBar.barTintColor = YELLOW_COLOR_RBGVALUE;
                navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
                
                [navigationController.navigationBar
                 setTitleTextAttributes:@{NSForegroundColorAttributeName :GREEN_COLOR_RBGVALUE}];
                navigationController.navigationBar.translucent = YES;
                self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : GREEN_COLOR_RBGVALUE};
                [revealController setFrontViewController:navigationController animated:YES];
                
                
                
                
            }
            
            
            else if (row == 5)
            {
                varNumber  = 5;
                isWallet = YES;
                
                WalletViewController *frontViewController;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                frontViewController = [storyboard instantiateViewControllerWithIdentifier:@"WalletViewController"];
                
                navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                navigationController.navigationBar.barTintColor = YELLOW_COLOR_RBGVALUE;
                navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
                
                [navigationController.navigationBar
                 setTitleTextAttributes:@{NSForegroundColorAttributeName :GREEN_COLOR_RBGVALUE}];
                navigationController.navigationBar.translucent = YES;
                self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : GREEN_COLOR_RBGVALUE};
                [revealController setFrontViewController:navigationController animated:YES];

            }
            else if (row == 6)
            {
                varNumber  = 6;
                isContactUs = YES;

                ContactUsViewController *frontViewController;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                frontViewController = [storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
                
                navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                navigationController.navigationBar.barTintColor = YELLOW_COLOR_RBGVALUE;
                navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
                
                [navigationController.navigationBar
                 setTitleTextAttributes:@{NSForegroundColorAttributeName :GREEN_COLOR_RBGVALUE}];
                navigationController.navigationBar.translucent = YES;
                self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : GREEN_COLOR_RBGVALUE};
                [revealController setFrontViewController:navigationController animated:YES];
                
                
               
                
            }
            else if (row == 7)
            {
                varNumber  = 7;
                isAboutUs = YES;

                AboutUsViewController *frontViewController;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                frontViewController = [storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
                
                navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                navigationController.navigationBar.barTintColor = YELLOW_COLOR_RBGVALUE;
                navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
                
                [navigationController.navigationBar
                 setTitleTextAttributes:@{NSForegroundColorAttributeName :GREEN_COLOR_RBGVALUE}];
                navigationController.navigationBar.translucent = YES;
                self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : GREEN_COLOR_RBGVALUE};
                [revealController setFrontViewController:navigationController animated:YES];
                
                
              
                
            }

    }
    
    
    if (indexPath.row==0)
    {
        if (isRestaurants)
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
            isWallet = NO;
            isContactUs = NO;
            isAboutUs = NO;
            [tblMenu reloadData];
        }
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    
    else if (indexPath.row==1)
    {
        if (isOffers) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
             isWallet = NO;
            isContactUs = NO;
            isAboutUs = NO;
            [tblMenu reloadData];
            
        }
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    
    else if (indexPath.row==2)
    {
        if (isOrders) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
             isWallet = NO;
            isContactUs = NO;
            isAboutUs = NO;
            [tblMenu reloadData];
            
        }
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    
    else if (indexPath.row==3)
    {
        if (isAddress) {
            
            [USERDEFAULTS setObject:@"goToAdress" forKey:@"goToAdress"];
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
            isWallet = NO;
            isContactUs = NO;
            isAboutUs = NO;
            [tblMenu reloadData];
            
        }
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    else if (indexPath.row==4)
    {
        if (isFava) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
             isWallet = NO;
            isContactUs = NO;
            isAboutUs = NO;
            [tblMenu reloadData];
            
        }
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    
    else if (indexPath.row==5)
    {
        if (isWallet) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
             isWallet = NO;
            isContactUs = NO;
            isAboutUs = NO;
            [tblMenu reloadData];
            
        }
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }


    else if (indexPath.row==6)
    {
        if (isContactUs) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
             isWallet = NO;
            isContactUs = NO;
            isAboutUs = NO;
            [tblMenu reloadData];
            
        }
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    else if (indexPath.row==7)
    {
        if (isAboutUs) {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImagesRed objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isRestaurants = NO;
            isOffers = NO;
            isOrders = NO;
            isAddress = NO;
            isFava = NO;
             isWallet = NO;
            isContactUs = NO;
            isAboutUs = NO;
            [tblMenu reloadData];
            
        }
        else
        {
            cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [arrImages objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }


}

- (IBAction)LogoutButton_Clicked:(id)sender
{

    
    LogoutAlert = [[UIAlertView alloc]initWithTitle:@"" message:@" Do you really want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [LogoutAlert show];

    
}

- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView ==LogoutAlert && buttonIndex == 1) {
        [USERDEFAULTS setBool:NO forKey:@"UserSignedIn"];
        
        [USERDEFAULTS removeObjectForKey:@"UserID"];
        [USERDEFAULTS synchronize];
        
        CGAffineTransform scaleTrans =
        CGAffineTransformMakeScale(2, 2);
        CGAffineTransform rotateTrans =
        CGAffineTransformMakeRotation(90 * M_PI / 180);
        self.view.transform = CGAffineTransformConcat(scaleTrans, rotateTrans);
        
        SWRevealViewController *revealController = [self revealViewController];
        [revealController tapGestureRecognizer];
        [[APPDELEGATE window] addGestureRecognizer:revealController.panGestureRecognizer];
        [[APPDELEGATE window] removeGestureRecognizer:revealController.panGestureRecognizer];
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
            
            [self resetDefaults];
            
            [APPDELEGATE loginChecking];
            
           
            
        }
        
    }
    
}


@end
