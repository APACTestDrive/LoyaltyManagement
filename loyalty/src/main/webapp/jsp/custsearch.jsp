<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.driver.*" %>
<%@ page import="oracle.sql.*" %>
<%@ page import="oracle.jdbc.driver.OracleDriver"%>
<%@ page import="javax.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.naming.*" %>
<!DOCTYPE html>
<html>
<head>
  <script type="text/javascript" src="../js/jquery-2.2.4.js"></script>
  <link rel="stylesheet" type="text/css" href="../css/bootstrap.min.css">
  <script src="../js/bootstrap.min.js"></script>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Create Offer</title>
</head>
<body>
<!-- let's switch to JSP code -->
<%
  // again, don't ask why we have this variables
  InitialContext ctx;
  DataSource ds;
  Connection conn;
  Statement st;
  ResultSet rs;
  int i = 0;
  int points = 0;
  int offer = 0;
  // trying to get DB connection
  try {
    ctx = new InitialContext();
    ds = (DataSource) ctx.lookup("jdbc/loyaltyDS");
    conn = ds.getConnection();
    st = conn.createStatement();
    // this is the offer criteria posted from welcome.jsp
    offer = Integer.parseInt(request.getParameter("offer"));
    // check how many users got this criteria
    rs = st.executeQuery("SELECT count(ID) AS CNTID FROM CUSTOMER where POINTS >=" + offer);
    while(rs.next()) {
      i = rs.getInt("CNTID");
    }
    // again, we should close DB connection
    st.close();
	conn.close();
  } catch (Exception e)
  { // same as welcome.jsp - to-do to put error message to backend
    out.println("Exception : " + e.getMessage() + "");
  }
%>
<!-- switching back to HTNL -->
  <div class="container">
    <form action="createoffer.jsp" method="post">
      <h2>Welcome to the Loyalty Manager !! </h2>
      Please confirm criteria and product<br />
      <br />
      <div class="form-group col-xs-8">
        <label for="offer" class="control-label col-xs-4">Input Offer Criteria:</label>
        <input type="text" name="offer" value='<%=request.getParameter("offer")%>' readonly/>
        <button type="button" class="btn btn-primary  btn-md" disabled="disabled">Search</button>
        <br></br>
        <label for="target" class="control-label col-xs-4"># of Target Customers:</label>
        <input type="text" name="target" value="<%=i%>" readonly/>
        <br></br>
        <label for="prevtarget" class="control-lable col-xs-4">Target Product:</label>
        <input type="text" name="targetx" disabled="disabled" value='<%=request.getParameter("product")%>'  /><br/>
        <label for="target" class="control-label col-xs-4">Confirm or choose another:</label>
        <select name="item">
        <!-- switching to JSP -->
<%
  // do DB query to pull out the product list
  String prod;
  try {
    ctx = new InitialContext();
    ds = (DataSource) ctx.lookup("jdbc/loyaltyDS");
    conn = ds.getConnection();
    st = conn.createStatement();
    rs = st.executeQuery("SELECT * FROM PRODUCT");
    String submitstr = (String)request.getParameter("product");
    while(rs.next())
    {
      prod = rs.getString("PRODUCTNAME").trim();
      out.print("<option value=\"" + prod + "\"");
      if ( prod.equals(submitstr) ) {
        out.print(" SELECTED");
      }
      out.println(">" + prod + "</option>");
    }
    st.close();
	conn.close();
  } catch (Exception e)
  {
    out.println("Exception : " + e.getMessage() + "");
  }
%>
        </select>
        <br></br>
        <br></br>
        <button type="button" class="btn btn-primary  btn-md" onclick="location.href = 'welcome.jsp';">Go Back</button>
        <button type="submit" class="btn btn-primary  btn-md" >Next</button>
      </div>
    </form>
  </div>
</body>
</html>
