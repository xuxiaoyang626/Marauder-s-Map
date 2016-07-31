#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import <IndoorGuide/IGFloorPlanMarker.h>

@protocol IGFloorPlanCollectionViewDelegate;



/**
 * The IGFloorPlanCollectionView is an easy way to visualize a multi story buildings floor maps. It provides an
 * easy to use API for setting the location, displaying routes and reacting to user gestures.
 */
@interface IGFloorPlanCollectionView : UIView

/**
 * The delegate for this view to allow reacting for example to floor switching.
 */
@property (weak) id<IGFloorPlanCollectionViewDelegate> delegate;

/**
 * This view uses a very light data model in the form of a single configuration dictionary. The configuration of
 * the widget can be obtained from the NDD.
 */
@property (retain, nonatomic) NSDictionary *configuration;


@property (nonatomic) BOOL displayUserHeading;

/**
 * The number of floors as loaded from the configuration.
 */
@property (assign, readonly, getter=getFloorCount) NSUInteger floorCount;

/**
 * The index of the current floor. The index corresponds to the list of floors sorted by their identifier in the DXF file.
 * The delegate call notifying of changed floor and this currentFloorIndex can be used for example to disable and enable
 * floor switching buttons.
 */
@property (assign, nonatomic) NSUInteger currentFloorIndex;

/**
 * @param newHeading the compass heading the user indicator should point at
 * @param accuracy is the +/- accuracy of the heading estimate in degrees.
 * Note: Setting the accuracy to a non-zero value will result in visual glitches. This is a known issue, and it is recommended
 *       to keep the accuracy set to zero.
 * <br/>
 * Note: To hide the direction arrow, set the heading or accuracy to NaN
 */
- (void)setUserHeading:(CLLocationDirection)newHeading accuracy:(CLLocationAccuracy)accuracy;

/**
 * Sets the user indicators coordinates. The altitude defines which floor the user is residing on.
 */
- (void)setUserCoordinate:(CLLocationCoordinate2D)coordinate accuracy:(CLLocationAccuracy)accuracy altitude:(CLLocationDistance)altitude;

/**
 * Accepts the route points in the same format that GuideManager gives them, i.e. a list of triplets of latitude, longitude 
 * and altitude. For example [ [lat0, lon0, alt0], [lat1, lon1, alt1], ...]. These points will then be split to be shown on each
 * floor.
 */
- (void)setRoute:(NSArray*)points;


/**
 * Clears the route.
 */
- (void)clearRoute;

/**
 * Switches to the floor above the current one.
 * @return whether or not it was possible to switch to the floor.
 */
- (BOOL) switchToFloorAbove:(BOOL)animated;

/**
 * Switches to the floor below the current one.
 * @return whether or not it was possible to switch to the floor below.
 */
- (BOOL) switchToFloorBelow:(BOOL)animated;


- (void) addMarker:(IGFloorPlanMarker*)marker toGroup:(NSString*)group;

- (void) clearMarkerGroup:(NSString*)group;



@end




@protocol IGFloorPlanCollectionViewDelegate <NSObject>

@optional

/**
 * Called when the displayed floor has changed.
 */
- (void)didChangeCurrentFloor:(IGFloorPlanCollectionView*)view;

/**
 * Called when the user tapped on a floor plan.
 */
- (void)didTapAtCoordinate:(CLLocationCoordinate2D)coordinate altitude:(CLLocationDistance)altitude;

@end

