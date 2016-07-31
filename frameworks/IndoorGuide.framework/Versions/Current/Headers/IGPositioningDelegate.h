/**
 * The protocol to handle updates to the position and heading of the user. This protocol is very similar to the native 
 * CLLocationManagerDelegate. This should make it very easy to transition existing code into using this protocol.
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>

@class IGGuideManager;
@class IGSquareRegion;

@protocol IGPositioningDelegate <NSObject>



@optional


/**
 *  Invoked when a new location is available. oldLocation may be nil if there is no previous location
 *    available.
 *
 *  @param manager     The manager which made this callback
 *  @param newLocation The new location with the coordinates
 *  @param oldLocation The previous location
 */
- (void)guideManager:(IGGuideManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

/**
 *  Invoked when a new heading is available. Deprecated.
 *  @param manager    The manager which made this callback
 *  @param newHeading The direction towards which the phone is facing
 */
- (void)guideManager:(IGGuideManager *)manager
       didUpdateHeading:(CLLocationDirection)newHeading;


/**
 *  Invoked when a new heading is available.
 *
 *  @param manager    The manager which made this callback
 *  @param newHeading The direction towards which the phone is facing in degrees
 *  @param accuracyOfHeading The estimated error in the heading in degrees
 */
- (void)guideManager:(IGGuideManager *)manager
    didUpdateHeading:(CLLocationDirection)newHeading
            accuracy:(CLLocationDirection)accuracyOfHeading;
/**
 *    Invoked when a new heading is available. Return YES to display heading calibration info. The display
 *    will remain until heading is calibrated, unless dismissed early via dismissHeadingCalibrationDisplay.
 *
 *  @param manager The manager which made this callback
 *
 *  @return YES if you want to allow the heading calibration alert to be displayed; NO if you do not.
 */
- (BOOL)guideManagerShouldDisplayHeadingCalibration:(IGGuideManager *)manager;


/**
 *    Invoked when the user enters a monitored region aka zone.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 *
 *  @param manager   The manager which made this callback
 *  @param zone_id The numeric id given to this trigger
 *  @param name      A the textual name given to this region trigger
 */
- (void)guideManager:(IGGuideManager *)manager
      didEnterZone:(uint32_t)zone_id name:(NSString*)name;

/**
 *    Invoked when the user exits a monitored region aka zone.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 *
 *  @param manager   The manager which made this callback
 *  @param zone_id The numeric id given to this trigger
 *  @param name      A the textual name given to this region trigger
 */
- (void)guideManager:(IGGuideManager *)manager
       didExitZone:(uint32_t)zone_id name:(NSString*)name;

/**
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 *
 *  @param manager The manager which made this callback
 *  @param error   The error that has occurred
 */
- (void)guideManager:(IGGuideManager *)manager
       didFailWithError:(NSError *)error;

/**
 *  Called when an NDD was loaded successfully.
 *
 *  @param manager The manager which made this callback
 */
- (void)guideManagerDidLoadNDD:(IGGuideManager *)manager;

/**
 *  Called to update the progress of the NDD download
 *
 *  @param manager The manager which made this callback
 *  @param bytesDownloaded the number of bytes downloaded so far
 *  @param totalBytes the number of bytes expected to write in total
 */
- (void)guideManager:(IGGuideManager *)manager didProgressLoadingNDD:(NSInteger)bytesDownloaded ofTotal:(NSInteger) totalBytes;


@end
