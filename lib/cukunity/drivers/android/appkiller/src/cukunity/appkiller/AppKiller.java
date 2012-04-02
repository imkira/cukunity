package cukunity.appkiller;

import android.app.Activity;
import android.os.Bundle;
import android.app.ActivityManager;
import android.util.Log;

public class AppKiller extends Activity
{
    private static final String TAG = "AppKiller";

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        Bundle extras = getIntent().getExtras(); 
        if (extras != null)
        {
            String pkg = extras.getString("package");
            if ((pkg != null) && (pkg.length() > 0))
            {
                Log.d(TAG, "Restarting " + pkg);
                ActivityManager am = (ActivityManager)getSystemService(ACTIVITY_SERVICE);
                am.restartPackage(pkg);
            }
        }
        Log.d(TAG, "Killing self");
        System.exit(0);
    }
}
