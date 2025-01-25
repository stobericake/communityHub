package com.hub.controller;

import com.cm.model.events;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.util.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "donationFormServlet", urlPatterns = {"/addDonor.do"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB
        maxRequestSize = 1024 * 1024 * 60) // 60MB
public class donationFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String eventID = request.getParameter("eventID"); // Example: Replace with dynamic ID if needed.
        HttpSession session = request.getSession(false); // Get existing session, do not create a new one
        Integer volunteerID = (session != null) ? (Integer) session.getAttribute("volunteer") : null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        events event = null;
        PreparedStatement stmt2 = null;
        ResultSet rs2 = null;

        try {
            conn = dbconnection.getConnection();
            if (conn == null) {
                System.out.println("DB Connection: " + (conn != null));
                return;
            }

            // Query to retrieve event details
            String sql = "SELECT * FROM events WHERE eventID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(eventID));
            rs = stmt.executeQuery();

            if (rs.next()) {
                event = new events(
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
            }
            request.setAttribute("event", event);

            // If the user is a volunteer, retrieve their details
            if (volunteerID != null) {
                String nameSQL = "SELECT volunteerID, name, contactInfo FROM volunteer WHERE volunteerID = ?";
                stmt2 = conn.prepareStatement(nameSQL);
                stmt2.setInt(1, volunteerID);
                rs2 = stmt2.executeQuery();

                if (rs2.next()) {
                    String volunteerName = rs2.getString("name");
                    int contactInfo = rs2.getInt("contactInfo");
                    request.setAttribute("volunteerName", volunteerName);
                    request.setAttribute("contactInfo", contactInfo);
                }
            }

            request.getRequestDispatcher("/guest/donationForm.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while fetching events.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(donationFormServlet.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException ex) {
                    Logger.getLogger(donationFormServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException ex) {
                    Logger.getLogger(donationFormServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    Logger.getLogger(donationFormServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }

        // Get current date
        Date currentDate = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        String formattedDate = dateFormat.format(currentDate);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            HttpSession session = request.getSession(false);
            String eventID = request.getParameter("eventID");
            String amount = request.getParameter("amount");
            java.sql.Date date = new java.sql.Date(System.currentTimeMillis());
            Part filePart = request.getPart("receipt");
            InputStream fileContent = filePart.getInputStream();

            if (session != null && session.getAttribute("volunteer") != null) {
                // Volunteer making a donation
                int volunteerID = (int) session.getAttribute("volunteer");

                conn = dbconnection.getConnection();
                String insertDonationSQL = "INSERT INTO donation (amount, date, receiptImage, eventID, volunteerID, donorID) VALUES (?, ?, ?, ?, ?, NULL)";
                stmt = conn.prepareStatement(insertDonationSQL);
                stmt.setDouble(1, Double.parseDouble(amount));
                stmt.setDate(2, date);
                stmt.setBinaryStream(3, fileContent, (int) filePart.getSize());
                stmt.setInt(4, Integer.parseInt(eventID));
                stmt.setInt(5, volunteerID);
            } else {
                // Donor making a donation
                String donorName = request.getParameter("name");
                String contactInfo = request.getParameter("contactInfo");

                conn = dbconnection.getConnection();

                // Check if donor exists
                String checkDonorSQL = "SELECT donorID FROM donor WHERE name = ? AND contactInfo = ?";
                stmt = conn.prepareStatement(checkDonorSQL);
                stmt.setString(1, donorName);
                stmt.setString(2, contactInfo);
                rs = stmt.executeQuery();

                int donorID;
                if (rs.next()) {
                    donorID = rs.getInt("donorID");
                } else {
                    String insertDonorSQL = "INSERT INTO donor (name, contactInfo) VALUES (?, ?)";
                    stmt = conn.prepareStatement(insertDonorSQL, PreparedStatement.RETURN_GENERATED_KEYS);
                    stmt.setString(1, donorName);
                    stmt.setString(2, contactInfo);
                    stmt.executeUpdate();
                    rs = stmt.getGeneratedKeys();

                    if (rs.next()) {
                        donorID = rs.getInt(1);
                    } else {
                        throw new SQLException("Failed to retrieve donorID.");
                    }
                }

                // Insert donation
                String insertDonationSQL = "INSERT INTO donation (amount, date, receiptImage, eventID, donorID) VALUES (?, ?, ?, ?, ?)";
                stmt = conn.prepareStatement(insertDonationSQL);
                stmt.setDouble(1, Double.parseDouble(amount));
                stmt.setDate(2, date);
                stmt.setBinaryStream(3, fileContent, (int) filePart.getSize());
                stmt.setInt(4, Integer.parseInt(eventID));
                stmt.setInt(5, donorID);
            }

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect("success.jsp");
            } else {
                response.sendRedirect("error.jsp");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
