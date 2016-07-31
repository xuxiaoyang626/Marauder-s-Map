/**
 * Helper class to allow you to quickly bridge between the IGMapView and the positioning library. You can subclass and override the
 * methods to add your own functionality.
 */

#import <Foundation/Foundation.h>

#import <IndoorGuide/IGMapView.h>
#import <IndoorGuide/IGPositioningDelegate.h>
#import <IndoorGuide/IGDirectionsDelegate.h>

@interface IGMapViewController: UIViewController<IGPositioningDelegate, IGDirectionsDelegate,IGMapViewDelegate>

@property IBOutlet IGMapView *mapView;

@end
