package com.samsung;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.application.IApplicationInstance;
import com.wowza.wms.client.IClient;
import com.wowza.wms.module.ModuleBase;
import com.wowza.wms.request.RequestFunction;
import com.wowza.wms.rtp.model.RTPSession;
import com.wowza.wms.stream.IMediaStream;

public class WebServerCommunication extends ModuleBase {
	// short to make params length smaller than 128 characters
	private static final String TAG_DEVICE_ID = "device_id";
	private static final String TAG_DEVICE_ID_SHORT = "did";
	private static final String TAG_IP_ADDRESS = "address";
	private static final String TAG_CHANNEL_NAME = "channel_name";
	private static final String TAG_CHANNEL_NAME_SHORT = "cn";
	private static final String TAG_DEVICE_NAME = "device_name";
	private static final String TAG_DEVICE_NAME_SHORT = "dn";
	private static final String TAG_REMEMBER_TOKEN = "remember_token";
	private static final String TAG_REMEMBER_TOKEN_SHORT = "t";
	private static final String TAG_BITRATE = "bitrate";
	private static final String TAG_STATUS = "status";
	private static final String WEB_SERVER_ADDRESS = "http://192.168.1.19:3000/api/v1/";

	public void onAppStart(IApplicationInstance appInstance) {
		String fullname = appInstance.getApplication().getName() + "/"
				+ appInstance.getName();
		getLogger().info("onAppStart: " + fullname);
	}

	public void onConnect(IClient client, RequestFunction function,
			AMFDataList params) {
		// After authenticated, read the extra attributes from params then call
		// API to register channel
		getLogger().warn("onConnect2:");
		registerDeviceRTMP(client);

	}

	/**
	 * @param client
	 */
	private void registerDeviceRTMP(IClient client) {
		String queryStr = client.getQueryStr();
		// Those attributes get from query string
		String device_id = getParamFromQuerySring(queryStr, TAG_DEVICE_ID_SHORT);
		String channel_name = getParamFromQuerySring(queryStr,
				TAG_CHANNEL_NAME_SHORT);
		String device_name = getParamFromQuerySring(queryStr,
				TAG_DEVICE_NAME_SHORT);
		String remember_token = getParamFromQuerySring(queryStr,
				TAG_REMEMBER_TOKEN_SHORT);
		// The other get from client object
		String ip_address = client.getIp();
		int bitrate = 500; // TODO: Fix later

		// Create params to send
		List<NameValuePair> httpParams = new ArrayList<NameValuePair>();
		httpParams.add(new BasicNameValuePair(TAG_DEVICE_ID, device_id));
		httpParams.add(new BasicNameValuePair(TAG_DEVICE_NAME, device_name));
		httpParams.add(new BasicNameValuePair(TAG_CHANNEL_NAME, channel_name));
		httpParams.add(new BasicNameValuePair(TAG_IP_ADDRESS, ip_address));
		httpParams.add(new BasicNameValuePair(TAG_BITRATE, Integer
				.toString(bitrate)));
		httpParams.add(new BasicNameValuePair(TAG_REMEMBER_TOKEN,
				remember_token));
		httpParams.add(new BasicNameValuePair(TAG_STATUS, "0")); // 0 : online
		callApi("/register", httpParams);
	}
	
	private void registerDeviceRTSP(RTPSession session) {
		String queryStr = session.getQueryStr();
		// Those attributes get from query string
		String device_id = getParamFromQuerySring(queryStr, TAG_DEVICE_ID_SHORT);
		String channel_name = getParamFromQuerySring(queryStr,
				TAG_CHANNEL_NAME_SHORT);
		String device_name = getParamFromQuerySring(queryStr,
				TAG_DEVICE_NAME_SHORT);
		String remember_token = getParamFromQuerySring(queryStr,
				TAG_REMEMBER_TOKEN_SHORT);
		// The other get from client object
		String ip_address = session.getIp();
		int bitrate = 500; // TODO: Fix later

		// Create params to send
		List<NameValuePair> httpParams = new ArrayList<NameValuePair>();
		httpParams.add(new BasicNameValuePair(TAG_DEVICE_ID, device_id));
		httpParams.add(new BasicNameValuePair(TAG_DEVICE_NAME, device_name));
		httpParams.add(new BasicNameValuePair(TAG_CHANNEL_NAME, channel_name));
		httpParams.add(new BasicNameValuePair(TAG_IP_ADDRESS, ip_address));
		httpParams.add(new BasicNameValuePair(TAG_BITRATE, Integer
				.toString(bitrate)));
		httpParams.add(new BasicNameValuePair(TAG_REMEMBER_TOKEN,
				remember_token));
		httpParams.add(new BasicNameValuePair(TAG_STATUS, "0")); // 0 : online
		callApi("/register", httpParams);
	}

