import CoreLocation;

var locationManager = LocationManager();

@objc(IOSGeoLocation) class IOSGeoLocation : CDVPlugin {
    @objc(checkAutomaticTime:)
    func checkAutomaticTime(command: CDVInvokedUrlCommand) {
        locationManager.watchPosition(cDelegate: self.commandDelegate, cCommand: command);
    }
}

class LocationManager : NSObject, CLLocationManagerDelegate {
    var manager = CLLocationManager();
    var cordovaDelegate:CDVCommandDelegate?;
    var cordovaCommand:CDVInvokedUrlCommand?;
    
    func watchPosition(cDelegate: CDVCommandDelegate, cCommand: CDVInvokedUrlCommand) {
        self.manager.stopUpdatingLocation();
        self.isWatching = false;
        if !self.isWatching {
            self.manager.requestWhenInUseAuthorization();
            self.cordovaDelegate = cDelegate;
            self.cordovaCommand = cCommand;
            self.manager.delegate = self;
            self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            self.manager.startUpdatingLocation();
        }
    }
    
    func getCurrentPosition(cDelegate: CDVCommandDelegate, cCommand: CDVInvokedUrlCommand) {
        var result = CDVPluginResult(
            status: CDVCommandStatus_OK
        );
        if self.lastLocation != nil && Date().timeIntervalSince((self.lastLocation?.timestamp)!) < 60 {
            result = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: getLocationData(location: self.lastLocation!) as! [AnyHashable : Any]
            );
        }
        cDelegate.send(
            result,
            callbackId: cCommand.callbackId
        );
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.manager.stopUpdatingLocation();
        let loc = locations[locations.count - 1] as CLLocation;
        
// TODO abgleichen mit Systemzeit
        let isAutomaticTime:Bool = true;

        callSuccess(isAutomaticTime: isAutomaticTime);
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.lastLocation = nil;
        callError(error: error);
    }
    
    func callSuccess(isAutomaticTime: Bool) {
        if self.cordovaDelegate != nil && self.cordovaCommand != nil {
            let result = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: isAutomaticTime
            );
            self.cordovaDelegate!.send(
                result,
                callbackId: self.cordovaCommand!.callbackId
            );
        }
    }
    
    func callError(error: Error) {
        if self.cordovaDelegate != nil && self.cordovaCommand != nil {
            let result = CDVPluginResult(
                status: CDVCommandStatus_ERROR,
                messageAs: getErrorData(error: error) as! [AnyHashable : Any]
            );
            result?.setKeepCallbackAs(true);
            self.cordovaDelegate!.send(
                result,
                callbackId: self.cordovaCommand!.callbackId
            );
        }
    }
    
    func getErrorData(error: Error) -> NSMutableDictionary {
        return [
            "code" : 1,
            "message" : error.localizedDescription
        ];
    }
}