package com.hub.controller;

import com.cm.model.donor;
import com.cm.model.donation;
import com.cm.model.events;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/donorListServlet")
public class donorListServlet extends HttpServlet {

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    int beneficiaryID = Integer.parseInt(request.getSession().getAttribute("beneficiary").toString());
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = dbconnection.getConnection();

        String searchName = request.getParameter("searchName");
        String eventFilter = request.getParameter("eventFilter"); // Event filter
        String monthFilter = request.getParameter("month"); // Month filter
        String yearFilter = request.getParameter("year"); // Year filter
        String sortBy = request.getParameter("sortBy"); // Sort by parameter

        int donorsPerPage = 8;
        int currentPage = request.getParameter("page") != null
                ? Integer.parseInt(request.getParameter("page")) : 1;
        int offset = (currentPage - 1) * donorsPerPage;

        // Count total donors
        StringBuilder countSql = new StringBuilder(
            "SELECT COUNT(*) AS total FROM donor d " +
            "INNER JOIN donation dn ON d.donorID = dn.donorID " +
            "INNER JOIN events e ON dn.eventID = e.eventID WHERE e.beneficiaryID = ?"
        );

        if (eventFilter != null && !eventFilter.isEmpty()) {
            countSql.append(" AND e.name = ?");
        }

        if (monthFilter != null && !monthFilter.isEmpty()) {
            countSql.append(" AND MONTH(dn.date) = ?");
        }

        if (yearFilter != null && !yearFilter.isEmpty()) {
            countSql.append(" AND YEAR(dn.date) = ?");
        }

        stmt = conn.prepareStatement(countSql.toString());
        stmt.setInt(1, beneficiaryID);
        int paramIndex = 2;

        if (eventFilter != null && !eventFilter.isEmpty()) {
            stmt.setString(paramIndex++, eventFilter);
        }

        if (monthFilter != null && !monthFilter.isEmpty()) {
            stmt.setInt(paramIndex++, Integer.parseInt(monthFilter));
        }

        if (yearFilter != null && !yearFilter.isEmpty()) {
            stmt.setInt(paramIndex++, Integer.parseInt(yearFilter));
        }

        rs = stmt.executeQuery();
        rs.next();
        int totalDonors = rs.getInt("total");
        int totalPages = (int) Math.ceil((double) totalDonors / donorsPerPage);

        // Fetch donors
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM donor d " +
            "INNER JOIN donation dn ON d.donorID = dn.donorID " +
            "INNER JOIN events e ON dn.eventID = e.eventID WHERE e.beneficiaryID = ?"
        );

        if (eventFilter != null && !eventFilter.isEmpty()) {
            sql.append(" AND e.name = ?");
        }

        if (monthFilter != null && !monthFilter.isEmpty()) {
            sql.append(" AND MONTH(dn.date) = ?");
        }

        if (yearFilter != null && !yearFilter.isEmpty()) {
            sql.append(" AND YEAR(dn.date) = ?");
        }

        // Add sorting logic
        if (sortBy != null && !sortBy.isEmpty()) {
            switch (sortBy) {
                case "name":
                    sql.append(" ORDER BY d.name");
                    break;
                case "date":
                    sql.append(" ORDER BY dn.date");
                    break;
                case "amount":
                    sql.append(" ORDER BY dn.amount DESC");
                    break;
                default:
                    sql.append(" ORDER BY dn.date DESC"); // Default sorting by date
                    break;
            }
        }

        sql.append(" LIMIT ? OFFSET ?");
        stmt = conn.prepareStatement(sql.toString());

        stmt.setInt(1, beneficiaryID);
        paramIndex = 2;

        if (eventFilter != null && !eventFilter.isEmpty()) {
            stmt.setString(paramIndex++, eventFilter);
        }

        if (monthFilter != null && !monthFilter.isEmpty()) {
            stmt.setInt(paramIndex++, Integer.parseInt(monthFilter));
        }

        if (yearFilter != null && !yearFilter.isEmpty()) {
            stmt.setInt(paramIndex++, Integer.parseInt(yearFilter));
        }

        stmt.setInt(paramIndex++, donorsPerPage);
        stmt.setInt(paramIndex, offset);

        rs = stmt.executeQuery();

        List<donor> donors = new ArrayList<>();
        List<donation> donations = new ArrayList<>();
        List<events> events = new ArrayList<>();

        while (rs.next()) {
            donor donor = new donor(
                rs.getInt("donorID"),
                rs.getString("name"),
                rs.getInt("contactInfo")
            );
            donors.add(donor);

            donation donation = new donation(
                rs.getInt("donationID"),
                rs.getDouble("amount"),
                rs.getDate("date"),
                rs.getBlob("receiptImage")
            );
            donations.add(donation);

            events event = new events(
                rs.getInt("eventID"),
                rs.getString("name"),
                rs.getDate("date"),
                rs.getTime("time"),
                rs.getTime("duration"),
                rs.getString("description"),
                rs.getInt("volunteerNeeded"),
                rs.getString("status"),
                rs.getBlob("image"),
                rs.getDouble("donationLimit"),
                rs.getInt("addressID")
            );
            events.add(event);
        }

        // Fetch events created by the logged-in beneficiary for the event filter dropdown
        String eventSql = "SELECT * FROM events WHERE beneficiaryID = ?";
        stmt = conn.prepareStatement(eventSql);
        stmt.setInt(1, beneficiaryID);
        rs = stmt.executeQuery();

        List<events> beneficiaryEvents = new ArrayList<>();
        while (rs.next()) {
            events event = new events(
                rs.getInt("eventID"),
                rs.getString("name"),
                rs.getDate("date"),
                rs.getTime("time"),
                rs.getTime("duration"),
                rs.getString("description"),
                rs.getInt("volunteerNeeded"),
                rs.getString("status"),
                rs.getBlob("image"),
                rs.getDouble("donationLimit"),
                rs.getInt("addressID")
            );
            beneficiaryEvents.add(event);
        }

        // Set attributes for JSP
        request.setAttribute("donors", donors);
        request.setAttribute("donations", donations);
        request.setAttribute("events", events);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("searchName", searchName);
        request.setAttribute("beneficiaryEvents", beneficiaryEvents); // For event filter dropdown
        request.setAttribute("eventFilter", eventFilter); // For selected event filter
        request.setAttribute("monthFilter", monthFilter); // For selected month filter
        request.setAttribute("yearFilter", yearFilter); // For selected year filter
        request.setAttribute("sortBy", sortBy); // For selected sort option

        // Forward to JSP
        request.getRequestDispatcher("/beneficiary/donorList.jsp").forward(request, response);

    } catch (Exception e) {
        throw new ServletException("Error fetching donor data", e);
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
        try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
        try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }
}
}