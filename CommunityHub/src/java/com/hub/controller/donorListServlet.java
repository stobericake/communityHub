package com.hub.controller;

import com.cm.model.donor;
import com.cm.model.donation;
import com.cm.model.events;
import com.hub.controller.dbconnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/donorList")
public class donorListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchName = request.getParameter("searchName");
        int currentPage = 1;
        int donorsPerPage = 10;

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
        List<donor> donors = new ArrayList<>();

        try {
            try {
                conn = dbconnection.getConnection();
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(donorListServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (conn == null) {
                throw new SQLException("Failed to establish a database connection.");
            }

            // Count total donors for pagination
            String countSql = "SELECT COUNT(*) AS total FROM donor d " +
                    "INNER JOIN donation dn ON d.donorID = dn.donorID " +
                    "INNER JOIN events e ON dn.eventID = e.eventID WHERE 1=1";

            if (searchName != null && !searchName.isEmpty()) {
                countSql += " AND (d.donorID LIKE ? OR d.name LIKE ? OR d.contactInfo LIKE ? " +
                        "OR dn.amount LIKE ? OR e.name LIKE ? OR dn.date LIKE ?)";
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
            int totalDonors = rs.getInt("total");
            rs.close();
            stmt.close();

            int offset = (currentPage - 1) * donorsPerPage;
            int totalPages = (int) Math.ceil((double) totalDonors / donorsPerPage);

            // Fetch donor data with pagination
            String sql = "SELECT d.donorID, d.name, d.contactInfo, dn.amount, e.name AS eventName, dn.date AS dateDonated " +
                             "FROM donor d " +
                             "INNER JOIN donation dn ON d.donorID = dn.donorID " +
                             "INNER JOIN events e ON dn.eventID = e.eventID " +
                             "WHERE 1=1";

                if (searchName != null && !searchName.isEmpty()) {
                    sql += " AND (d.donorID LIKE ? OR d.name LIKE ? OR d.contactInfo LIKE ? " +
                           "OR dn.amount LIKE ? OR e.name LIKE ? OR dn.date LIKE ?)";
            }

            // apply pagination
                sql += " LIMIT ? OFFSET ?";

                stmt = conn.prepareStatement(sql);
                
                // set values for query
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
                stmt.setInt(paramIndex++, donorsPerPage);
                stmt.setInt(paramIndex++, offset);

                rs = stmt.executeQuery();

            while (rs.next()) {
                donor d = new donor(
                        rs.getInt("donorID"),
                        rs.getString("name"),
                        rs.getInt("contactInfo") 
                );

                donation dn = new donation(
                        0, // Placeholder for donationID if needed
                        rs.getInt("eventID"),
                        rs.getInt("donorID"),
                        0, // Placeholder for volunteerID
                        rs.getDouble("amount"),
                        rs.getDate("dateDonated"),
                        null // Placeholder for receiptImage
                );

                events ev = new events(
                        rs.getInt("eventID"),
                        rs.getString("eventName"),
                        null, null, null, null, 0, null, null, 0, 0
                );

                donation.add(dn);
                events.add(ev);

                donors.add(d);
            }

            request.setAttribute("donors", donors);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);

            // Forward to JSP
            request.getRequestDispatcher("/views/donorList.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error while retrieving donor data.");
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