	private String getParamFromQuerySring(String queryStr, String key) {
		String[] params = queryStr.split("&");
		for (String string : params) {
			String[] pair = string.split("=");
			if ((pair.length > 1) & pair[0].equals(key))
				return pair[1];
		}
		return null;
	}

	public static HttpResponse callApi(String url, List<NameValuePair> params) {
		HttpResponse httpResponse;
		HttpClient httpClient = new DefaultHttpClient();
		HttpPost httpPost = new HttpPost(WEB_SERVER_ADDRESS + url);
		try {
			httpPost.setEntity(new UrlEncodedFormEntity(params));
			httpResponse = httpClient.execute(httpPost);
			return httpResponse;
		} catch (ClientProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	public void onConnectAccept(IClient client) {
		getLogger().info("onConnectAccept: " + client.getClientId());
	}

	public void onConnectReject(IClient client) {
		getLogger().info("onConnectReject: " + client.getClientId());
	}

	public void onDisconnect(IClient client) {
		getLogger().info("onDisconnect: " + client.getClientId());
		getLogger().warn("onDisconnect1: " + client.getQueryStr());
		sendOfflineSignalRTMP(client);

	}

	public void onStreamCreate(IMediaStream stream) {
		getLogger().warn("onStreamCreate1: " + stream.getSrc());
		IClient client = stream.getClient();
		if (client == null) {
			IApplicationInstance appInstance = stream.getStreams()
					.getAppInstance();
		} else {
			String s = stream.getClient().getQueryStr();
			getLogger().warn(s);
		}

	}

	public void onStreamDestroy(IMediaStream stream) {
		getLogger().warn("onStreamDestroy1: " + stream.getSrc());
	}

	public void onRTPSessionCreate(RTPSession rtpSession) {
		registerDeviceRTSP(rtpSession);
	}

	public void onRTPSessionDestroy(RTPSession rtpSession) {		
		getLogger().info("onRTPSessionDestroy: " + rtpSession.getSessionId());
		sendOfflineSignalRTSP(rtpSession);
	}

	private void sendOfflineSignalRTMP(IClient client) {
		String queryStr = client.getQueryStr();
		List<NameValuePair> httpParams = new ArrayList<NameValuePair>();
		String token = getParamFromQuerySring(queryStr,
				TAG_REMEMBER_TOKEN_SHORT);
		String device_id = getParamFromQuerySring(queryStr, TAG_DEVICE_ID_SHORT);
		httpParams.add(new BasicNameValuePair(TAG_REMEMBER_TOKEN, token));
		httpParams.add(new BasicNameValuePair(TAG_DEVICE_ID, device_id));
		httpParams.add(new BasicNameValuePair(TAG_STATUS, "1")); // 1: offline
		callApi("/register", httpParams);
	}
	
	private void sendOfflineSignalRTSP(RTPSession session) {
		String queryStr = session.getQueryStr();
		List<NameValuePair> httpParams = new ArrayList<NameValuePair>();
		String token = getParamFromQuerySring(queryStr,
				TAG_REMEMBER_TOKEN_SHORT);
		String device_id = getParamFromQuerySring(queryStr, TAG_DEVICE_ID_SHORT);
		httpParams.add(new BasicNameValuePair(TAG_REMEMBER_TOKEN, token));
		httpParams.add(new BasicNameValuePair(TAG_DEVICE_ID, device_id));
		httpParams.add(new BasicNameValuePair(TAG_STATUS, "1")); // 1: offline
		callApi("/register", httpParams);
	}

}
