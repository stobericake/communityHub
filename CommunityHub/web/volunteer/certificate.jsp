<<<<<<< Updated upstream
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="com.cm.model.task" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.hub.controller.dbconnection" %>

=======
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%
    String user = (String) session.getAttribute("userRole");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String evName = (String) request.getAttribute("eventName");
    Date evDate = (Date) request.getAttribute("eventDate");
    String eventDescription = (String) request.getAttribute("eventDescription");
    String beneficiaryName = (String) request.getAttribute("beneficiaryName");
    String volunteerName = (String) request.getAttribute("volunteerName");

    SimpleDateFormat outFormat = new SimpleDateFormat("MMMM dd, yyyy");
    String formatDate = outFormat.format(evDate);

%>
>>>>>>> Stashed changes
<!DOCTYPE html>
<html>
    <head>
        <title>Certificate of Achievement</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@300;400;600&family=Dancing+Script:wght@700&display=swap');

            body {
                background: linear-gradient(135deg, #f6f8fb 0%, #e9f0f7 100%);
                font-family: 'Montserrat', sans-serif;
            }

            .certificate-container {
                min-height: 100vh;
            }

            .certificate {
                background: white;
                position: relative;
                overflow: hidden;
                box-shadow: 0 1rem 3rem rgba(47, 102, 144, 0.15);
                border-radius: 15px;
                background-image: 
                    radial-gradient(circle at 10% 10%, rgba(47, 102, 144, 0.05) 0%, transparent 50%),
                    radial-gradient(circle at 90% 90%, rgba(47, 102, 144, 0.05) 0%, transparent 50%);
                border: 1px solid rgba(47, 102, 144, 0.1);
                max-width: 800px; /* Added max-width */
                margin: 0 auto; /* Center the certificate */
            }
<<<<<<< Updated upstream
        }
        
    </style>
