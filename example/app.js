const AppCenter = require('ru.netris.mobile.appcenter');
const {Crashes, Analytics} = AppCenter;

const win = Ti.UI.createWindow({
	title: 'appcenter test',
	layout: 'vertical',
	backgroundColor: '#fff'
});

const btn1 = Ti.UI.createButton({
	top: 20,
	title: 'generate test crash'
});
btn1.addEventListener('click', event => {
	const title = event.source.title;
	console.log(`${event.type}: ${title}`);
	Crashes.generateTestCrash(result => {
		alert(`${title}: ${JSON.stringify(result)}`);
	});
});
win.add(btn1);

const btn2 = Ti.UI.createButton({
	title: 'is "Crashes" enabled'
});
btn2.addEventListener('click', event => {
	const title = event.source.title;
	console.log(`${event.type}: ${title}`);
	Crashes.isEnabled(result => {
		alert(`${title}: ${JSON.stringify(result)}`);
	});
});
win.add(btn2);

const btn3 = Ti.UI.createButton({
	title: 'enable "Crashes"'
});
btn3.addEventListener('click', event => {
	const title = event.source.title;
	console.log(`${event.type}: ${title}`);
	Crashes.setEnabled(true, result => {
		alert(`${title}: ${JSON.stringify(result)}`);
	});
});
win.add(btn3);

const btn4 = Ti.UI.createButton({
	title: 'disable "Crashes"'
});
btn4.addEventListener('click', event => {
	const title = event.source.title;
	console.log(`${event.type}: ${title}`);
	Crashes.setEnabled(false, result => {
		alert(`${title}: ${JSON.stringify(result)}`);
	});
});
win.add(btn4);

let btn5 = Ti.UI.createButton({
	title: 'get Unprocessed Crash Reports'
});
btn5.addEventListener('click', event => {
	const title = event.source.title;
	console.log(`${event.type}: ${title}`);
	Crashes.getUnprocessedCrashReports(result => {
		alert(`${title}: ${JSON.stringify(result)}`);
	});
});
win.add(btn5);

const btn6 = Ti.UI.createButton({
	title: 'is "Analytics" enabled'
});
btn6.addEventListener('click', event => {
	const title = event.source.title;
	console.log(`${event.type}: ${title}`);
	Analytics.isEnabled(result => {
		alert(`${title}: ${JSON.stringify(result)}`);
	});
});
win.add(btn6);

const btn7 = Ti.UI.createButton({
	title: 'enable "Analytics"'
});
btn7.addEventListener('click', event => {
	const title = event.source.title;
	console.log(`${event.type}: ${title}`);
	Analytics.setEnabled(true, result => {
		alert(`${title}: ${JSON.stringify(result)}`);
	});
});
win.add(btn7);

const btn8 = Ti.UI.createButton({
	title: 'disable "Analytics"'
});
btn8.addEventListener('click', event => {
	const title = event.source.title;
	console.log(`${event.type}: ${title}`);
	Analytics.setEnabled(false, result => {
		alert(`${title}: ${JSON.stringify(result)}`);
	});
});
win.add(btn8);

let btn9 = Ti.UI.createButton({
	title: 'track event'
});
btn9.addEventListener('click', event => {
	const title = event.source.title;
	console.log(`${event.type}: ${title}`);
	Analytics.isEnabled(result => {
		alert(`Analytics.isEnabled: ${result}`);
		if (result) {
			Analytics.trackEvent('Video clicked', {
				Category: 'Music',
				FileName: 'favorite.avi'
			}, result => {
				alert(`${title}: ${JSON.stringify(result)}`);
			});
		}
	});
});
win.add(btn9);
win.open();
