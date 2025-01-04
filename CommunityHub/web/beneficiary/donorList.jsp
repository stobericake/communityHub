<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cm.model.donor" %>
<%@ page import="com.cm.model.donation" %>
<%@ page import="com.cm.model.events" %>

<!DOCTYPE html>
<html>
<head>
    <title>Donor List Overview</title>
    <style>
        /* Styles from the original code */
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
                const cells = Array.from(row.querySelectorAll('td'));
                const match = cells.some(cell => cell.textContent.toLowerCase().includes(input));
                row.style.display = match ? '' : 'none';
            });
        }
    </script>
</head>
<body>
    <%@ include file="header2.jspf" %>
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
        
        <div class="table-spacing table-responsive">
            <table id="donorTable" class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Contact Info</th>
                        <th>Amount (RM)</th>
                        <th>Event</th>
                        <th>Date Donated</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="donor" items="${donors}">
                        <tr>
                            <td>${donor.donorID}</td>
                            <td>${donor.name}</td>
                            <td>${donor.contactInfo}</td>
                            <td>${donor.amount}</td>
                            <td>${donor.eventName}</td>
                            <td>${donor.dateDonated}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="pagination-container">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage - 1}&searchName=${searchName}" aria-label="Previous">
                            &laquo;
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="page">
                        <li class="page-item ${currentPage == page ? 'active' : ''}">
                            <a class="page-link" href="?page=${page}&searchName=${searchName}">${page}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage + 1}&searchName=${searchName}" aria-label="Next">
                            &raquo;
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</body>
</html>