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
            int donorsPerPage = 8;
            int currentPage = request.getParameter("page") != null
                    ? Integer.parseInt(request.getParameter("page")) : 1;
            int offset = (currentPage - 1) * donorsPerPage;

            // Count total donors
            String countSql = "SELECT COUNT(*) AS total FROM donor d " +
                              "INNER JOIN donation dn ON d.donorID = dn.donorID " +
                              "INNER JOIN events e ON dn.eventID = e.eventID WHERE e.beneficiaryID = ?";

            if (searchName != null && !searchName.isEmpty()) {
                countSql += " AND (d.donorID LIKE ? OR d.name LIKE ? OR d.contactInfo LIKE ? " +
                            "OR dn.amount LIKE ? OR e.name LIKE ? OR dn.date LIKE ?)";
            }

            stmt = conn.prepareStatement(countSql);
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

            rs = stmt.executeQuery();
            rs.next();
            int totalDonors = rs.getInt("total");
            int totalPages = (int) Math.ceil((double) totalDonors / donorsPerPage);

            // Fetch donors
            String sql = "SELECT * " +
                         "FROM donor d " +
                         "INNER JOIN donation dn ON d.donorID = dn.donorID " +
                         "INNER JOIN events e ON dn.eventID = e.eventID WHERE e.beneficiaryID = ?";

            if (searchName != null && !searchName.isEmpty()) {
                sql += " AND (d.donorID LIKE ? OR d.name LIKE ? OR d.contactInfo LIKE ? " +
                       "OR dn.amount LIKE ? OR e.name LIKE ? OR dn.date LIKE ?)";
            }

            sql += " LIMIT ? OFFSET ?";
            stmt = conn.prepareStatement(sql);

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
            stmt.setInt(paramIndex++, donorsPerPage);
            stmt.setInt(paramIndex++, offset);

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
            request.setAttribute("donors", donors);
            request.setAttribute("donations", donations);
            request.setAttribute("events", events);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("searchName", searchName);

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
