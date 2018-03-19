<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.driver.*" %>
<%@ page import="oracle.sql.*" %>
<%@ page import="oracle.jdbc.driver.OracleDriver"%>
<%@ page import="javax.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.net.ssl.HostnameVerifier" %>
<%@ page import="javax.net.ssl.HttpsURLConnection" %>
<%@ page import="javax.net.ssl.SSLSession" %>
<!DOCTYPE html>
<html>
<head>
  <script type="text/javascript" src="../js/jquery-2.2.4.js"></script>
  <link rel="stylesheet" type="text/css" href="../css/bootstrap.min.css">
  <script src="../js/bootstrap.min.js"></script>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Offer Created!!</title>
</head>
<body>
  <div class="container">
    <form action="welcome.jsp" method="post">
      <h2>Offer Created!</h2>

<%
  InitialContext ctx;
  DataSource ds;
  Connection conn;
  Statement st;
  ResultSet rs;
  int i = 0;
  int points = 0;
  int offer = 0;
  int nextid = 0;
  int prodid = 0;
  String prodname = "";
  String offername = request.getParameter("offername");
  String offmsg = request.getParameter("offmsg");
  int reqpoint = Integer.parseInt(request.getParameter("offer"));
  String mysql = "";
  String mcssql = "";
  String annoy = "";
  String mbeid = "";
  String mcsiddom = "";
  String apiname  = "";
  String appkey   = "";
  String senderid = "";
  String mcs="";

  try {
    // created DB connection
    ctx = new InitialContext();
    ds = (DataSource) ctx.lookup("jdbc/loyaltyDS");
    conn = ds.getConnection();
    st = conn.createStatement();
    // get the last offer ID
    rs = st.executeQuery("SELECT MAX(ID) AS THELAST FROM OFFERS");
    while (rs.next()) {
      // and increment the ID by 1
      nextid = rs.getInt("THELAST") + 1;
    }
    // get the product ID of the offer
    prodname = request.getParameter("product");
    rs = st.executeQuery("SELECT ID AS PRODID FROM PRODUCT WHERE PRODUCTNAME='" + prodname + "'");
    while (rs.next())
    {
      prodid = rs.getInt("PRODID");
    }
    // get the offer crrteria (points required) from submit form
    offer = Integer.parseInt(request.getParameter("offer"));
    // prepare the SQL statement to update DB
    mysql = "insert into offers (ID,OFFERNAME,POINTS,MESSAGE,PRODUCTID) values (" + nextid + ", '" + offername + "', ";
    mysql = mysql + reqpoint + ", '" + offmsg + "', " + prodid + ")";
    st.executeUpdate(mysql);
    // the next statement is for debug only
    // out.println(mysql);
    out.println("<br><br> ");
    out.println("<div style=\"background:#ffeeee; padding:5px\">");
    out.print("Offer #" + nextid + " for " + offername + "has been created!!");
    out.println("</div>");
    // before close the DB
    //    We should retrieve ALL userid for the offer is related to - to send PUSH
    //
    // PLACE HOLDER of SQL code to get all userids
    //
    // Getting MCS info to send PUSH
    //
    mcssql = "select ID,ANNOY,MBEID,MCSIDDOM,APINAME,APPKEY,SENDERID from settinz where ID=1";
    rs = st.executeQuery(mcssql);
    while (rs.next())
    {
      annoy = rs.getString("ANNOY").trim();
      mbeid = rs.getString("MBEID").trim();
      mcsiddom = rs.getString("MCSIDDOM").trim();
      apiname  = rs.getString("APINAME").trim();
      appkey   = rs.getString("APPKEY").trim();
      senderid = rs.getString("SENDERID").trim();
    }

    // close the DB first
    st.close();
	conn.close();
    // This is the most tricky party
    //
    // To send notification to MCS
    //
    // first - becase of SSL/TLS, we will create a NuLL HNV
    HostnameVerifier hostnameVerifier = new HostnameVerifier() {
    @Override
      public boolean verify(String hostname, SSLSession session) {
        return true;
      }
    };

    // This is the actual MCS URL
    //    it is composed with parameters in DB
    // https://mcs-{your-mcs-identity-domain}.mobileenv.us2.oraclecloud.com:443/mobile/custom/LoyaltyManagementAPI/offer/notify
    mcs = mcsiddom + "/mobile/custom/" + apiname + "/offer/notify";
    //
    URL obj = new URL(null, mcs, new sun.net.www.protocol.https.Handler());
    HttpsURLConnection con = (HttpsURLConnection) obj.openConnection();
    con.setHostnameVerifier(hostnameVerifier);
    con.setRequestMethod("POST");
    // This is the MCS MBE
    //   which is retrieve from DB
    con.setRequestProperty("Oracle-Mobile-Backend-ID",mbeid);
    // This is the anonymouse key
    //   which is retrieve from DB
    con.setRequestProperty("Authorization","Basic " + annoy);
    //
    con.setRequestProperty("Content-Type","application/json");
    con.setDoOutput(true);
    // This is the JSON payload of the push notification
    //
    // PLACE HOLDER to create the JSON payload
    //
    String POST_PARAMS = "{\"message\": \"" + offmsg + "\", ";
      POST_PARAMS = POST_PARAMS + "\"offerid\": " + nextid + "}";
    //
    //
    // sending the POSOT request to MCS
    OutputStream os = con.getOutputStream();
		os.write(POST_PARAMS.getBytes());
		os.flush();
		os.close();
		int responseCode = con.getResponseCode();
    // the next statement is for debug ONLY
		// System.out.println("POST Response Code :: " + responseCode);
    //
    // checking response from MCS
		if (responseCode == HttpsURLConnection.HTTP_CREATED) { //success
			BufferedReader in = new BufferedReader(new InputStreamReader(
				con.getInputStream()));
			String inputLine;
			StringBuffer responsemcs = new StringBuffer();
			while ((inputLine = in.readLine()) != null) {
				responsemcs.append(inputLine);
			}
			in.close();
			// print result
      out.println("<br />");
      out.println("<br /> ");
      out.println("<div style=\"background:#eeffee; padding:5px\">");
      out.println(mcs + "<br/>");
      out.print(responsemcs.toString());
      out.println("</div>");
		} else {
      out.println("<br />");
      out.println("");
      out.println("<div style=\"background:#eeffee; padding:5px\">");
      out.print("PUSH Notification hit error - " + responseCode);
      out.println("<br/>MCS is not ready yet.");
      out.println("</div>");
		}
  } catch (Exception e)
  {
    out.println("<br />");
    out.println("<br><br> ");
    out.println("<div style=\"background:#eeffee; padding:5px\">");
    out.println("Exception : " + e.getMessage() + "");
    out.println("<br/><br/>Please contact administrator");
    out.println("<br>" + mcs + "<br>");
    out.println("</div>");
  }
%>
<!-- back to HTML markup -->
    <br/> <br/><br/>
    <div class="form-group col-xs-8">
    <label for="offer" class="control-label col-xs-4">Offer Criteria:</label>
    <input type="text" name="offer" value='<%=request.getParameter("offer")%>' readonly/><br/>

    <label for="target" class="control-label col-xs-4"># of Target Customers:</label>
    <!-- this value should be calculated previously -->
    <input type="text" name="target" value="xx" readonly/>
    <br></br>
    <button type="button" class="btn btn-primary  btn-md" onclick="location.href = 'welcome.jsp';">Goto Main Page</button>

    </div>
  </form>
</body>
</html>
