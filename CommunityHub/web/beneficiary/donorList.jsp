<%@page import="com.cm.model.events"%>
<%@page import="com.cm.model.donation"%>
<%@page import="com.cm.model.donor"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.hub.controller.dbconnection" %>

<!DOCTYPE html>
<html>
<head>
    <title>Donor List Overview</title>
    <style>
        .table-dark th {
            background-color: #2F6690 !important;
        }

        .page-header {
            font-weight: bold;
            font-size: 1.5rem;
        }

        .page-subheader {
            font-size: 1.0rem;
            color: #6c757d;
        }

        .search-bar input {
            border-radius: 20px;
            padding: 10px;
            width: 100%;
            max-width: 300px;
        }

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

        .section-spacing {
            margin-top: 20px;
        }

        .table-spacing {
            margin-top: 30px;
        }

        .header-spacing {
            margin-bottom: 15px;
        }
    </style>
    <script>
        function filterTable() {
            const input = document.getElementById('searchInput').value.toLowerCase();
            const rows = document.querySelectorAll('#donorTable tbody tr');

            rows.forEach(row => {
                const name = row.querySelector('td:nth-child(1)').textContent.toLowerCase();
                const contact = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                const amount = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                const event = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                const date = row.querySelector('td:nth-child(5)').textContent.toLowerCase();

                if (
                    name.includes(input) ||
                    contact.includes(input) ||
                    amount.includes(input) ||
                    event.includes(input) ||
                    date.includes(input)
                ) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
    </script>
</head>
<body>
    <%@ include file="../header.jspf" %>
    <div class="container my-4">
        <div class="row align-items-center mb-4">
            <div class="col-md-4">
                <h1 class="page-header">DONORS OVERVIEW</h1>
                <p class="page-subheader">Donors List</p>
            </div>

            <div class="col-md-4 offset-md-4">
                <input type="text" id="searchInput" class="form-control rounded" 
                       placeholder="Search by any field..." onkeyup="filterTable()">
            </div>
        </div>

        <% 
            List<donor> donorList = (List) request.getAttribute("donors");
            List<donation> donationList = (List) request.getAttribute("donations");
            List<events> eventList = (List) request.getAttribute("events");
            int totalPages = Integer.parseInt(request.getAttribute("totalPages").toString());
            int currentPage = Integer.parseInt(request.getAttribute("currentPage").toString());
            String searchName = (String) request.getAttribute("searchName");
            java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd-MM-yyyy");
            java.text.DecimalFormat amountFormat = new java.text.DecimalFormat("#,##0.00");
        %>

        <div class="table-spacing table-responsive">
            <table id="donorTable" class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Name</th>
                        <th>Contact Info</th>
                        <th>Amount (RM)</th>
                        <th>Event</th>
                        <th>Date Donated</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        for (int i = 0; i < donorList.size(); i++) {
                            donor donor = donorList.get(i);
                            donation donation = donationList.get(i);
                            events event = eventList.get(i);
                    %>
                        <tr>
                            <td><%= donor.getName() %></td>
                            <td>0<%= donor.getContactInfo() %></td>
                            <td><%= amountFormat.format(donation.getAmount()) %></td>
                            <td><%= event.getName() %></td>
                            <td><%= dateFormat.format(donation.getDate()) %></td>
                        </tr>
                    <% } %>
                    </tbody>
            </table>
        </div>

        <div class="pagination-container">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage - 1 %>&searchName=<%= searchName != null ? searchName : "" %>" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <% for (int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= currentPage == i ? "active" : "" %>">
                            <a class="page-link" href="?page=<%= i %>&searchName=<%= searchName != null ? searchName : "" %>"><%= i %></a>
                        </li>
                    <% } %>
                    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage + 1 %>&searchName=<%= searchName != null ? searchName : "" %>" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</body>
</html>
