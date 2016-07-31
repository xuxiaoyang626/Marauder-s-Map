/**
 * The IGMapView allows for quickly adding an indoor map view to an app and displaying the location and routes.
 */


#import <UIKit/UIKit.h>

#import <IndoorGuide/IGPositioningDelegate.h>
#import <IndoorGuide/IGDirectionsDelegate.h>
#import <IndoorGuide/IGMapViewDelegate.h>

@interface IGMapView: UIView

@property (retain, nonatomic) id<IGMapViewDelegate> delegate;



@property (assign, nonatomic) BOOL rotateWithHeading;
@property (assign, nonatomic) BOOL panWithLocation;

- (void)setUserHeading:(CLLocationDirection)newHeading;
- (void)setUserLocation:(CLLocation*)newLocation;

- (void)highlightZones:(uint32_t)zone_id;
- (void)unHighlightZones:(uint32_t)zone_id;

- (void)setRoute:(NSArray *)routepoints;

- (void)clearRoute;

- (void)startWithNDDData:(NSData*)data;

- (void)startWithNDDUrl:(NSURL *)url;

- (void)loadFromNDD;

/* For debugging only */
- (void)setWidgetOverrideURL:(NSURL *)url;

@end
