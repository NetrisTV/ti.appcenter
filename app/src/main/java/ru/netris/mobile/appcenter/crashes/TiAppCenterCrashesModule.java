package ru.netris.mobile.appcenter.crashes;

import android.util.Base64;

import com.microsoft.appcenter.crashes.AbstractCrashesListener;
import com.microsoft.appcenter.crashes.Crashes;
import com.microsoft.appcenter.crashes.WrapperSdkExceptionManager;
import com.microsoft.appcenter.crashes.ingestion.models.ErrorAttachmentLog;
import com.microsoft.appcenter.crashes.model.ErrorReport;
import com.microsoft.appcenter.utils.async.AppCenterConsumer;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.util.TiConvert;

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedList;

import ru.netris.mobile.appcenter.TiAppcenterModule;
import ru.netris.mobile.appcenter.utils.TiAppCenterUtils;

@Kroll.module(name = "Crashes")
public class TiAppCenterCrashesModule extends KrollModule
{

	private static final String DATA_FIELD = "data";
	private static final String TEXT_FIELD = "text";
	private static final String FILE_NAME_FIELD = "fileName";
	private static final String CONTENT_TYPE_FIELD = "contentType";

	/**
	 * Constant for DO NOT SEND crash report.
	 */
	@Kroll.constant
	private static final int DONT_SEND = 0;

	/**
	 * Constant for SEND crash report.
	 */
	@Kroll.constant
	private static final int SEND = 1;

	/**
	 * Constant for ALWAYS SEND crash reports.
	 */
	@Kroll.constant
	private static final int ALWAYS_SEND = 2;

	private AbstractCrashesListener customListener = new AbstractCrashesListener() {
		// TODO: implement methods
	};

	public TiAppCenterCrashesModule()
	{
		super();
		Crashes.setListener(customListener);
	}

	// Methods
	@Kroll.method
	public void start(String secret)
	{
		if (TiAppcenterModule.isStarted()) {
			return;
		}
		TiAppcenterModule.startCrashes(secret);
	}

	@Kroll.method
	@Override
	public String getApiName()
	{
		return "TitaniumAppCenterCrashes";
	}

	@Kroll.method
	public void lastSessionCrashReport(final KrollFunction callback)
	{
		Crashes.getLastSessionCrashReport().thenAccept(new AppCenterConsumer<ErrorReport>() {

			@Override
			public void accept(ErrorReport errorReport)
			{
				Object[] args = new Object[] {
					errorReport != null ? TiAppCenterUtils.convertErrorReportToWritableMapOrEmpty(errorReport) : null
				};
				callback.call(getKrollObject(), args);
			}
		});
	}

	@Kroll.method
	public void hasCrashedInLastSession(final KrollFunction callback)
	{
		Crashes.hasCrashedInLastSession().thenAccept(new AppCenterConsumer<Boolean>() {

			@Override
			public void accept(Boolean hasCrashed)
			{
				Object[] args = new Object[] { hasCrashed };
				callback.call(getKrollObject(), args);
			}
		});
	}

	@Kroll.method
	public void setEnabled(boolean enabled, final KrollFunction callback)
	{
		Crashes.setEnabled(enabled).thenAccept(new AppCenterConsumer<Void>() {

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
		Crashes.isEnabled().thenAccept(new AppCenterConsumer<Boolean>() {

			@Override
			public void accept(Boolean enabled)
			{
				Object[] args = new Object[] { enabled };
				callback.call(getKrollObject(), args);
			}
		});
	}

	@Kroll.method
	public void generateTestCrash(final KrollFunction callback)
	{
		new Thread(new Runnable() {

			@Override
			public void run()
			{
				Crashes.generateTestCrash();
				Object[] args = new Object[] { null };
				callback.call(getKrollObject(), args);
			}
		})
			.start();
	}

	@Kroll.method
	public void notifyWithUserConfirmation(int userConfirmation)
	{

		/* Translate JS constant to Android. Android uses different order of enum than JS/iOS/.NET. */
		switch (userConfirmation) {

			case DONT_SEND:
				userConfirmation = Crashes.DONT_SEND;
				break;

			case SEND:
				userConfirmation = Crashes.SEND;
				break;

			case ALWAYS_SEND:
				userConfirmation = Crashes.ALWAYS_SEND;
				break;
		}

		/* Pass translated value, if not translated, native SDK should check the value itself for error. */
		Crashes.notifyUserConfirmation(userConfirmation);
	}

	@Kroll.method
	public void getUnprocessedCrashReports(final KrollFunction callback)
	{
		WrapperSdkExceptionManager.getUnprocessedErrorReports().thenAccept(
			new AppCenterConsumer<Collection<ErrorReport>>() {

				@Override
				public void accept(Collection<ErrorReport> errorReports)
				{
					Object[] args =
						new Object[] { TiAppCenterUtils.convertErrorReportsToWritableArrayOrEmpty(errorReports) };
					callback.call(getKrollObject(), args);
				}
			});
	}

	@Kroll.method
	public void sendCrashReportsOrAwaitUserConfirmationForFilteredIds(Object[] filteredReportIds,
																	  final KrollFunction callback)
	{
		int size = filteredReportIds.length;
		Collection<String> filteredReportIdsAsList = new ArrayList<>(size);
		for (Object filteredReportId : filteredReportIds) {
			filteredReportIdsAsList.add(TiConvert.toString(filteredReportId));
		}
		WrapperSdkExceptionManager.sendCrashReportsOrAwaitUserConfirmation(filteredReportIdsAsList)
			.thenAccept(new AppCenterConsumer<Boolean>() {

				@Override
				public void accept(Boolean alwaysSend)
				{
					Object[] args = new Object[] { alwaysSend };
					callback.call(getKrollObject(), args);
				}
			});
	}

	@Kroll.method
	public void sendErrorAttachments(KrollDict[] attachments, String errorId)
	{
		try {
			Collection<ErrorAttachmentLog> attachmentLogs = new LinkedList<>();
			for (KrollDict jsAttachment : attachments) {
				String fileName = null;
				if (jsAttachment.containsKeyAndNotNull(FILE_NAME_FIELD)) {
					fileName = jsAttachment.getString(FILE_NAME_FIELD);
				}
				if (jsAttachment.containsKeyAndNotNull(TEXT_FIELD)) {
					String text = jsAttachment.getString(TEXT_FIELD);
					attachmentLogs.add(ErrorAttachmentLog.attachmentWithText(text, fileName));
				} else {
					String encodedData = jsAttachment.getString(DATA_FIELD);
					byte[] data = Base64.decode(encodedData, Base64.DEFAULT);
					String contentType = jsAttachment.getString(CONTENT_TYPE_FIELD);
					attachmentLogs.add(ErrorAttachmentLog.attachmentWithBinary(data, fileName, contentType));
				}
			}
			WrapperSdkExceptionManager.sendErrorAttachments(errorId, attachmentLogs);
		} catch (Exception e) {
			TiAppCenterUtils.logError("Failed to get error attachment for report: " + errorId);
			TiAppCenterUtils.logError(android.util.Log.getStackTraceString(e));
		}
	}
}
