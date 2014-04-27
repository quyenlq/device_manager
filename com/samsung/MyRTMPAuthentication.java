package com.samsung;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.application.IApplicationInstance;
import com.wowza.wms.client.IClient;
import com.wowza.wms.module.ModuleBase;
import com.wowza.wms.request.RequestFunction;

public class MyRTMPAuthentication extends ModuleBase {

	public void onAppStart(IApplicationInstance appInstance) {
		String fullname = appInstance.getApplication().getName() + "/"
				+ appInstance.getName();
		getLogger().info("onAppStart: " + fullname);
		// preload the driver class
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
		} catch (Exception e) {
			getLogger().error(
					"Error loading: com.mysql.jdbc.Driver: " + e.toString());
		}
	}

	public void onAppStop(IApplicationInstance appInstance) {
		String fullname = appInstance.getApplication().getName() + "/"
				+ appInstance.getName();
		getLogger().info("onAppStop: " + fullname);
	}

	public void onConnect(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().warn("onConnect1: " + client.getClientId());
		String queryStr = client.getQueryStr();
		getLogger().warn("Query: " + queryStr);
		if (getParamFromQuerySring(queryStr, "remember_token") != null) {
			userAuthentication(client, queryStr);
		} else
			client.acceptConnection();
		getLogger().info("onConnect: " + client.getClientId());
	}

	/**
	 * @param client
	 * @param queryStr
	 */
	private void userAuthentication(IClient client, String queryStr) {
		Connection conn = null;
		try {
			conn = DriverManager
					.getConnection("jdbc:mysql://localhost/device_manager?user=root&password=");
			Statement stmt = null;
			ResultSet rs = null;
			try {
				stmt = conn.createStatement();
				rs = stmt
						.executeQuery("SELECT count(*) as userCount FROM users where username = '"
								+ getParamFromQuerySring(queryStr, "u")
								+ "' and remember_token = '"
								+ getParamFromQuerySring(queryStr, "t") + "'");
				if (rs.next() == true) {
					if (rs.getInt("userCount") > 0) {
						client.acceptConnection();
					} else {
						client.rejectConnection();
					}
				} else {
					client.rejectConnection();
				}
			} catch (SQLException sqlEx) {
				getLogger().error("sqlexecuteException: " + sqlEx.toString());
			} catch (NullPointerException e) {
				client.rejectConnection();

			} finally {
				// it is a good idea to release
				// resources in a finally{} block
				// in reverse-order of their creation
				// if they are no-longer needed
				if (rs != null) {
					try {
						rs.close();
					} catch (SQLException sqlEx) {
						rs = null;
					}
				}
				if (stmt != null) {
					try {
						stmt.close();
					} catch (SQLException sqlEx) {
						stmt = null;
					}
				}
			}
			conn.close();
		} catch (SQLException ex) {
			// handle any errors
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
		}
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

}