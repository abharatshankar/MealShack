//
//  TrackOrderViewController.m
//  MealShack
//
//  Created by Prasad on 07/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "TrackOrderViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import <MapKit/MapKit.h>
#import "RateUsViewController.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "SingleTon.h"


@interface TrackOrderViewController ()<ServiceHandlerDelegate,UIAlertViewDelegate,MKMapViewDelegate,UIGestureRecognizerDelegate,SWRevealViewControllerDelegate>
{
    NSDictionary *requestDict;
    BOOL isCall,isrefresh;
    BOOL isDeliveryExecutive;
    
    NSMutableDictionary *dictresponse ;
    NSMutableData *_responseData;
    NSDictionary * driverResponse;
    
    NSTimer* myTimer;

    NSString *str;
    SingleTon *singleTonInstance;

    BOOL * isEscape;
    NSString * imgString;
     NSData * imageData ;
    UIAlertController * alertController;
    SWRevealViewController *revealController;
    
}
@property (strong, nonatomic) MKPlacemark *destination;
@property (strong,nonatomic) MKPlacemark *source;
@end

@implementation TrackOrderViewController
@synthesize  MapView,strOrderID,stritemcount;


- (void)viewDidLoad
{
    [super viewDidLoad];
    singleTonInstance=[SingleTon singleTonMethod];

    driverResponse = [[NSMutableDictionary alloc]init];
    
    str = [NSString stringWithFormat:@"%@",strOrderID];
    isEscape = YES;
    
     scrollStatus.contentSize = CGSizeMake(self.view.frame.size.width-50, self.view.frame.size.height-self.MapView.frame.size.height+10);
    
    
    [Utilities addShadowtoView:lineview];

    

    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    UIButton *btnLib1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLib1 setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btnLib1.frame = CGRectMake(0, 0, 22, 22);
    btnLib1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLib1];
    [arrLeftBarItems addObject:barButtonItem2];
    [btnLib1 addTarget:self action:@selector(Back_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint * widthConstraint = [btnLib1.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint =[btnLib1.heightAnchor constraintEqualToConstant:30];
    [widthConstraint setActive:YES];
    [HeightConstraint setActive:YES];
    
    
    UIButton *btncall = [[UIButton alloc]initWithFrame:CGRectMake(116, 22, 23, 23)];
    [btncall setImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal ];
    UIBarButtonItem * itemreload = [[UIBarButtonItem alloc] initWithCustomView:btncall];
    [btncall addTarget:self action:@selector(callMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSLayoutConstraint * widthConstraint1 = [btncall.widthAnchor constraintEqualToConstant:20];
    NSLayoutConstraint * HeightConstraint1 =[btncall.heightAnchor constraintEqualToConstant:20];
    [widthConstraint1 setActive:YES];
    [HeightConstraint1 setActive:YES];
    
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:itemreload, nil];
    self.navigationItem.rightBarButtonItems = arrBtns;

    
    
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btntitle setTitle:@"Track Order" forState:UIControlStateNormal];
    btntitle.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:18];
    btntitle.frame = CGRectMake(0, 0, 250, 22);
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    
    
   revealController = [self revealViewController];
    
   
    
    
       [MapView setDelegate:self];
   
   // [self.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModePrimaryHidden];


    [self getDirections];
    
    
}


-(void)getDirections {
    
    NSString *strTOlat = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLat"]];
    NSLog(@"seltctedRestLat %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLat"]]);
    
    NSString *strTOlog = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLong"]];
    NSLog(@"seltctedRestLong %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLong"]]);
    
    
    
    double latdouble = [strTOlat doubleValue];
    NSLog(@"latdouble: %f", latdouble);
    double londouble = [strTOlog doubleValue];
    NSLog(@"londouble: %f", londouble);
    
    
    NSString * Strlat =[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_lat"]];
    NSLog(@"to_lat %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_lat"]]);
    
    NSString * Strlong =[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_long"]];
    NSLog(@"to_long %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_long"]]);
    
    
    double Latdouble = [Strlat doubleValue];
    NSLog(@"latdouble: %f", Latdouble);
    double Longdouble = [Strlong doubleValue];
    NSLog(@"londouble: %f", Longdouble);
    
    
    CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(latdouble, londouble);
    
    MKCoordinateRegion region;
    //Set Zoom level using Span
    MKCoordinateSpan span;
    region.center = sourceCoords;
    
    span.latitudeDelta = 0.015;
    span.longitudeDelta = 0.015;
    region.span=span;
    [MapView setRegion:region animated:TRUE];
    
    MKPlacemark *placemark  = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = sourceCoords;
    //annotation.title = @"San Francisco";
    [self.MapView addAnnotation:annotation];
    
    //[self.myMapView addAnnotation:placemark];
    
    _destination = placemark;
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:_destination];
    
    CLLocationCoordinate2D destCoords = CLLocationCoordinate2DMake(Latdouble, Longdouble);
    MKPlacemark *placemark1  = [[MKPlacemark alloc] initWithCoordinate:destCoords addressDictionary:nil];
    
    MKPointAnnotation *annotation1 = [[MKPointAnnotation alloc] init];
    annotation1.coordinate = destCoords;
  //  annotation1.title = @"San Francisco University";
    [self.MapView addAnnotation:annotation1];
    
    //[self.myMapView addAnnotation:placemark1];
    
    _source = placemark1;
    MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:_source];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = mapItem1;
    
    request.destination = mapItem;
    request.requestsAlternateRoutes = NO;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"ERROR");
             NSLog(@"%@",[error localizedDescription]);
         } else {
             [self showRoute:response];
         }
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
    [MapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}

