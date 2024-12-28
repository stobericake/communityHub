<%-- 
    Document   : donaionHistory
    Created on : Dec 15, 2024, 1:41:38 AM
    Author     : Rina
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

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
    </style>
</head>
<body>
    <%@ include file="../header.jspf" %>
    <div class="container">
    <header>
        <h2 text-align: left>Donation History</h2>        
    </header>
        <div class="container">
            <div class="center-card">
        <div class="donation-card">
            <!-- Total Donation Section -->
            <div class="donation-section">
                <div class="donation-icon">
                    <i class="bi bi-bank2"></i>
                </div>
                <div>
                    <p class="donation-amount">RM2,300</p>
                    <p class="donation-text">Total Donation</p>
                </div>
            </div>
            
            <!-- Divider -->
            <div class="divider"></div>
            
            <!-- Latest Donation Section -->
            <div class="donation-section">
                <div class="donation-icon latest">
                    <i class="bi bi-receipt"></i>
                </div>
                <div>
                    <p class="donation-amount">RM100</p>
                    <p class="donation-text">Latest Donation</p>
                </div>
            </div>
        </div>
                </div>
      </div>
        <div class="container">
        <ul class="list-group">
            <li class="list-group-item d-flex justify-content-between align-items-center" style="background-color: #2F6690;; color: white;">
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
            <li class="list-group-item d-flex justify-content-between align-items-center">
            <table class="event-table">
               <tr>
                    <td>1.</td>
                    <td>Gotong Royong (Chendering)</td>
                    <td>05/12/2023 - 04:42PM</td>
                    <td>RM100</td>
                    <td><button class="view-details-button">View Receipt</button></td>
                </tr>
               </table>
            </li>
            <li class="list-group-item d-flex justify-content-between align-items-center">
              <table class="event-table">
                    <td>2.</td>
                    <td>Event Program (Kuala Terengganu)</td>
                    <td>05/12/2023 - 04:42PM</td>
                    <td>RM700</td>
                    <td><button class="view-details-button">View Receipt</button></td>
                </tr>
              </table>
            </li>
            <li class="list-group-item d-flex justify-content-between align-items-center">
              <table class="event-table">
                    <td>3.</td>
                    <td>Recyling Program (Batu Buruk)</td>
                    <td>05/12/2023 - 04:42PM</td>
                    <td>RM800</td>
                    <td><button class="view-details-button">View Receipt</button></td>
                </tr>
              </table>
            </li>
            <li class="list-group-item d-flex justify-content-between align-items-center">
              <table class="event-table">
                    <td>4.</td>
                    <td>Gotong Royong (Marang)</td>
                    <td>05/12/2023 - 04:42PM</td>
                    <td>RM500</td>
                    <td><button class="view-details-button">View Receipt</button></td>
                </tr>
              </table>
            </li><li class="list-group-item d-flex justify-content-between align-items-center">
              <table class="event-table">
                    <td>5.</td>
                    <td>Cloth Donation (Chendering)</td>
                    <td>05/12/2023 - 04:42PM</td>
                    <td>RM200</td>
                    <td><button class="view-details-button">View Receipt</button></td>
                </tr>
              </table>
            </li>
            
            </ul>
</div>
    <!-- Font Awesome Icons -->
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    <!-- Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
