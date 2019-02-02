//
//  SingleTon.h
//  SingleTonDataPassing
//
//  Created by Panduranga Mallipudi on 01/03/17.
//  Copyright © 2017 Edu.Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleTon : NSObject
@property(strong, nonatomic)NSMutableArray *dataArray;
@property(strong, nonatomic)NSMutableArray *dataArray1;
@property NSMutableArray *ratingSarray,*deliveryTimeArray,*PriceArray,*cusinesArray,*ratingArray;

@property NSMutableDictionary * filteredDict;
@property BOOL isfilter, isNotFilterApplies , isResetFilter;


@property NSMutableArray * pageBannerImageArray;
@property BOOL * isFromEdit,*isFromLogin,*isFromSignUp,*isPhoneNumAlso,*isFromAddresses,*isFromOrders, *isFromOtp;
@property NSString * userRatingStr,*userRatingStr2;
@property(readwrite)NSUInteger selectedIndex;
@property NSMutableArray * CategorynamesArray;
@property NSString *offsetValueStr,*itemIdString,*identifyStr;
@property (nonatomic, strong) NSArray *mapItemList;

@property NSMutableArray * dixFromRestarunts;

@property BOOL * isSignup,* isLogout;
@property NSString * nameStr ,* emailStr ;

@property NSString * addressTyp;
@property NSString * orderIdStr;


@property NSString * strLat,*strLong;

+(id)singleTonMethod;
@end
