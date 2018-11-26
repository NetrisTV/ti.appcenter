package ru.netris.mobile.appcenter.utils;

import com.microsoft.appcenter.crashes.model.ErrorReport;
import com.microsoft.appcenter.ingestion.models.Device;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.common.Log;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONStringer;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class TiAppCenterUtils
{
	private static final String TAG = "TiAppCenterUtils";

	public static void logError(String message)
	{
		Log.e(TAG, message);
	}

	public static void logInfo(String message)
	{
		Log.i(TAG, message);
	}

	public static void logDebug(String message)
	{
		Log.d(TAG, message);
	}

	static KrollDict convertErrorReportToWritableMap(ErrorReport errorReport) throws JSONException
	{
		if (errorReport == null) {
			return new KrollDict();
		}
		KrollDict errorReportMap = new KrollDict();
		errorReportMap.put("id", errorReport.getId());
		errorReportMap.put("threadName", errorReport.getThreadName());
		errorReportMap.put("appErrorTime", "" + errorReport.getAppErrorTime().getTime());
		errorReportMap.put("appStartTime", "" + errorReport.getAppStartTime().getTime());
		errorReportMap.put("exception", android.util.Log.getStackTraceString(errorReport.getThrowable()));
		//noinspection ThrowableResultOfMethodCallIgnored
		errorReportMap.put("exceptionReason", errorReport.getThrowable().getMessage());

		/* Convert device info. */
		Device deviceInfo = errorReport.getDevice();
		KrollDict deviceInfoMap;
		if (deviceInfo != null) {
			JSONStringer jsonStringer = new JSONStringer();
			jsonStringer.object();
			deviceInfo.write(jsonStringer);
			jsonStringer.endObject();
			JSONObject deviceInfoJson = new JSONObject(jsonStringer.toString());
			deviceInfoMap = (KrollDict) KrollDict.fromJSON(deviceInfoJson);
		} else {

			/* TODO investigate why this can be null. */
			deviceInfoMap = new KrollDict();
		}
		errorReportMap.put("device", deviceInfoMap);
		return errorReportMap;
	}

	private static KrollDict[] convertErrorReportsToWritableArray(Collection<ErrorReport> errorReports)
		throws JSONException
	{
		KrollDict[] errorReportsArray = new KrollDict[errorReports.size()];

		int i = 0;
		for (ErrorReport report : errorReports) {
			errorReportsArray[i++] = convertErrorReportToWritableMap(report);
		}

		return errorReportsArray;
	}

	public static KrollDict[] convertErrorReportsToWritableArrayOrEmpty(Collection<ErrorReport> errorReports)
	{
		try {
			return convertErrorReportsToWritableArray(errorReports);
		} catch (JSONException e) {
			logError("Unable to serialize crash reports");
			logError(android.util.Log.getStackTraceString(e));
			return new KrollDict[0];
		}
	}

	public static KrollDict convertErrorReportToWritableMapOrEmpty(ErrorReport errorReport)
	{
		try {
			return convertErrorReportToWritableMap(errorReport);
		} catch (JSONException e) {
			logError("Unable to serialize crash report");
			logError(android.util.Log.getStackTraceString(e));
			return new KrollDict();
		}
	}

	public static Map<String, String> convertReadableMapToStringMap(KrollDict map) throws JSONException {
		Map<String, String> stringMap = new HashMap<>();
		for (String key : map.keySet()) {
			Object value = map.get(key);
			// Only support storing strings. Non-string data must be stringified in JS.
			if (value instanceof String) {
				stringMap.put(key, map.getString(key));
			}
		}

		return stringMap;
	}
}
