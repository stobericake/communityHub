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
            String eventFilter = request.getParameter("eventFilter"); // Event filter
            String monthFilter = request.getParameter("month"); // Month filter
            String yearFilter = request.getParameter("year"); // Year filter
            String sortBy = request.getParameter("sortBy"); // Sort by parameter

            int volunteerPerPage = 8;
            int currentPage = request.getParameter("page") != null
                    ? Integer.parseInt(request.getParameter("page")) : 1;
            int offset = (currentPage - 1) * volunteerPerPage;

            // Count total volunteers for pagination
            StringBuilder countSql = new StringBuilder(
                "SELECT COUNT(*) AS total FROM volunteer v " +
                "INNER JOIN eventsVolunteer ev ON v.volunteerID = ev.volunteerID " +
                "INNER JOIN events e ON ev.eventID = e.eventID WHERE e.beneficiaryID = ?"
            );

            if (searchName != null && !searchName.isEmpty()) {
                countSql.append(" AND (v.volunteerID LIKE ? OR v.name LIKE ? OR v.contactInfo LIKE ? " +
                        "OR v.username LIKE ? OR e.name LIKE ? OR e.date LIKE ?)");
            }

            if (eventFilter != null && !eventFilter.isEmpty()) {
                countSql.append(" AND e.name = ?");
            }

            if (monthFilter != null && !monthFilter.isEmpty()) {
                countSql.append(" AND MONTH(e.date) = ?");
            }

            if (yearFilter != null && !yearFilter.isEmpty()) {
                countSql.append(" AND YEAR(e.date) = ?");
            }

            stmt = conn.prepareStatement(countSql.toString());
            stmt.setInt(1, beneficiaryID);
            int paramIndex = 2;

            if (searchName != null && !searchName.isEmpty()) {
                String likePattern = "%" + searchName + "%";
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
            }

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
            int totalVolunteer = rs.getInt("total");
            int totalPages = (int) Math.ceil((double) totalVolunteer / volunteerPerPage);

            // Fetch volunteer data with pagination
            StringBuilder sql = new StringBuilder(
                "SELECT v.volunteerID, v.name AS volunteerName, v.contactInfo, v.username, " +
                "e.eventID, e.name AS eventName, e.date, e.time, e.duration, e.description, " +
                "e.volunteerNeeded, e.status, e.image, e.donationLimit, e.addressID, " +
                "ev.eventsVolunteerID, ev.attendance " +
                "FROM volunteer v " +
                "INNER JOIN eventsVolunteer ev ON v.volunteerID = ev.volunteerID " +
                "INNER JOIN events e ON ev.eventID = e.eventID WHERE e.beneficiaryID = ?"
            );

            if (searchName != null && !searchName.isEmpty()) {
                sql.append(" AND (v.volunteerID LIKE ? OR v.name LIKE ? OR v.contactInfo LIKE ? " +
                        "OR v.username LIKE ? OR e.name LIKE ? OR e.date LIKE ?)");
            }

            if (eventFilter != null && !eventFilter.isEmpty()) {
                sql.append(" AND e.name = ?");
            }

            if (monthFilter != null && !monthFilter.isEmpty()) {
                sql.append(" AND MONTH(e.date) = ?");
            }

            if (yearFilter != null && !yearFilter.isEmpty()) {
                sql.append(" AND YEAR(e.date) = ?");
            }

            // Add sorting logic
            if (sortBy != null && !sortBy.isEmpty()) {
                switch (sortBy) {
                    case "name":
                        sql.append(" ORDER BY v.name");
                        break;
                    case "date":
                        sql.append(" ORDER BY e.date");
                        break;
                    case "event":
                        sql.append(" ORDER BY e.name");
                        break;
                    default:
                        sql.append(" ORDER BY e.date DESC"); // Default sorting by event date
                        break;
                }
            }

            sql.append(" LIMIT ? OFFSET ?");
            stmt = conn.prepareStatement(sql.toString());

            stmt.setInt(1, beneficiaryID);
            paramIndex = 2;

            if (searchName != null && !searchName.isEmpty()) {
                String likePattern = "%" + searchName + "%";
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
                stmt.setString(paramIndex++, likePattern);
            }

            if (eventFilter != null && !eventFilter.isEmpty()) {
                stmt.setString(paramIndex++, eventFilter);
            }

            if (monthFilter != null && !monthFilter.isEmpty()) {
                stmt.setInt(paramIndex++, Integer.parseInt(monthFilter));
            }

            if (yearFilter != null && !yearFilter.isEmpty()) {
                stmt.setInt(paramIndex++, Integer.parseInt(yearFilter));
            }

            stmt.setInt(paramIndex++, volunteerPerPage);
            stmt.setInt(paramIndex, offset);

            rs = stmt.executeQuery();

            List<volunteer> volunteers = new ArrayList<>();
            List<eventsVolunteer> eventsVolunteers = new ArrayList<>();
            List<events> events = new ArrayList<>();

            while (rs.next()) {
                volunteer volunteer = new volunteer(
                    rs.getInt("volunteerID"),
                    rs.getString("volunteerName"), // Use the alias here
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
                    rs.getInt("eventID"),
                    rs.getString("eventName"), // Use the alias here
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
            request.setAttribute("volunteer", volunteers);
            request.setAttribute("eventsVolunteer", eventsVolunteers);
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