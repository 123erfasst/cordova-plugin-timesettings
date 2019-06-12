package de.erfasst.plugin;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.provider.Settings;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

public class dateSettings extends CordovaPlugin {
    public dateSettings() {}

    private String[] whiteListedTimeZones = new String[] {
        "Europe/Berlin"
    };

    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Context context = this.cordova.getActivity().getApplicationContext();
        try {
            switch (action) {
                case "checkAutomaticTime":
                    if (this.isTimeAutomatic(context) && this.isAutomaticTimezone(context)) {
                        callbackContext.success(1);
                        return true;
                    }
                    else if (!this.isTimeAutomatic(context) && this.isAutomaticTimezone(context)) {
                    	callbackContext.success(-1);
                    	return true;
                    }
                    else if (this.isTimeAutomatic(context) && !this.isAutomaticTimezone(context)) {
                    	callbackContext.success(-2);
                    	return true;
                    }
                    callbackContext.success(0);
                    return true;
                case "open":
                    this.cordova.getActivity().startActivity(new Intent(Settings.ACTION_DATE_SETTINGS));
                    return true;
                default:
                    callbackContext.error("Invalid action");
                    return false;
            }
        } catch(Exception e ) {
            callbackContext.error("Exception occurred: ".concat(e.getMessage()));
            return false;
        }
    }

    private boolean isTimeAutomatic(Context c) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            return Settings.Global.getInt(c.getContentResolver(), Settings.Global.AUTO_TIME, 0) == 1;
        } else {
            return android.provider.Settings.System.getInt(c.getContentResolver(), android.provider.Settings.System.AUTO_TIME, 0) == 1;
        }
    }

    private boolean isAutomaticTimezone(Context c) {
        if (Arrays.asList(whiteListedTimeZones).contains(TimeZone.getDefault().getID())) {
            return true;
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            return Settings.Global.getInt(c.getContentResolver(), Settings.Global.AUTO_TIME_ZONE, 0) == 1;
        } else {
            return android.provider.Settings.System.getInt(c.getContentResolver(), android.provider.Settings.System.AUTO_TIME_ZONE, 0) == 1;
        }   
    }
}