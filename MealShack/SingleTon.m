//
//  SingleTon.m
//  SingleTonDataPassing
//
//  Created by Panduranga Mallipudi on 01/03/17.
//  Copyright © 2017 Edu.Self. All rights reserved.
//

#import "SingleTon.h"

@implementation SingleTon
+(id)singleTonMethod{
    static SingleTon *singleTon=nil;
    @synchronized (self) {
        if (singleTon ==nil) {
            singleTon=[self alloc];
        }
    }
    return singleTon;
}
@end
