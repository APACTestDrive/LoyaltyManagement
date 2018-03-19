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
  <title>Save Push Notification Settings</title>
</head>
<body>
  <div class="container">
    <form action="welcome.jsp" method="post">
      <h2>Save Push Notification Settings</h2>

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
  String mcsiddom = request.getParameter("mcsiddom");
  String mbeid = request.getParameter("mbeid");
  String annoy = request.getParameter("annoy");
  String apiname = request.getParameter("apiname");
  String mysql = "";
  String mcssql = "";
  String appkey   = "";
  String senderid = "";

  try {
    // created DB connection
    ctx = new InitialContext();
    ds = (DataSource) ctx.lookup("jdbc/loyaltyDS");
    conn = ds.getConnection();
    st = conn.createStatement();
    // get the last offer ID
    mcssql = "UPDATE settinz SET ANNOY = \'" + annoy + "\', MBEID =\'" + mbeid + "\', MCSIDDOM = \'" + mcsiddom;
    mcssql = mcssql + "\', APINAME = \'" + apiname + "\' WHERE ID=1";

    st.executeUpdate(mcssql);

    // close the DB first
    st.close();
	conn.close();
    // This is the most tricky party
    //
    // To send notification to MCS
    //
    // first - becase of SSL/TLS, we will create a NuLL HNV

  } catch (Exception e)
  {
    out.println("<br />");
    out.println("<br><br> ");
    out.println("<div style=\"background:#eeffee; padding:5px\">");
    out.println("Exception : " + e.getMessage() + "");
    out.println("<br/><br/>Please contact administrator");
    out.println("<br>" + mcssql + "<br> ");
    out.println("</div>");
  }
%>
<!-- back to HTML markup -->
    <br/> <br/><br/>

    MCS Push Notification Setting SAVED!
    <br></br>
    <button type="button" class="btn btn-primary  btn-md" onclick="location.href = 'welcome.jsp';">Goto Main Page</button>

    </div>
  </form>
</body>
</html>
