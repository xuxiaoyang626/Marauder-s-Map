
#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CLBeaconRegion.h>

@interface IGZone : NSObject

@property uint32_t zone_id;
@property (copy) NSString* name;

@end

/**
 * Low level wrapper around the C api. Main purpose is to give a more Objective C interface to the
 * functionality of the C library. Typically it isn't expected that this interface is used directly.
 * Contact support@nimbledevices.com if you need furhter information of this lower level API.
 */
@interface IGLowLevel : NSObject

@property(readonly, nonatomic) CLLocation *location;


//- (int)isInNDD:(NSDictionary *)advertisementData;
- (BOOL) addBluetoothPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI timestamp:(NSUInteger)t;
- (BOOL) addBeacon:(CLBeacon*)beacon;

-(void)setNDD:(NSData *)res;

-(NSInteger) getNDDVersion;
-(NSData *)getNDDProperty:(NSString *)propertyName ofType:(NSString *)dataType;
-(void)updateLocation;

-(void)getRegionIdsEntered:(NSMutableArray**)arrayOfEntered exited:(NSMutableArray**)arrayOfExited ;
-(void)getRegionIdsAndNamesEntered:(NSMutableArray**)arrayOfEntered exited:(NSMutableArray**)arrayOfExited ;
-(NSString*)getNameForRegion:(uint32_t)region_id;


-(void)startStreamingTo:(NSString*)destination port:(NSInteger)port;
-(void)stopStreaming;
-(void)addHeading:(CLLocationDirection)heading;

-(void)getHeadingDirection:(CLLocationDirection*)dir andAccuracy:(CLLocationDirection*)acc;

-(void)addMagnetometerData:(CMMagnetometerData*)mag;
-(BOOL)addAccelerometerData:(CMAccelerometerData*)acc;
-(void)addGyroscopeData:(CMGyroData*)gyro;
-(void)addDeviceMotionData:(CMDeviceMotion *)motion;

-(const uint16_t*)getDebuggingGridWidth:(uint16_t *)width height:(uint16_t *)height lat:(double *)lat lon:(double *)lon;

-(NSArray*) getRouteTargets:(NSString*)keyword;
-(int) routeToBest:(NSString *)keyword error:(NSError**)error;

-(int) routeFrom:(NSNumber *)start to:(NSNumber*)end error:(NSError **)error;;

-(int) routeTo:(NSNumber*)target error:(NSError**)err;
-(NSArray*) getTargetCoordinate:(NSNumber*)target;
- (unsigned int) getTimestamp;
- (int)updateRouteInformation:(NSError **)error;
-(void) getRoutePosition:(CLLocationCoordinate2D*)pos altitude:(CLLocationDistance*)alt direction:(CLLocationDirection*)direction segmentDistance:(CLLocationDistance*)distance goalDistance:(CLLocationDistance*)goalDistance;

- (void) setImmediateLocation:(CLLocation *)location;

-(void)setDebugHandler:(void (^)(int lvl, NSString* msg))block;

- (NSArray *)getRouteCoordinates;

-(void)updateConfiguration:(NSDictionary *)jsonConf;

-(BOOL)isWalking;

@end