</head>
<body>
   <%     
    String eventID = request.getParameter("eventID");
    String volunteerID = (String) session.getAttribute("volunteer");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    if (eventID != null && !eventID.isEmpty()) {
        try {
            conn = dbconnection.getConnection();
            String sql = "SELECT e.name, e.date, e.time, e.duration, " +
                         "e.description, b.name, v.name " +
                         "FROM events e " +
                         "INNER JOIN beneficiary b ON e.beneficiaryID = b.beneficiaryID " +
                         "INNER JOIN volunteer v ON v.volunteerID = ? " +
                         "WHERE e.eventID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, volunteerID);
            stmt.setString(2, eventID);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String eventName = rs.getString("e.name");
                Date eventDate = rs.getDate("e.date");
                Time eventTime = rs.getTime("e.time");
                Time eventDuration = rs.getTime("e.duration");
                String description = rs.getString("e.description");
                String beneficiaryName = rs.getString("b.name");
                String volunteerName = rs.getString("v.name");

            // Convert java.sql.Date to java.util.Date
                java.util.Date utilEventDate = new java.util.Date(eventDate.getTime());

                // Format eventStartDate
                SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
                String formattedStartDate = dateFormat.format(utilEventDate);

                // Calculate and format endDate
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(utilEventDate);
                calendar.add(Calendar.DATE, 1); // Add 1 day
                String formattedEndDate = dateFormat.format(calendar.getTime());
%>
<div class="certificate-container d-flex align-items-center justify-content-center p-3">
    <div class="certificate container p-4 my-4">
        <div class="top-wave"></div>
        <i class="badge-icon fas fa-award"></i>
        
        <!-- Header -->
        <div class="text-center mb-4 position-relative">
            <div class="company-logo">
                <i class="fas fa-hands-helping"></i>
            </div>
            <h6 class="text-uppercase mb-2 fw-light">BY CommUNITYHub</h6>
            <h1 class="certificate-title mb-0">Certificate</h1>
            <p class="text-uppercase">of Appreciation</p>
        </div>
        
        <!-- Content -->
        <div class="text-center mb-3">
            <h5 class="text-uppercase mb-2 fw-light">Presented To</h5>
            <h2 class="recipient-name mb-3"><%= volunteerName %></h2>
            
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <p class="description mb-2">
                        In recognition of your outstanding contributions as a volunteer during the event <b><%= eventName %></b>, 
                        held on <b><%= formattedStartDate %></b>, your dedication and hard work played a vital role in ensuring the success of this event. 
                        Your efforts have left a lasting positive impact on our community and all those who attended.
                    </p>
                    <p class="certificate-date">
                        <i class="far fa-calendar-alt me-2"></i>
                        Awarded on <%= formattedEndDate %>
                    </p>
                </div>
            </div>
        </div>
        
        <!-- Signatures -->
            <div class="row justify-content-center mt-2 pt-2">
                <div class="col-5 col-md-4 text-center">
                </div>
                <div class="col-5 col-md-4 text-center">
                    <div class="signature-text"><%= beneficiaryName %></div>
                    <div class="signature-line"></div>
                    <p class="mb-0"><%= beneficiaryName %></p>
                    <p class="signature-title">Manager</p>
                </div>
            </div>

        <div class="seal">
            <i class="fas fa-certificate"></i>
        </div>
        
        <div class="bottom-chevron"></div>

        <div class="text-center certificate-footer mt-4"></div>
    </div>
</div>
<% 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
=======

            .top-wave {
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 80px; /* Reduced from 100px */
                background: linear-gradient(45deg, #2F6690, #3a7ca5);
                clip-path: polygon(0 0, 100% 0, 100% 100%, 0 70%);
                opacity: 0.9;
            }

            .certificate::before {
                content: '';
                position: absolute;
                top: 15px; /* Reduced from 20px */
                left: 15px; /* Reduced from 20px */
                right: 15px; /* Reduced from 20px */
                bottom: 15px; /* Reduced from 20px */
                border: 2px solid rgba(47, 102, 144, 0.1);
                border-radius: 10px;
                pointer-events: none;
            }

            .bottom-chevron {
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 200px; /* Reduced from 250px */
                height: 100px; /* Reduced from 120px */
                background: linear-gradient(45deg, #2F6690, #3a7ca5);
                clip-path: polygon(0 100%, 100% 100%, 50% 0);
                opacity: 0.9;
            }

            .certificate-title {
                font-family: 'Playfair Display', serif;
                color: #2F6690;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 2px;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
                font-size: 2.5rem; /* Reduced font size */
            }

            .recipient-name {
                font-family: 'Playfair Display', serif;
                font-style: italic;
                color: #2d3436;
                border-bottom: 2px solid rgba(47, 102, 144, 0.3);
                display: inline-block;
                padding-bottom: 5px;
                font-size: 1.8rem; /* Reduced font size */
            }

            .signature-line {
                width: 100%;
                height: 2px;
                background: linear-gradient(90deg, transparent, rgba(47, 102, 144, 0.3) 50%, transparent);
                margin-bottom: 0.5rem;
                position: sticky;
            }

            .badge-icon {
                position: absolute;
                top: 15px; /* Reduced from 20px */
                right: 15px; /* Reduced from 20px */
                color: #2F6690;
                font-size: 20px; /* Reduced from 24px */
                opacity: 0.8;
            }

            .company-logo {
                font-size: 32px; /* Reduced from 40px */
                color: black;
                margin-bottom: 15px; /* Reduced from 20px */
            }

            .certificate-date {
                font-size: 0.85rem; /* Reduced from 0.9rem */
                color: #6c757d;
                font-weight: 300;
            }

            .description {
                line-height: 1.6; /* Reduced from 1.8 */
                color: #4a4a4a;
                font-size: 0.9rem; /* Added smaller font size */
            }

            .signature-title {
                font-size: 0.75rem; /* Reduced from 0.8rem */
                color: #6c757d;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .certificate-footer {
                font-size: 0.75rem; /* Reduced from 0.8rem */
                color: #6c757d;
                position: relative;
                z-index: 1;
            }

            .seal {
                position: absolute;
                bottom: 80px; /* Reduced from 100px */
                right: 40px; /* Reduced from 50px */
                width: 100px; /* Reduced from 120px */
                height: 100px; /* Reduced from 120px */
                border: 2px solid rgba(255, 165, 0, 0.6);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                opacity: 0.8;
                transform: rotate(-15deg);
            }

            .seal i {
                color: #FFA500 !important;
                font-size: 32px; /* Reduced from 40px */
            }

            .signature-text {
                font-family: 'Dancing Script', cursive;
                font-size: 1.5rem; /* Reduced from 1.8rem */
                color: #2F6690;
                margin-bottom: 0.5rem;
                display: block;
                transform: translateY(15px); /* Reduced from 20px */
            }

            @media (max-width: 768px) {
                .seal {
                    width: 40px;
                    height: 40px;
                    bottom: 40px;
                    right: 15px;
                }
                .certificate {
                    padding: 1rem !important;
                }
            }
        </style>
    </head>
    <body>
        <div class="certificate-container d-flex align-items-center justify-content-center p-3">
            <div class="certificate container p-4 my-4">
                <div class="top-wave"></div>
                <i class="badge-icon fas fa-award"></i>

                <!-- Header -->
                <div class="text-center mb-4 position-relative">
                    <div class="company-logo">
                        <i class="fas fa-hands-helping"></i>
                    </div>
                    <h6 class="text-uppercase mb-2 fw-light"><%= evName%></h6>
                    <h1 class="certificate-title mb-0">Certificate</h1>
                    <p class="text-uppercase">of Achievement</p>
                </div>

                <!-- Content -->
                <div class="text-center mb-3">
                    <h5 class="text-uppercase mb-3 fw-light">Presented To</h5>
                    <h2 class="recipient-name mb-3"><%= volunteerName%></h2>

                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <p class="description mb-3">
                                In recognition of your outstanding contributions as a volunteer during the <%= evName%>, 
                                your dedication and hard work played a vital role in ensuring the success of this event. 
                                Your efforts have left a lasting positive impact on our community and all those who attended.
                            </p>
                            <p class="certificate-date">
                                <i class="far fa-calendar-alt me-2"></i>
                                Awarded on <%= formatDate %>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Signatures -->
                <div class="row justify-content-center mt-4 pt-4">
                    <div class="col-5 col-md-4 text-center">

                    </div>
                    <div class="col-5 col-md-4 text-center">
                        <div class="signature-text"><%= beneficiaryName%></div>
                        <div class="signature-line"></div>
                        <p class="mb-0"><%= beneficiaryName%></p>
                        <p class="signature-title">Manager</p>
                    </div>
                </div>

                <div class="seal">
                    <i class="fas fa-certificate"></i>
                </div>

                <div class="bottom-chevron"></div>

                <div class="text-center certificate-footer mt-4"></div>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
    </body>
>>>>>>> Stashed changes
</html>