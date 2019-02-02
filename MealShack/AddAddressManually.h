//
//  SearchLocationsViewController.h
//  RushNow
//
//  Created by POSSIBILLION on 10/11/15.
//  Copyright (c) 2015 Possibilliontech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
#import "LcnManager.h"
#import "CustomAnnotation.h"
#import "CommonClassViewController.h"

@interface AddAddressManually : CommonClassViewController<MKMapViewDelegate,CLLocationManagerDelegate, MKMapViewDelegate,CLLocationManagerDelegate>
{
    
    BOOL shouldBeginEditing;
    CLGeocoder *geocoder;
    CLLocationManager *locationManager;
    MKMapView *customMapView;
    MKPointAnnotation *point;
    CLLocationManager *currentLocation;
    UILabel *lblAdress;
    CLLocationCoordinate2D theCoordinate;
    IBOutlet UIButton *dropBtn;
    IBOutlet UIView *popbgView;
    IBOutlet UIButton *searchBtn;
    IBOutlet UIView *searchView,*savedAddressView;
    IBOutlet UISearchBar *searchbar;
    
    
}
@property (nonatomic, strong) NSString *classTypeStr;
@property CLLocationCoordinate2D * editLocationLatLong;
@property CLLocationDegrees  lati, Longi;

@property NSString * latiSt , *longiSt;
//written by gayatri
@property (nonatomic, strong) NSDictionary *saveaddress;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;

@property (nonatomic, strong) NSString *currentLocationStr;
@property(nonatomic,retain)NSString *addrssforManualDrop;
@property (nonatomic ,retain)NSString *couriourOrOrderStr;
@property (nonatomic, strong) CustomAnnotation      *fixAnnotation;
@property (nonatomic, strong) UIImageView           *annotationImage;
@property (nonatomic, assign) MKAnnotationViewDragState dragState;
@property  NSString *strTitle;

-(IBAction)dropBtnClicked:(id)sender;
-(IBAction)SearchAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *mapSelectBtn;

@end
