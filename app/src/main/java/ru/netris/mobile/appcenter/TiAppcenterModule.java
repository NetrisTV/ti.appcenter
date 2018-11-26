package ru.netris.mobile.appcenter;

import com.microsoft.appcenter.AppCenter;
import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.crashes.Crashes;

import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;

import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.TiProperties;

@Kroll.module(name = "AppCenter", id = "ru.netris.mobile.appcenter")
public class TiAppcenterModule extends KrollModule
{

	private static final String PROPERTY_START_CRASHES_ON_CREATE = "ti.appcenter.crashes.start-on-create";
	private static final String PROPERTY_START_ANALYTICS_ON_CREATE = "ti.appcenter.analytics.start-on-create";
	private static final String PROPERTY_SECRET = "ti.appcenter.secret.android";
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
		if (!properties.hasProperty(PROPERTY_SECRET)) {
			return;
		}
		String secret = properties.getString(PROPERTY_SECRET, "");
		if (secret.isEmpty()) {
			return;
		}
		boolean startCrashes = false;
		if (properties.hasProperty(PROPERTY_START_CRASHES_ON_CREATE)) {
			startCrashes = properties.getBool(PROPERTY_START_CRASHES_ON_CREATE, false);
		}
		boolean startAnalytics = false;
		if (properties.hasProperty(PROPERTY_START_ANALYTICS_ON_CREATE)) {
			startAnalytics = properties.getBool(PROPERTY_START_ANALYTICS_ON_CREATE, false);
		}
		if (startCrashes && startAnalytics) {
			AppCenter.start(TiApplication.getInstance(), secret, Analytics.class, Crashes.class);
			started = true;
			return;
		}
		if (startAnalytics) {
			startAnalytics(secret);
			return;
		}
		if (startCrashes) {
			startCrashes(secret);
		}
	}

	public static void startCrashes(String secret)
	{
		AppCenter.start(TiApplication.getInstance(), secret, Crashes.class);
		started = true;
	}

	public static void startAnalytics(String secret)
	{
		AppCenter.start(TiApplication.getInstance(), secret, Analytics.class);
		started = true;
	}
}
