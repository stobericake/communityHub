<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard</title>
        
         <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
        
    <style>
        html, body {
            margin: 0; /* Removes default margin */
            padding: 0; 
        } /* Removes default padding */
    </style>
    </head>
    <body>
        <%@ include file="header.jspf" %>
        <ul>
            <li><a href='homePage.jsp'>Display List</a></li>
            <li><a href='myEventList.jsp'>Display My Event List</a></li>
             <li><a href='insertData.jsp'>Display My Event List</a></li>
        </ul>
    </body>
</html>