#pragma mark - MKMapViewDelegate methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor colorWithRed:0.0/255.0 green:171.0/255.0 blue:253.0/255.0 alpha:1.0];
    renderer.lineWidth = 10.0;
    return  renderer;
}


-(void)viewWillAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    revealController.panGestureRecognizer.enabled = NO;
    
    [self refreshServiceCall];


     myTimer = [NSTimer scheduledTimerWithTimeInterval: 8.0 target: self
                                                      selector: @selector(callAfterSeconds) userInfo: nil repeats: YES];
    });

}
-(void)callAfterSeconds
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self refreshServiceCall];
    });
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    [myTimer invalidate];
    myTimer = nil;
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
//    [locationManager stopUpdatingLocation];
//    locationManager = nil;
    
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:204/255. green:45/255. blue:70/255. alpha:1.0];
    polylineView.lineWidth = 5;
    
    return polylineView;
}

-(void)Back_Click:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
  

     revealController.panGestureRecognizer.enabled = YES;
}


- (void)callMethodClicked:(id)sender
{
   
     alertController = [UIAlertController alertControllerWithTitle:@""message:@"You want to call Customer Care or Delivery Executive?"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Customer Care" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
        
        
        isCall = YES;
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            
            
            
            NSString *urlStr = [NSString stringWithFormat:@"%@orderdetails",BASEURL];
            requestDict = @{
                             @"order_id":str,
                            };
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ServiceManager *service = [ServiceManager sharedInstance];
                service.delegate = self;
                
                
                [service  handleRequestWithDelegates:urlStr info:requestDict];
                // [self uploadImagetoServer:urlStr];
                
            });
            
            
        }
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        }
                                                     }];
    
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Delivery Executive" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
        
        isDeliveryExecutive = YES;
        
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            
            
            NSString *urlStr = [NSString stringWithFormat:@"%@orderdetails",BASEURL];
            requestDict = @{
                             @"order_id":str,
                           
                            
                            };
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ServiceManager *service = [ServiceManager sharedInstance];
                service.delegate = self;
                
                
                [service  handleRequestWithDelegates:urlStr info:requestDict];
                // [self uploadImagetoServer:urlStr];
                
            });
            
            
        }
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        }
        

        }];
    
    
    [alertController addAction:noButton];
    [alertController addAction:yesButton];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    [self performSelector:@selector(removeAlert) withObject:nil afterDelay:3];
}

