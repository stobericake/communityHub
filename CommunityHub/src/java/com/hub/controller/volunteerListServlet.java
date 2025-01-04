package com.hub.controller;

import com.cm.model.volunteer;
import com.cm.model.eventsVolunteer;
import com.cm.model.events;
import com.cm.controller.dbconnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/volunteerList")
public class volunteerListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchName = request.getParameter("searchName");
        int currentPage = 1;
        int volunteersPerPage = 10;

        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<volunteer> volunteers = new ArrayList<>();

        try {
            try {
                conn = dbconnection.getConnection();
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(volunteerListServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (conn == null) {
                throw new SQLException("Failed to establish a database connection.");
            }

            // Count total volunteers for pagination
            String countSql = "SELECT COUNT(*) AS total FROM volunteer v " +
                    "INNER JOIN eventsVolunteer ev ON v.volunteerID = ev.volunteerID " +
                    "INNER JOIN events e ON ev.eventID = e.eventID WHERE 1=1";

            if (searchName != null && !searchName.isEmpty()) {
                countSql += " AND (v.volunteerID LIKE ? OR v.name LIKE ? OR v.contactInfo LIKE ? " +
                        "OR v.username LIKE ? OR e.name LIKE ? OR e.date LIKE ?)";
            }

            stmt = conn.prepareStatement(countSql);

            if (searchName != null && !searchName.isEmpty()) {
                String likePattern = "%" + searchName + "%";
                for (int i = 1; i <= 6; i++) {
                    stmt.setString(i, likePattern);
                }
            }

            rs = stmt.executeQuery();
            rs.next();
            int totalVolunteers = rs.getInt("total");
            rs.close();
            stmt.close();

            int offset = (currentPage - 1) * volunteersPerPage;
            int totalPages = (int) Math.ceil((double) totalVolunteers / volunteersPerPage);

            // Fetch volunteer data with pagination
            String sql = "SELECT v.volunteerID, v.name, v.contactInfo, v.username, e.eventID, e.name AS eventName, e.date AS dateJoined " +
                    "FROM volunteer v " +
                    "INNER JOIN eventsVolunteer ev ON v.volunteerID = ev.volunteerID " +
                    "INNER JOIN events e ON ev.eventID = e.eventID WHERE 1=1";

            if (searchName != null && !searchName.isEmpty()) {
                sql += " AND (v.volunteerID LIKE ? OR v.name LIKE ? OR v.contactInfo LIKE ? " +
                        "OR v.username LIKE ? OR e.name LIKE ? OR e.date LIKE ?)";
            }

            // Apply pagination
            sql += " LIMIT ? OFFSET ?";

            stmt = conn.prepareStatement(sql);

            int paramIndex = 1;
            if (searchName != null && !searchName.isEmpty()) {
                String likePattern = "%" + searchName + "%";
                for (int i = 1; i <= 6; i++) {
                    stmt.setString(paramIndex++, likePattern);
                }
            }
            stmt.setInt(paramIndex++, volunteersPerPage);
            stmt.setInt(paramIndex++, offset);

            rs = stmt.executeQuery();

            while (rs.next()) {
                volunteer v = new volunteer(
                        rs.getInt("volunteerID"),
                        rs.getString("name"),
                        rs.getInt("contactInfo"),
                        rs.getString("username"),
                        null, // Password is not retrieved
                        0,    // AddressID is not retrieved
                        null  // Image is not retrieved
                );

                events e = new events(
                        rs.getInt("eventID"),
                        rs.getString("eventName"),
                        rs.getDate("dateJoined")
                );

                eventsVolunteer evv = new eventsVolunteer(
                        rs.getInt("eventID"),
                        v.getVolunteerID(),
                        e.getEventID()
                );

                volunteers.add(v);
            }

            request.setAttribute("volunteers", volunteers);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);

            // Forward to JSP
            request.getRequestDispatcher("/views/volunteerList.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error while retrieving volunteer data.");
            request.getRequestDispatcher("/errorPage.jsp").forward(request, response);

        } finally {
            try {
                if (rs != null) rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
