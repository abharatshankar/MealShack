//
//  TrackOrderViewController.h
//  MealShack
//
//  Created by Prasad on 07/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LcnManager.h"
#import "CustomAnnotation.h"
#import "CommonClassViewController.h"


@interface TrackOrderViewController : CommonClassViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UILabel *lbl1,*lbl2,*lbl3,*lbl4,*lbl5,*lbl6,*lbl7,*lbl8;
    IBOutlet UIImageView *img1,*img2,*img3,*img4,*img5;
    IBOutlet UIView *lineview;

    IBOutlet UIScrollView *scrollStatus;
    CLLocationManager *locationManager;
    CLLocation *sourceCoordinate;
    CLLocation *destinationCoordinate;
}
@property (strong, nonatomic) IBOutlet MKMapView *MapView;
@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView; //overlay view

@property (strong, nonatomic) NSString *strOrderID;
@property (strong, nonatomic) NSString *stritemcount;
@property (strong, nonatomic) IBOutlet UILabel *recievedlbl;
@property (strong, nonatomic) IBOutlet UILabel *processinglbl;
@property (strong, nonatomic) IBOutlet UILabel *atRestarantlbl;
@property (strong, nonatomic) IBOutlet UILabel *Dispatchedlbl;
@property (strong, nonatomic) IBOutlet UILabel *Deliverdlbl;






@end