-(void)removeAlert
{
    [self dismissViewControllerAnimated:alertController completion:nil];
}

-(void)refreshServiceCall
{

    
       isrefresh = YES;
       if ([Utilities isInternetConnectionExists]) {
           dispatch_async(dispatch_get_main_queue(), ^{
               [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
           });
           
               if ( [ str isEqualToString:@"(null)"]) {
                   NSLog(@" - - - -  %@",singleTonInstance.orderIdStr);
                   str = [NSString stringWithFormat:@"%@",singleTonInstance.orderIdStr] ;
               }
               
           
           
           
           
           NSString *urlStr = [NSString stringWithFormat:@"%@orderdetails",BASEURL];
           requestDict = @{
                           @"order_id":str,
                           
                           };
           
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               ServiceManager *service = [ServiceManager sharedInstance];
               service.delegate = self;
               
               
               [service  handleRequestWithDelegates:urlStr info:requestDict];
               // [self uploadImagetoServer:urlStr];
               
           });
           
           
       }
       else
       {
           [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
       }
   

    
   
    
}



# pragma mark - Webservice Delegates

- (void)responseDic:(NSDictionary *)info
{
    [self handleResponse:info];
    
    
}
- (void)failResponse:(NSError*)error
{
    ////@"Error");
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
        
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    
    NSLog(@"responseInfo :%@",responseInfo);
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{

        if (isCall ==YES)
        {
        NSString *phone_number = [[responseInfo objectForKey:@"contactdetails"] objectForKey:@"merchant_contact"];
        NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",phone_number];
        NSLog(@"%@",phone_number);
        NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
        [[UIApplication sharedApplication] openURL:phoneURL];
            isCall = NO;
        }
        else if (isDeliveryExecutive == YES)
        {
        NSString *phone_number = [[responseInfo objectForKey:@"contactdetails"] objectForKey:@"driver_contact"];
            NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",phone_number];
            NSLog(@"%@",phone_number);
            NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
            [[UIApplication sharedApplication] openURL:phoneURL];
            isDeliveryExecutive = NO;
    
        }
            
            else if (isrefresh == YES)
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                dictresponse = [[responseInfo valueForKey:@"orderdetails"] valueForKey:@"orders"];
                driverResponse= [responseInfo valueForKey:@"driver_info"];
                
                
                NSMutableArray* totalItemsArray = [[NSMutableArray alloc] init];
                totalItemsArray = [dictresponse valueForKey:@"items"];

                lbl8.text = [NSString stringWithFormat:@"(%d)",[totalItemsArray count]];
  
                
                  //  lbl7.text = [NSString stringWithFormat:@"₹%@",[dictresponse valueForKey:@"grand_total"]];
                    
                    lbl7.text = [NSString stringWithFormat:@"₹%@",[USERDEFAULTS valueForKey:@"grandTotal"]];
                    
                    
                    
                    NSLog(@"grandtotalvalue %@" , [NSString stringWithFormat:@"₹%@",[USERDEFAULTS valueForKey:@"grandTotal"]] );
                    lbl7.text = [NSString stringWithFormat:@"₹%@",[USERDEFAULTS valueForKey:@"grandTotal"]];
                    
                    if ([Utilities null_ValidationString:[NSString stringWithFormat:@"₹%@",[USERDEFAULTS valueForKey:@"grandTotal"]]]) {
                        lbl7.text = [Utilities null_ValidationString:[[[responseInfo valueForKey:@"orderdetails"] valueForKey:@"orders"] valueForKey:@"total"] ];
                    }
                    else
                    {
                        lbl7.text = [NSString stringWithFormat:@"₹%@",[USERDEFAULTS valueForKey:@"grandTotal"]];
                    }

                lbl6.text = [NSString stringWithFormat:@"OrderID: %@",[dictresponse valueForKey:@"order_id"]];
                
                
                if ([[dictresponse valueForKey:@"drv_status"] intValue] == 0)
                {
                      dispatch_async(dispatch_get_main_queue(), ^{
                     if ([[dictresponse valueForKey:@"status"] intValue] == 1)
                     {
                         
                  
                    lbl1.hidden = NO;
                    img1.image = [UIImage imageNamed:@"ccr.png"];
                         
                        UIColor *color = [UIColor redColor];
                        [self.recievedlbl setTextColor:color];
                    
                     }
                     else
                     {
                         img1.image = [UIImage imageNamed:@"ccg.png"];
                         lbl1.hidden = YES;
                     }
                    });

                    
                }
              else  if ([[dictresponse valueForKey:@"drv_status"] intValue] == 1)
                {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         UIColor *color = [UIColor redColor];
                         [self.recievedlbl setTextColor:color];
    
                     UIColor *color4 = [UIColor redColor];
                     [self.processinglbl setTextColor:color4];
                        lbl1.hidden = NO;
                        img1.image = [UIImage imageNamed:@"ccr.png"];
                        lbl2.hidden = NO;
                         
                    
        lbl2.text =[NSString stringWithFormat:@"Your order has been processed by the restaurant. %@ %@ is on his way to pick up the order.",[driverResponse valueForKey:@"first_name"],[driverResponse valueForKey:@"last_name"]];
                   
                    NSString * fName = [driverResponse valueForKey:@"first_name"];
                    NSString * sName = [driverResponse valueForKey:@"last_name"];
                    
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:lbl2.text];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(48,fName.length+sName.length+1)];
            lbl2.attributedText = string;
          
                  //testing
                NSString * imageString = [NSString stringWithFormat:@"http://www.testingmadesimple.org/mealShack/uploads/driver/%@",[driverResponse objectForKey:@"image"]] ;
                         
                 //live
                //NSString * imageString = [NSString stringWithFormat:@"http://35.240.151.154//uploads/driver/%@",[driverResponse objectForKey:@"image"]] ;

                    
                    img2.layer.cornerRadius = img2.frame.size.height/2;
                    img2.layer.masksToBounds = YES;
                    img2.layer.borderColor = [UIColor clearColor].CGColor;
                    img2.layer.borderWidth=2;
                   
                    
                    imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageString]];
                    img2.image = [UIImage imageWithData:imageData];
                         img2.image = [UIImage imageNamed:@"ccr.png"];
                     });

                }
              else  if ([[dictresponse valueForKey:@"drv_status"] intValue] == 2)
              {
                  
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIColor *color = [UIColor redColor];
                        [self.recievedlbl setTextColor:color];
                        
                        UIColor *color4 = [UIColor redColor];
                        [self.processinglbl setTextColor:color4];
     
                        
                  UIColor *color1 = [UIColor redColor];
                  [self.atRestarantlbl setTextColor:color1];
                  
                  lbl1.hidden = NO;
                  img1.image = [UIImage imageNamed:@"ccr.png"];
                  lbl2.hidden = NO;
                  img2.image = [UIImage imageNamed:@"ccr.png"];
                  lbl3.hidden = NO;
                        
                        
                        
                        lbl2.text =[NSString stringWithFormat:@"Your order has been processed by the restaurant. %@ %@ is on his way to pick up the order.",[driverResponse valueForKey:@"first_name"],[driverResponse valueForKey:@"last_name"]];
                        
                        NSString * fiName = [driverResponse valueForKey:@"first_name"];
                        NSString * siName = [driverResponse valueForKey:@"last_name"];
                        
                        NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc] initWithString:lbl2.text];
                        [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(48,fiName.length+siName.length+1)];
                        lbl2.attributedText = string1;
                
                  lbl3.text =[NSString stringWithFormat:@"%@ %@ is at the restaurant and is waiting for the order.",[driverResponse valueForKey:@"first_name"],[driverResponse valueForKey:@"last_name"]];
                        
                        
                        NSString * fName = [driverResponse valueForKey:@"first_name"];
                        NSString * sName = [driverResponse valueForKey:@"last_name"];

                        
                NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:lbl3.text];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,fName.length+sName.length+1)];
                lbl3.attributedText = string;

                        //testing
                        NSString * imageString = [NSString stringWithFormat:@"http://www.testingmadesimple.org/mealShack/uploads/driver/%@",[driverResponse objectForKey:@"image"]] ;
                        
                        //live
                        //NSString * imageString = [NSString stringWithFormat:@"http://35.240.151.154//uploads/driver/%@",[driverResponse objectForKey:@"image"]] ;
                  
                  
                  img3.layer.cornerRadius = img3.frame.size.height/2;
                  img3.layer.masksToBounds = YES;
                  img3.layer.borderColor = [UIColor clearColor].CGColor;
                  img3.layer.borderWidth=2;
                  
                
                  
                  imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageString]];
                  img3.image = [UIImage imageWithData:imageData];
