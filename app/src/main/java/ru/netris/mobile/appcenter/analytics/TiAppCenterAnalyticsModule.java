package ru.netris.mobile.appcenter.analytics;

import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.analytics.AnalyticsTransmissionTarget;
import com.microsoft.appcenter.analytics.PropertyConfigurator;
import com.microsoft.appcenter.utils.AppCenterLog;
import com.microsoft.appcenter.utils.async.AppCenterConsumer;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.KrollPromise;
import org.appcelerator.kroll.annotations.Kroll;
import org.json.JSONException;

import java.util.HashMap;
import java.util.Map;

import ru.netris.mobile.appcenter.TiAppcenterModule;
import ru.netris.mobile.appcenter.crashes.TiAppCenterCrashesModule;
import ru.netris.mobile.appcenter.utils.TiAppCenterUtils;

import static com.microsoft.appcenter.analytics.Analytics.LOG_TAG;

@Kroll.module(name = "Analytics")
public class TiAppCenterAnalyticsModule extends KrollModule
{
	private static TiAppCenterAnalyticsModule instance;

	private Map<String, AnalyticsTransmissionTarget> mTransmissionTargets = new HashMap<>();

	public TiAppCenterAnalyticsModule()
	{
		super();
		instance = this;
	}

	public static TiAppCenterAnalyticsModule getInstance()
	{
		return instance;
	}

	// Methods
	@Override
	@Kroll.method
	public String getApiName()
	{
		return "TiAppCenterAnalytics";
	}

	@Kroll.method
	public void setEnabled(boolean enabled, final KrollPromise promise)
	{
		Analytics.setEnabled(enabled).thenAccept(new AppCenterConsumer<Void>() {

			@Override
			public void accept(Void result)
			{
				promise.resolve(result);
			}
		});
	}

	@Kroll.method
	public void isEnabled(final KrollPromise promise)
	{
		Analytics.isEnabled().thenAccept(new AppCenterConsumer<Boolean>() {

			@Override
			public void accept(Boolean enabled)
			{
				promise.resolve(enabled);
			}
		});
	}

	@Kroll.method
	public void trackEvent(String eventName, KrollDict properties, KrollPromise promise)
	{
		try {
			Analytics.trackEvent(eventName, TiAppCenterUtils.convertReadableMapToStringMap(properties));
		} catch (JSONException e) {
			AppCenterLog.error(LOG_TAG, "Could not convert event properties from JavaScript to Java", e);
		}
		promise.resolve(null);
	}

	@Kroll.method
	public void trackTransmissionTargetEvent(String eventName, KrollDict properties, String targetToken,
											 KrollPromise promise)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			try {
				transmissionTarget.trackEvent(eventName, TiAppCenterUtils.convertReadableMapToStringMap(properties));
			} catch (JSONException e) {
				AppCenterLog.error(LOG_TAG, "Could not convert event properties from JavaScript to Java", e);
			}
		}
		promise.resolve(null);
	}

	@Kroll.method
	public void getTransmissionTarget(String targetToken, KrollPromise promise)
	{
		AnalyticsTransmissionTarget transmissionTarget = Analytics.getTransmissionTarget(targetToken);
		if (transmissionTarget == null) {
			promise.resolve(null);
			return;
		}
		mTransmissionTargets.put(targetToken, transmissionTarget);
		promise.resolve(targetToken);
	}

	@Kroll.method
	public void isTransmissionTargetEnabled(String targetToken, final KrollPromise promise)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget == null) {
			promise.resolve(null);
			return;
		}
		transmissionTarget.isEnabledAsync().thenAccept(new AppCenterConsumer<Boolean>() {

			@Override
			public void accept(Boolean enabled)
			{
				promise.resolve(enabled);
			}
		});
	}

	@Kroll.method
	public void setTransmissionTargetEnabled(boolean enabled, String targetToken, final KrollPromise promise)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget == null) {
			promise.resolve(null);
			return;
		}
		transmissionTarget.setEnabledAsync(enabled).thenAccept(new AppCenterConsumer<Void>() {

			@Override
			public void accept(Void result)
			{
				promise.resolve(result);
			}
		});
	}

	@Kroll.method
	public void setTransmissionTargetEventProperty(String propertyKey, String propertyValue, String targetToken,
												   KrollPromise promise)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			PropertyConfigurator configurator = transmissionTarget.getPropertyConfigurator();
			configurator.setEventProperty(propertyKey, propertyValue);
		}
		promise.resolve(null);
	}

	@Kroll.method
	public void removeTransmissionTargetEventProperty(String propertyKey, String targetToken, KrollPromise promise)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			PropertyConfigurator configurator = transmissionTarget.getPropertyConfigurator();
			configurator.removeEventProperty(propertyKey);
		}
		promise.resolve(null);
	}

	@Kroll.method
	public void collectTransmissionTargetDeviceId(String targetToken, KrollPromise promise)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			PropertyConfigurator configurator = transmissionTarget.getPropertyConfigurator();
			configurator.collectDeviceId();
		}
		promise.resolve(null);
	}

	@Kroll.method
	public void getChildTransmissionTarget(String childToken, String parentToken, KrollPromise promise)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(parentToken);
		if (transmissionTarget == null) {
			promise.resolve(null);
			return;
		}
		AnalyticsTransmissionTarget childTarget = transmissionTarget.getTransmissionTarget(childToken);
		if (childTarget == null) {
			promise.resolve(null);
			return;
		}
		mTransmissionTargets.put(childToken, childTarget);
		promise.resolve(childToken);
	}

	@Kroll.method
	public void setTransmissionTargetAppName(String appName, String targetToken, KrollPromise promise)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			PropertyConfigurator configurator = transmissionTarget.getPropertyConfigurator();
			configurator.setAppName(appName);
		}
		promise.resolve(null);
	}

	@Kroll.method
	public void setTransmissionTargetAppVersion(String appVersion, String targetToken, KrollPromise promise)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			PropertyConfigurator configurator = transmissionTarget.getPropertyConfigurator();
			configurator.setAppVersion(appVersion);
		}
		promise.resolve(null);
	}

	@Kroll.method
	public void setTransmissionTargetAppLocale(String appLocale, String targetToken, KrollPromise promise)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			PropertyConfigurator configurator = transmissionTarget.getPropertyConfigurator();
			configurator.setAppLocale(appLocale);
		}
		promise.resolve(null);
	}
}
