<!DOCTYPE html><%@ include file="header.jspf" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Process Error</title>
        <style>
            .rounded-card {
                border-radius: 30px; 
                background-color: #fff; 
                box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.2); 
            }
            .error-icon {
                font-size: 6rem; 
                color: #dc3545; 
            }
            .icon-circle {
                background-color: white; 
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                width: 120px;
                height: 120px;
                margin: 0 auto; 
            }

            .btn-home:hover {
                background-color: black; 
                color: white; 
            }
            .btn-home {
                background-color: #e9ecef; 
                color: #212529; 
                border-radius: 30px;
                padding: 10px 30px;
                font-weight: bold;
                width: 100%; 
                max-width: 250px; 
            }
            .top-divider {
                bottom: 10px;
            }
            .bottom-divider {
                top: 14px;
            }
            .divider-bottom {
                position: relative;
                left: 50%;
                transform: translateX(-50%);
                width: 100px;
                height: 4px;
                background-color: grey;
                border-radius: 8px;
            }
            .divider-top {
                position: relative;
                left: 50%;
                transform: translateX(-50%);
                width: 40px;
                height: 4px;
                background-color: #e9ecef;
                border-radius: 8px;
            }
        </style>
    </head>
    <body class="d-flex justify-content-center align-items-center vh-100">
        <%
            String h = "listGuestEvent.do";
            String role = (String) session.getAttribute("userRole");
            if (role != null) {
                // Redirect based on the user role
                if (role.equals("volunteer")) {
                    h = "vEventList.do";
                } else if (role.equals("admin")) {
                    h = "adminList.do";
                } else if (role.equals("beneficiary")) {
                    h = "listEventMgmt.do";
                }
            }

            String message = request.getParameter("msg");
        %>
        <div class="container text-center rounded-card p-4 w-25">
            <div class="divider-top top-divider"></div>
            <div class="d-flex flex-column align-items-center">
                <div class="icon-circle mb-4">
                    <i class="bi bi-x-circle-fill error-icon"></i>
                </div>
                <p class="fw-bold fs-4">Process Failed</p>
                <% if (message != null && !message.isEmpty()) {%>
                <p class="text-muted">Message: <strong><%= message%></strong></p>
                <% } else { %>
                <p class="text-muted">The process encountered an error.</p>
                <% }%>
            </div>
            <div class="mt-4">
                <a href=<%= h%> class="btn btn-home">Home</a>
            </div>
            <div class="divider-bottom bottom-divider"></div>
        </div>
    </body>
</html>
