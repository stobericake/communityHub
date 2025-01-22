<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
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

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        .table-dark th {
           background-color: #2F6690 !important;
        }
                
        .donation-card {
            width: 100%;
            border: 1px solid #e6e6f2;
            border-radius: 5px;
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
                      
        .view-details-button {
            background-color: #C3DFE6;
            border-radius: 5px;
            border: none;
            color: black;
            text-align: center;
            text-decoration: none;
            display: inline-block;
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
        /* Pagination styles */
            .pagination {
                justify-content: center;
            }

            .pagination .page-link {
                color: #2F6690;
                border-radius: 50%; 
                width: 40px;     
                height: 40px;       
                display: flex;     
                justify-content: center;
                align-items: center;
                border: 1px solid #2F6690; 
                margin: 0 5px;    
            }

            .pagination .page-item.active .page-link {
                background-color: #2F6690;
                border-color: #2F6690;
                color: #C3DFE6;
            }

            .pagination-container {
                display: flex;
                justify-content: center;
                margin-top: 20px;
            }

            .page-header {
                font-weight: bold;
                font-size: 1.5rem;
            }

            .page-subheader {
                font-size: 1.0rem;
                color: #6c757d;
            }
    </style>
</head>
<body>
    <%@ include file="../header.jspf" %>
    <div class="container my-4">
        <div class="row align-items-center mb-4">
            <div class="col-md-4">
                    <h1 class="page-header">DONATION HISTORY</h1>
                    <h6 class="page-subheader">The tables below show all the donation you have made</h6>

                </div>

            <div class="col-md-4 offset-md-4">
                <input type="text" id="searchInput" class="form-control rounded"
                    placeholder="Search by any field..." onkeyup="filterTable()"><br>
            </div>
         </div>
        <div class="container">
        <div class="center-card">
            <div class="donation-card mb-3">
                <%
                    List<events> events = (List) request.getAttribute("eventList");
                    List<donation> donations = (List) request.getAttribute("donationList");
                    double totalDonation = Double.parseDouble(request.getAttribute("totalDonation").toString());
                    double latestDonation = Double.parseDouble(request.getAttribute("latestDonation").toString());
                    int totalDonations = Integer.parseInt(request.getAttribute("totalDonations").toString());
                    int totalPages = Integer.parseInt(request.getAttribute("totalPages").toString());
                    int currentPage = Integer.parseInt(request.getAttribute("currentPage").toString());

                    int volunteerId = Integer.parseInt(request.getSession().getAttribute("volunteer").toString());
                    DecimalFormat df = new DecimalFormat("#.00");
                    String totalDon = df.format(totalDonation);
                    String latestDon = df.format(latestDonation);
                %>
                <!-- Total Donation Section -->
                <div class="donation-section">
                    <div class="donation-icon">
                        <i class="bi bi-bank2"></i>
                    </div>
                    <div>
                        <p class="donation-amount">RM<%= totalDon %></p>
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
                        <p class="donation-amount">RM<%= latestDon %></p>
                        <p class="donation-text">Latest Donation</p>
                    </div>
                </div>
            </div>
        </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-striped" id="eventTable" >
                <thead class="table-dark">
                    <tr>
                        <th scope="col" width="25%">Events</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th scope="col" width="15%" class="text-center">View Receipt</th>
                  </tr>
                </thead>
                <tbody>
            <%
                for (int i = 0; i < events.size(); i++) {
                    events event = events.get(i);
                    donation donation = donations.get(i);  
                    String formattedDate = new SimpleDateFormat("dd/MM/yyyy").format(donation.getDate());
                    String amount = df.format(donation.getAmount());
            %>
                <tr>
                    <td class="fw-medium"><%= event.getName() %></td>
                    <td><%= formattedDate %></td>
                    <td>RM<%=  amount %></td>
                    <td class="text-center">
                        <button class="view-details-button" data-bs-toggle="modal" data-bs-target="#receiptOverlay">
                        <i class="bi bi-receipt-cutoff"></i>
                        </button>
                    </td>
                </tr>
            </table>
                
                
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
    <script>
    function filterTable() {
                const input = document.getElementById('searchInput').value.toLowerCase();
                const rows = document.querySelectorAll('#eventTable tbody tr');

                rows.forEach(row => {
                    const cells = Array.from(row.querySelectorAll('td'));
                    const match = cells.some(cell => cell.textContent.toLowerCase().includes(input));
                    row.style.display = match ? '' : 'none';
                });
            }
</script>   
</body>
</html>
