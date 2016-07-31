//
//  IGFloorPlanMarker.h
//  IndoorGuide
//
//  Created by Mikko Virkkilä on 28/04/15.
//  Copyright (c) 2015 Nimble Devices Oy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <IndoorGuide/IGCoordinateConverter.h>



@interface IGFloorPlanMarker: NSObject



/* Data properties */
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
/* Note that changing the altitude does not move the marker ot a different floor! */
@property (assign) CLLocationDistance altitude;

/* Visual properties */
@property (retain, nonatomic) CALayer *visualization;

/* Visual properties */
@property (retain, nonatomic) CALayer *halo;



/* Utilities, internal use */
@property (weak, nonatomic) IGCoordinateConverter *coordinateConverter;

-(void)setCoordinateAndAltitudeFromJSON:(NSDictionary *)json;;





/* Factory functions */

+(IGFloorPlanMarker*)markerForUser:(CGFloat)radius
               directionalAccuracy:(CGFloat)dirAcc
                    displayHeading:(BOOL)displayDirection
                      primaryColor:(UIColor*)primaryColor
                    secondaryColor:(UIColor*)secondaryColor;

+(IGFloorPlanMarker*)markerForPOIFromJSON:(NSDictionary *)json;

+(IGFloorPlanMarker*)markerWithImage:(UIImage *)image anchor:(CGPoint)percentagePoint;

+(IGFloorPlanMarker*)markerWithLabel:(NSString *)labelText
                        primaryColor:(UIColor *)backgroundColor
                      secondaryColor:(UIColor *)textColor;

+(IGFloorPlanMarker*)markerWithLabel:(NSString *)labelText
                        primaryColor:(UIColor *)backgroundColor
                      secondaryColor:(UIColor *)textColor
                            fontName:(NSString *)fontName
                          fontheight:(CGFloat)textHeight;

+(UIColor *)getColor:(NSString *)colorString;


@end


