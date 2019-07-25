package ru.netris.mobile.appcenter.analytics;

import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.analytics.AnalyticsTransmissionTarget;
import com.microsoft.appcenter.analytics.PropertyConfigurator;
import com.microsoft.appcenter.utils.AppCenterLog;
import com.microsoft.appcenter.utils.async.AppCenterConsumer;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollModule;
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
	public void setEnabled(boolean enabled, final KrollFunction callback)
	{
		Analytics.setEnabled(enabled).thenAccept(new AppCenterConsumer<Void>() {

			@Override
			public void accept(Void result)
			{
				Object[] args = new Object[] { result };
				callback.call(getKrollObject(), args);
			}
		});
	}

	@Kroll.method
	public void isEnabled(final KrollFunction callback)
	{
		Analytics.isEnabled().thenAccept(new AppCenterConsumer<Boolean>() {

			@Override
			public void accept(Boolean enabled)
			{
				Object[] args = new Object[] { enabled };
				callback.call(getKrollObject(), args);
			}
		});
	}

	@Kroll.method
	public void trackEvent(String eventName, KrollDict properties)
	{
		try {
			Analytics.trackEvent(eventName, TiAppCenterUtils.convertReadableMapToStringMap(properties));
		} catch (JSONException e) {
			AppCenterLog.error(LOG_TAG, "Could not convert event properties from JavaScript to Java", e);
		}
	}

	@Kroll.method
	public void trackTransmissionTargetEvent(String eventName, KrollDict properties, String targetToken)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			try {
				transmissionTarget.trackEvent(eventName, TiAppCenterUtils.convertReadableMapToStringMap(properties));
			} catch (JSONException e) {
				AppCenterLog.error(LOG_TAG, "Could not convert event properties from JavaScript to Java", e);
			}
		}
	}

	@Kroll.method
	public String getTransmissionTarget(String targetToken)
	{
		AnalyticsTransmissionTarget transmissionTarget = Analytics.getTransmissionTarget(targetToken);
		if (transmissionTarget == null) {
			return null;
		}
		mTransmissionTargets.put(targetToken, transmissionTarget);
		return targetToken;
	}

	@Kroll.method
	public void isTransmissionTargetEnabled(String targetToken, final KrollFunction callback)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget == null) {
			Object[] args = new Object[] { null };
			callback.call(getKrollObject(), args);
			return;
		}
		transmissionTarget.isEnabledAsync().thenAccept(new AppCenterConsumer<Boolean>() {

			@Override
			public void accept(Boolean enabled)
			{
				Object[] args = new Object[] { enabled };
				callback.call(getKrollObject(), args);
			}
		});
	}

	@Kroll.method
	public void setTransmissionTargetEnabled(boolean enabled, String targetToken, final KrollFunction callback)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget == null) {
			Object[] args = new Object[] { null };
			callback.call(getKrollObject(), args);
			return;
		}
		transmissionTarget.setEnabledAsync(enabled).thenAccept(new AppCenterConsumer<Void>() {

			@Override
			public void accept(Void result)
			{
				Object[] args = new Object[] { result };
				callback.call(getKrollObject(), args);
			}
		});
	}

	@Kroll.method
	public void setTransmissionTargetEventProperty(String propertyKey, String propertyValue, String targetToken)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			PropertyConfigurator configurator = transmissionTarget.getPropertyConfigurator();
			configurator.setEventProperty(propertyKey, propertyValue);
		}
	}

	@Kroll.method
	public void removeTransmissionTargetEventProperty(String propertyKey, String targetToken)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			PropertyConfigurator configurator = transmissionTarget.getPropertyConfigurator();
			configurator.removeEventProperty(propertyKey);
		}
	}

	@Kroll.method
	public void collectTransmissionTargetDeviceId(String targetToken)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			PropertyConfigurator configurator = transmissionTarget.getPropertyConfigurator();
			configurator.collectDeviceId();
		}
	}

	@Kroll.method
	public String getChildTransmissionTarget(String childToken, String parentToken)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(parentToken);
		if (transmissionTarget == null) {
			return null;
		}
		AnalyticsTransmissionTarget childTarget = transmissionTarget.getTransmissionTarget(childToken);
		if (childTarget == null) {
			return null;
		}
		mTransmissionTargets.put(childToken, childTarget);
		return childToken;
	}

	@Kroll.method
	public void setTransmissionTargetAppName(String appName, String targetToken)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			PropertyConfigurator configurator = transmissionTarget.getPropertyConfigurator();
			configurator.setAppName(appName);
		}
	}

	@Kroll.method
	public void setTransmissionTargetAppVersion(String appVersion, String targetToken)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			PropertyConfigurator configurator = transmissionTarget.getPropertyConfigurator();
			configurator.setAppVersion(appVersion);
		}
	}

	@Kroll.method
	public void setTransmissionTargetAppLocale(String appLocale, String targetToken)
	{
		AnalyticsTransmissionTarget transmissionTarget = mTransmissionTargets.get(targetToken);
		if (transmissionTarget != null) {
			PropertyConfigurator configurator = transmissionTarget.getPropertyConfigurator();
			configurator.setAppLocale(appLocale);
		}
	}
}
