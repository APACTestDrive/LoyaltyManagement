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
  <script src="../js/bootstrap.min.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <link rel="stylesheet" type="text/css" href="../css/bootstrap.min.css">
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Push Notificaton Configuration</title>
</head>
<body>
  <div class="container">
    <form action="mbeconfirm.jsp" method="post">
      <h2>Push Notification Configuration</h2>

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
  String mysql = "";
  String mcssql = "";
  String annoy = "";
  String mbeid = "";
  String mcsiddom = "";
  String apiname  = "";
  String appkey   = "";
  String senderid = "";

  try {
    // created DB connection
    ctx = new InitialContext();
    ds = (DataSource) ctx.lookup("jdbc/loyaltyDS");
    conn = ds.getConnection();
    st = conn.createStatement();

    // Getting Existing MCS info
    //
    mcssql = "select ID,ANNOY,MBEID,MCSIDDOM,APINAME,APPKEY,SENDERID from settinz where ID=1";
    rs = st.executeQuery(mcssql);
    while (rs.next())
    {
      annoy = rs.getString("ANNOY");
      mbeid = rs.getString("MBEID");
      mcsiddom = rs.getString("MCSIDDOM");
      apiname  = rs.getString("APINAME");
      appkey   = rs.getString("APPKEY");
      senderid = rs.getString("SENDERID");
    }
    //
    // close the DB first
    st.close();
	conn.close();
    } catch (Exception e)
    {
    // not a very good practice to print out error in webpage....
    // should actually put in weblogic console or error log
    // to-be added to the to-do lust
      out.println("Exception : " + e.getMessage() + "");
    }

    //
    // display the form for editing
%>
<!-- back to HTML markup -->
    <br/> <br/><br/>
    <div class="form-group col-xs-8">
      <label for="mcsiddom" class="control-label col-xs-4">MCS Base URL:</label>
      <input type="text" name="mcsiddom" value='<%=mcsiddom%>' size=60/>
      <br></br>
      <label for="mbeid" class="control-label col-xs-4">Mobile Backend ID:</label>
      <input type="text" name="mbeid" value="<%=mbeid%>" size=60 />
      <br></br>
      <label for="annoy" class="control-label col-xs-4">MCS Annoymous Key:</label>
      <input type="text" name="annoy" value="<%=annoy%>" size=60 />
      <br></br>
      <label for="APINAME" class="control-label col-xs-4">Custom API Name:</label>
      <input type="text" name="apiname" value="<%=apiname%>" size=30/>
      <br></br>



    <!-- this value should be calculated previously -->
      <br></br>
    <button type="button" class="btn btn-primary  btn-md" onclick="location.href = 'welcome.jsp';">cancel</button>
    <button type="submit" class="btn btn-primary  btn-md">SAVE</button>
    </div>
  </form>
</body>
</html>