img3.image = [UIImage imageNamed:@"ccr.png"];
                  
                    });
                  
                  
              }
              else  if ([[dictresponse valueForKey:@"drv_status"] intValue] == 3)
              {
                  
                  
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        
                        UIColor *color = [UIColor redColor];
                        [self.recievedlbl setTextColor:color];
                        
                        UIColor *color4 = [UIColor redColor];
                        [self.processinglbl setTextColor:color4];
                        
                        
                        UIColor *color1 = [UIColor redColor];
                        [self.atRestarantlbl setTextColor:color1];
                  
                    UIColor *color2 = [UIColor redColor];
                  [self.Dispatchedlbl setTextColor:color2];
                  
                  lbl1.hidden = NO;
                  img1.image = [UIImage imageNamed:@"ccr.png"];
                  lbl2.hidden = NO;
                  img2.image = [UIImage imageNamed:@"ccr.png"];
                  lbl3.hidden = NO;
                  img3.image = [UIImage imageNamed:@"ccr.png"];
                  lbl4.hidden = NO;
                  //img4.image = [UIImage imageNamed:@"ccr.png"];
                        
                        
                        
                        lbl2.text =[NSString stringWithFormat:@"Your order has been processed by the restaurant. %@ %@ is on his way to pick up the order.",[driverResponse valueForKey:@"first_name"],[driverResponse valueForKey:@"last_name"]];
                        
                        NSString * fiName = [driverResponse valueForKey:@"first_name"];
                        NSString * siName = [driverResponse valueForKey:@"last_name"];
                        
                        NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc] initWithString:lbl2.text];
                        [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(48,fiName.length+siName.length+1)];
                        lbl2.attributedText = string1;
                        
                        lbl3.text =[NSString stringWithFormat:@"%@ %@ is at the restaurant and is waiting for the order.",[driverResponse valueForKey:@"first_name"],[driverResponse valueForKey:@"last_name"]];
                        
                        
                        NSString * fName = [driverResponse valueForKey:@"first_name"];
                        NSString * sName = [driverResponse valueForKey:@"last_name"];
                        
                        
                        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:lbl3.text];
                        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,fName.length+sName.length+1)];
                        lbl3.attributedText = string;

                  
                  
                  
                        
                        //testing
                        NSString * imageString = [NSString stringWithFormat:@"http://www.testingmadesimple.org/mealShack/uploads/driver/%@",[driverResponse objectForKey:@"image"]] ;
                        
                        //live
                        //NSString * imageString = [NSString stringWithFormat:@"http://35.240.151.154//uploads/driver/%@",[driverResponse objectForKey:@"image"]] ;
                 
                  
                  img4.layer.cornerRadius = img4.frame.size.height/2;
                  img4.layer.masksToBounds = YES;
                  img4.layer.borderColor = [UIColor clearColor].CGColor;
                  img4.layer.borderWidth=2;
                  

                  
                  imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageString]];
                  img4.image = [UIImage imageWithData:imageData];

                  img4.image = [UIImage imageNamed:@"ccr.png"];
                    });

                  
              }
              else  if ([[dictresponse valueForKey:@"drv_status"] intValue] == 4)
              {
                  
                dispatch_async(dispatch_get_main_queue(), ^{
                  
                    UIColor *color = [UIColor redColor];
                    [self.recievedlbl setTextColor:color];
                    
                    UIColor *color4 = [UIColor redColor];
                    [self.processinglbl setTextColor:color4];
                    
                    
                    UIColor *color1 = [UIColor redColor];
                    [self.atRestarantlbl setTextColor:color1];
                    
                    UIColor *color2 = [UIColor redColor];
                    [self.Dispatchedlbl setTextColor:color2];
                  
                  UIColor *color3 = [UIColor redColor];
                  [self.Deliverdlbl setTextColor:color3];
                  lbl1.hidden = NO;
                  img1.image = [UIImage imageNamed:@"ccr.png"];
                  lbl2.hidden = NO;
                  img2.image = [UIImage imageNamed:@"ccr.png"];
                  lbl3.hidden = NO;
                  img3.image = [UIImage imageNamed:@"ccr.png"];
                  lbl4.hidden = NO;
                  img4.image = [UIImage imageNamed:@"ccr.png"];
                  lbl5.hidden = NO;
                  //img5.image = [UIImage imageNamed:@"ccr.png"];
                    
                    
                    
                    lbl2.text =[NSString stringWithFormat:@"Your order has been processed by the restaurant. %@ %@ is on his way to pick up the order.",[driverResponse valueForKey:@"first_name"],[driverResponse valueForKey:@"last_name"]];
                    
                    NSString * fiName = [driverResponse valueForKey:@"first_name"];
                    NSString * siName = [driverResponse valueForKey:@"last_name"];
                    
                    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc] initWithString:lbl2.text];
                    [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(48,fiName.length+siName.length+1)];
                    lbl2.attributedText = string1;
                    
                    lbl3.text =[NSString stringWithFormat:@"%@ %@ is at the restaurant and is waiting for the order.",[driverResponse valueForKey:@"first_name"],[driverResponse valueForKey:@"last_name"]];
                    
                    
                    NSString * fName = [driverResponse valueForKey:@"first_name"];
                    NSString * sName = [driverResponse valueForKey:@"last_name"];
                    
                    
                    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:lbl3.text];
                    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,fName.length+sName.length+1)];
                    lbl3.attributedText = string;

                    
                    //testing
                    NSString * imageString = [NSString stringWithFormat:@"http://www.testingmadesimple.org/mealShack/uploads/driver/%@",[driverResponse objectForKey:@"image"]] ;
                    
                    //live
                    //NSString * imageString = [NSString stringWithFormat:@"http://35.240.151.154//uploads/driver/%@",[driverResponse objectForKey:@"image"]] ;
                  
                  img5.layer.cornerRadius = img5.frame.size.height/2;
                  img5.layer.masksToBounds = YES;
                  img5.layer.borderColor = [UIColor clearColor].CGColor;
                  img5.layer.borderWidth=2;
                 
                  imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageString]];
                  img5.image = [UIImage imageWithData:imageData];

                  img5.image = [UIImage imageNamed:@"ccr.png"];
                  
                  
                  [myTimer invalidate];
                  myTimer = nil;
                  
                    });
                  
                  
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
      RateUsViewController * RateUs = [storyboard instantiateViewControllerWithIdentifier:@"RateUsViewController"];
      RateUs.strOrderID = [dictresponse objectForKey:@"order_id"];
      RateUs.establishmentID =[dictresponse objectForKey:@"establishment_id"];
      RateUs.createdOnId = [dictresponse objectForKey:@"created_on"];
      RateUs.restaurant= [dictresponse  objectForKey:@"name"];
      RateUs.totalCost = [dictresponse objectForKey:@"total"];
      [self.navigationController pushViewController:RateUs animated:YES];
                  
              }
            });
            
            }
            
            
    });
        
    }
    
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"message"]];
            [Utilities displayCustemAlertViewWithOutImage:str :self.view];
        });
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
