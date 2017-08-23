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
  <script src="../js/bootstrap.min.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <link rel="stylesheet" type="text/css" href="../css/bootstrap.min.css">
  <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Welcome to Loyalty Manager</title>
  <style>
    #errmsg {
        color: red
    }
  </style>
  <script>
    function checkform(itemx) {
      if (document.search.target.value == "${result}" ) {
        $( "#dialog" ).dialog( "open" );
          return false;
        } else {
          document.search.product.value=itemx;
          document.search.submit();
        }
    }
  </script>
  <script>
    $( function() {
      $( "#dialog" ).dialog({
        autoOpen: false,
        modal: true,
        show: {
          effect: "blind",
          duration: 500
        },
        hide: {
          effect: "blind",
          duration: 500
        }
      });
    });
  </script>
  <script>
    $(document).ready(function () {
      // validate of the points input - only numbers can be entered
      // called when key is pressed in textbox
      $("#offer").keypress(function (e) {
        // if the letter is not digit then display error and don't type anything
        if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
          //display error message
          $("#errmsg").html("Digits Only").show().fadeOut("slow");
          return false;
        }
      });
    });
  </script>
</head>
<body>
  <!-- this is the pop-up dialog to remind user need to do search before proceed -->
  <div id="dialog" title="Warning">Please enter the offer criteria and click search befor proceed. Criteria must be a positive integer.</div>
  <div class="container">
      <!-- we actually have 2 forms in this page, first one is for search -->
      <form name="search" action="custsearch.jsp" method="post">
        <h2>Welcome to the Loyalty Manager !!!!</h2>
        <br></br>
        <div class="form-group col-xs-8">
          <label for="offer" class="control-label col-xs-4">Input Offer Criteria:</label>
          <input type="text" name="offer" id="offer" required="true"/>
          <button type="submit" class="btn btn-primary  btn-md">Search</button>&nbsp;&nbsp; <span id="errmsg"></span>
          <br></br>
          <label for="target" class="control-label col-xs-4"># of Target Customers:</label>
          <input type="text" name="target" disabled="disabled" value="${result}"/>
          <input type="hidden" name="product" value="Aroma Beans"/>
        </div>
      </form>
      <!-- the 2nd form is for create offer AFTER search -->
      <form name="coffer" action="createoffer.jsp" method="post">
        <div class="form-group col-xs-8">
            <br></br>
            <label for="target" class="control-label col-xs-4">Target Product:</label>
            <select name="item" onchange="javascript:document.search.product.value=document.coffer.item.value;return true;">
            <!-- let's switch to JSP and do DB select to get the products -->
<%
    // I'm not the original author... yes, we have lots of variables
    InitialContext ctx;
    DataSource ds;
    Connection conn;
    Statement st;
    ResultSet rs;
    String prod;
    // let's try getting DB connection
    try {
      ctx = new InitialContext();
      ds = (DataSource) ctx.lookup("jdbc/loyaltyDS");
      conn = ds.getConnection();
      st = conn.createStatement();
      rs = st.executeQuery("SELECT * FROM PRODUCT");
      // and we will loop all products and put them in HTML form listbox
      while(rs.next())
      {
        prod = rs.getString("PRODUCTNAME");
        // this one is to generate the HTML tag and print out the product
        out.println("<option value=\"" + prod + "\">" + prod + "</option>");
      }
      // always remember close DB connection
      st.close();
    } catch (Exception e)
    {
      // not a very good practice to print out error in webpage....
      // should actually put in weblogic console or error log
      // to-be added to the to-do lust
      out.println("Exception : " + e.getMessage() + "");
    }
%>
            <!-- switching back from JSP to HTML markup -->
            </select>
            <br></br>
            <br></br>
            <!-- clear button will do RESET and also clean up value of 1st from -->
            <button type="reset" class="btn btn-primary  btn-md" onclick="document.search.offer.value='';return true;">Clear</button>
            <!-- submit button will call checkform() function to handle data validation -->
            <button type="button" class="btn btn-primary  btn-md" onclick="return checkform(document.coffer.item.value)">Next</button>
        </div>

      </form>
      <div class="form-group col-xs-8">
        <br/><br/><br/>
        <font size="1">&nbsp;&nbsp;&nbsp;[ <a href="config.jsp">Configure Push Notification</a> ]</font>
      </div>
  </div>
</body>
</html>
