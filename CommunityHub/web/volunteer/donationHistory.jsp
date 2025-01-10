<%@page import="com.cm.model.donation"%>
<%@page import="com.cm.model.events"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donation Card</title>
    <!-- Bootstrap CSS -->
    <link
      rel="stylesheet"
      href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
    />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f8f9fa;
            }
        .container {
                margin: auto;
                padding: 10px;
            }
        header {
                display: flex;
                justify-content: space-between;
                align-items: center;
               
            }

            header h1, header h2 {
                font-family: 'Poppins', sans-serif;
                margin: 0;
            }
            
            
        .donation-card {
            width: 1000px;
            border: 1px solid #e6e6f2;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 30px;
            display: flex;
            justify-content: space-around;
            align-items: center;
        }
        
        .center-card {
            display: flex;
            justify-content: center; /* Center horizontally */
        align-items: center; /* Center vertically */
        }


        .donation-section {
            display: flex;
            align-items: center;
        }

        .donation-icon {
            width: 50px;
            height: 50px;
            background-color: #d5fbe7;
            display: flex;
            justify-content: center;
            align-items: center;
            border-radius: 50%;
            margin-right: 15px;
        }

        .donation-icon.latest {
            background-color: #e2e8ff;
        }

        .icon {
            font-size: 20px;
            color: #026839;
        }

        .icon.latest {
            color: #2f55d4;
        }

        .donation-amount {
            font-family: 'Poppins', sans-serif;
            font-weight: bold;
            font-size: 1.5rem;
            margin: 0;
        }

        .donation-text {
            margin: 0;
            color: #6c757d;
            font-size: 0.9rem;
            font-family: 'Poppins', sans-serif;
        }

        .divider {
            height: 50px;
            width: 1px;
            background-color: #ccc;
        }
        .event-table {
            width: 100%;
            border-collapse: collapse;
            font-family: 'Poppins', sans-serif;
        }

        .event-table th, .event-table td {
            text-align: left;
        }
            
        /* Define fixed column widths */
        .event-table th:nth-child(1),
        .event-table td:nth-child(1) {
            width: 5%; /* First column is 10% */
        }

        .event-table th:nth-child(2),
        .event-table td:nth-child(2) {
            width: 40%; /* Second column is 30% */
        }

        .event-table th:nth-child(3),
        .event-table td:nth-child(3) {
            width: 20%; /* Third column is 20% */
        }

        .event-table th:nth-child(4),
        .event-table td:nth-child(4) {
            width: 15%; /* Fourth column is 20% */
        }

        .event-table th:nth-child(5),
        .event-table td:nth-child(5) {
            width: 15%; /* Fifth column is 20% */
        }
                      
        .view-details-button {
            background-color: #C3DFE6;
            border-radius: 15px;
            border: none;
            color: black;
            padding: 10px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            }
        .modal-dialog {
            max-width: none;
            width: auto;
            height: auto;
            display: inline-block;
        }

        .modal-content {
            background-color: #fff;
            padding: 0;
            border: none;
        }

        .modal-header, .modal-footer {
            border: none;
        }

        .receipt-content {
            text-align: center;
        }

        .modal-img {
            max-width: 100%;
            max-height: 80vh; /* Adjust height to prevent overflow */
            object-fit: contain;
        }

        .print-button {
            background-color: #000;
            color: #fff;
            border-radius: 30px;
        }
        .pagination {
            justify-content: center;
        }

            .pagination .page-link {
                color: #2F6690;
                border-radius: 50%; /* Makes the button circular */
                width: 40px;        /* Fixed width for circular shape */
                height: 40px;       /* Fixed height for circular shape */
                display: flex;      /* Center the content inside */
                justify-content: center;
                align-items: center;
                border: 1px solid #2F6690; /* Add border for clarity */
                margin: 0 5px;     /* Add spacing between buttons */
            }
            .pagination .page-item.active .page-link {
                background-color: #2F6690;
                border-color: #2F6690;
                color: #C3DFE6;
            }
            </style>
</head>
<body>
    <%@ include file="../header.jspf" %>
    <div class="container">
        <header>
            <h2>Donation History</h2>        
        </header>
        <div class="container">
        <div class="center-card">
            <div class="donation-card">
                <%
                    List<events> events = (List) request.getAttribute("eventList");
                    List<donation> donations = (List) request.getAttribute("donationList");
                    double totalDonation = Double.parseDouble(request.getAttribute("totalDonation").toString());
                    double latestDonation = Double.parseDouble(request.getAttribute("latestDonation").toString());
                    int totalDonations = Integer.parseInt(request.getAttribute("totalDonations").toString());
                    int totalPages = Integer.parseInt(request.getAttribute("totalPages").toString());
                    int currentPage = Integer.parseInt(request.getAttribute("currentPage").toString());

                    int volunteerId = Integer.parseInt(request.getSession().getAttribute("volunteer").toString());
                    
                %>
                <!-- Total Donation Section -->
                <div class="donation-section">
                    <div class="donation-icon">
                        <i class="bi bi-bank2"></i>
                    </div>
                    <div>
                        <p class="donation-amount">RM<%= totalDonation %></p>
                        <p class="donation-text">Total Donation</p>
                    </div>
                </div>
                <div class="divider"></div>
                <!-- Latest Donation Section -->
                <div class="donation-section">
                    <div class="donation-icon latest">
                        <i class="bi bi-receipt"></i>
                    </div>
                    <div>
                        <p class="donation-amount">RM<%= latestDonation %></p>
                        <p class="donation-text">Latest Donation</p>
                    </div>
                </div>
            </div>
        </div>
        </div>
        <div class="container">
        <ul class="list-group">
            <li class="list-group-item d-flex justify-content-between align-items-center" style="background-color: #2F6690; color: white;">
                <table class="event-table">
                    <tr>
                        <th>No.</th>
                        <th>Events</th>
                        <th>Date & Time</th>
                        <th>Amount</th>
                        <th>View Receipts</th>
                    </tr>
                </table>
            </li>
            <%
                for (int i = 0; i < events.size(); i++) {
                    events event = events.get(i);
                    donation donation = donations.get(i);      
            %>
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    <table class="event-table">
                        <tr>
                            <td><%= i %>.</td>
                            <td><%= event.getName() %></td>
                            <td><%= donation.getDate() %></td>
                            <td>RM<%=  donation.getAmount() %></td>
                            <td><button class="view-details-button" data-bs-toggle="modal" data-bs-target="#receiptOverlay">View Receipt</button></td>
                        </tr>
                    </table>
                </li>
                
                <!-- Fullscreen Overlay -->
               <div class="modal fade" id="receiptOverlay" tabindex="-1" aria-labelledby="receiptOverlayLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="receiptOverlayLabel">Receipt</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <!-- Wrap the certificate content with a specific class -->
                            <div class="receipt-content">
                                <img src="getImage.do?type=donation&id=<%= donation.getDonationID() %>" class="modal-img">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </ul>
       </div>
        <!-- Pagination -->
        <div class="col-12">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage - 1 %>" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>

                    <% for (int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= currentPage == i ? "active" : "" %>">
                            <a class="page-link" href="?page=<%= i %>"><%= i %></a>
                        </li>
                    <% } %>

                    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage + 1 %>" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
                           
</body>
</html>
