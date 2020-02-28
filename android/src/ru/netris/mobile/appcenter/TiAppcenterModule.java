package ru.netris.mobile.appcenter;

import android.app.Activity;
import com.microsoft.appcenter.AppCenter;
import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.crashes.Crashes;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.TiProperties;
import java.util.ArrayList;
import ru.netris.mobile.appcenter.analytics.TiAppCenterAnalyticsModule;
import ru.netris.mobile.appcenter.crashes.TiAppCenterCrashesModule;

@Kroll.module(name = "AppCenter", id = "ru.netris.mobile.appcenter")
public class TiAppcenterModule extends KrollModule
{

	private static final String PROPERTY_START_CRASHES_ON_CREATE = "ti.appcenter.crashes.start-on-create";
	private static final String PROPERTY_START_ANALYTICS_ON_CREATE = "ti.appcenter.analytics.start-on-create";
	private static final String PROPERTY_SECRET = "ti.appcenter.secret.android";
	private static final String TAG = "TiAppCenterModule";
	private static boolean started = false;

	public TiAppcenterModule()
	{
		super();
	}

	public static boolean isStarted()
	{
		return started;
	}

	@Kroll.onAppCreate
	public static void onAppCreate(TiApplication app)
	{
		TiProperties properties = app.getAppProperties();
		String secret = null;
		if (properties.hasProperty(PROPERTY_SECRET)) {
			secret = properties.getString(PROPERTY_SECRET, null);
		}
		java.util.ArrayList<Class> list = new ArrayList<>();
		if (properties.hasProperty(PROPERTY_START_CRASHES_ON_CREATE)) {
			list.add(Crashes.class);
		}
		if (properties.hasProperty(PROPERTY_START_ANALYTICS_ON_CREATE)) {
			list.add(Analytics.class);
		}
		if (list.size() > 0) {
			AppCenter.start(TiApplication.getInstance(), secret, list.toArray(new Class[list.size()]));
			started = true;
		}
	}

	@Kroll.method
	public void start(Object[] arguments)
	{
		if (started) {
			return;
		}
		if (arguments.length == 0) {
			Log.e(TAG, "Wrong arguments count passed to start()");
			return;
		}
		TiApplication app = TiApplication.getInstance();
		TiProperties properties = app.getAppProperties();
		String secret = "";
		if (properties.hasProperty(PROPERTY_SECRET)) {
			secret = properties.getString(PROPERTY_SECRET, "");
		}
		java.util.ArrayList<Class> list = new ArrayList<>();

		for (int i = 0, l = arguments.length; i < l; i++) {
			Object argument = arguments[i];
			if (i == 0 && argument instanceof String) {
				secret = (String) argument;
			} else if (argument.getClass().equals(TiAppCenterCrashesModule.class)) {
				list.add(Crashes.class);
			} else if (argument.getClass().equals(TiAppCenterAnalyticsModule.class)) {
				list.add(Analytics.class);
			} else {
				Log.e(TAG, "Wrong argument passed to start() " + argument.toString());
			}
		}
		if (list.size() > 0) {
			AppCenter.start(app, secret, list.toArray(new Class[list.size()]));
			started = true;
		}
	}

	@Kroll.method
	@Override
	public String getApiName()
	{
		return "TiAppCenterModule";
	}
}
