//
//  IGMovementModeDelegate.h
//  IndoorGuide
//
//  Created by Mikko Virkkilä on 18/06/15.
//  Copyright (c) 2015 Nimble Devices Oy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGMovementModeDelegate <NSObject>

-(void)didStartWalking;
-(void)didStopWalking;

@end
