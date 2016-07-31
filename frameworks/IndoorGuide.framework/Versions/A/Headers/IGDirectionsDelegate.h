/**
 * The protocol for handling navigation and routing related updates.
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol IGDirectionsDelegate <NSObject>


/**
 *  After a route has been found from the current location to a given target, this delegate method
 *  is called. Routepoints is a list of the points from the current location to the target. Basically
 *  after this method is called, navigation can begin.
 *
 *  @param manager     The manager from which this callback originated
 *  @param routepoints A list of latitude,longitude and altitude points for the route to target.
 */
- (void)guideManager:(IGGuideManager *)manager didCompleteRouting:(NSArray *)routepoints;


/**
 *  This callback is called every time the position is updated, to give the update routing information.
 *
 *  @param manager   The manager from which this callback originated
 *  @param pos       The position of the user as projected onto the route
 *  @param alt       The altitude of the user
 *  @param direction The heading of the user
 *  @param toChange  The distance to where the direction might change
 *  @param toGoal    The total distance left to goal
 */
- (void)guideManager:(IGGuideManager *)manager didUpdateRoutePosition:(CLLocationCoordinate2D)pos altitude:(CLLocationDistance)alt direction:(CLLocationDirection)direction distanceToChange:(CLLocationDistance)toChange distanceToGoal:(CLLocationDistance)toGoal;

/**
 * Called when ever routing fails, either due to attempting to route to an unkown location, or if
 * the position is far away from the route.
 *
 *  @param manager The manager from which this callback originated
 *  @param err     The error that happened in the routing.
 */
- (void)guideManager:(IGGuideManager *)manager didFailRoutingWithError:(NSError *)err;


@end
