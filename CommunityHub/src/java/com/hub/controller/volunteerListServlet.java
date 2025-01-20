package com.hub.controller;

import com.cm.model.volunteer;
import com.cm.model.eventsVolunteer;
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

@WebServlet("/volunteerListServlet")
public class volunteerListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int beneficiaryID = Integer.parseInt(request.getSession().getAttribute("beneficiary").toString());
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbconnection.getConnection();

            String searchName = request.getParameter("searchName");
            int volunteerPerPage = 8;
            int currentPage = request.getParameter("page") != null
                    ? Integer.parseInt(request.getParameter("page")) : 1;
            int offset = (currentPage - 1) * volunteerPerPage;

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
                stmt.setString(1, likePattern);
                stmt.setString(2, likePattern);
                stmt.setString(3, likePattern);
                stmt.setString(4, likePattern);
                stmt.setString(5, likePattern);
                stmt.setString(6, likePattern);
            }

            rs = stmt.executeQuery();
            rs.next();
            int totalVolunteer = rs.getInt("total");
            int totalPages = (int) Math.ceil((double) totalVolunteer / volunteerPerPage);

           // Fetch volunteer data with pagination
            String sql = "SELECT * " +
                    "FROM volunteer v " +
                    "INNER JOIN eventsVolunteer ev ON v.volunteerID = ev.volunteerID " +
                    "INNER JOIN events e ON ev.eventID = e.eventID WHERE 1=1 AND e.beneficiaryID =" + beneficiaryID;

            if (searchName != null && !searchName.isEmpty()) {
                sql += " AND (v.volunteerID LIKE ? OR v.name LIKE ? OR v.contactInfo LIKE ? " +
                        "OR v.username LIKE ? OR e.name LIKE ? OR e.date LIKE ?)";
            }

            sql += " LIMIT ? OFFSET ?";
            stmt = conn.prepareStatement(sql);

            int paramIndex = 1;
            if (searchName != null && !searchName.isEmpty()) {
                String likePattern = "%" + searchName + "%";
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
            }
            stmt.setInt(paramIndex++, volunteerPerPage);
            stmt.setInt(paramIndex++, offset);

            rs = stmt.executeQuery();

            List<volunteer> volunteers = new ArrayList<>();
            List<eventsVolunteer> eventsVolunteers = new ArrayList<>();
            List<events> events = new ArrayList<>();
         
            while (rs.next()) {
                volunteer volunteer = new volunteer(
                        rs.getInt("volunteerID"),
                        rs.getString("name"),
                        rs.getInt("contactInfo"),
                        rs.getString("username"),
                        null, // Password is not retrieved
                        0,    // AddressID is not retrieved
                        null  // Image is not retrieved
                );
                volunteers.add(volunteer);

                eventsVolunteer eventsVolunteer = new eventsVolunteer(
                        rs.getInt("eventsVolunteerID"),
                        rs.getInt("eventID"),
                        rs.getInt("volunteerID"),
                        rs.getInt("attendance")
                );
                eventsVolunteers.add(eventsVolunteer);

                events event = new events(
                        rs.getInt("e.eventID"),
                        rs.getString("e.name"),
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

            // Set attributes for JSP
            request.setAttribute("volunteer", volunteers);
            request.setAttribute("eventsVolunteer", eventsVolunteers);
            request.setAttribute("events", events);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("searchName", searchName);

            // Forward to JSP
            request.getRequestDispatcher("/beneficiary/volunteerList.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Error fetching volunteer data", e);
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
}
