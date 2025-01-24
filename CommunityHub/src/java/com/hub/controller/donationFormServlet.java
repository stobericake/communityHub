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
        HttpSession session = request.getSession();
        Integer volunteerID = (Integer) session.getAttribute("volunteer");
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
            
            // Query to retrieve volunteer details
            String nameSQL = "SELECT volunteerID, name FROM volunteer WHERE volunteerID = ?";
            stmt2 = conn.prepareStatement(nameSQL);
            stmt2.setInt(1, volunteerID);
            rs2 = stmt2.executeQuery();

            // Check if the ResultSet has data
            if (rs2.next()) {
                // Retrieve volunteer name and ID
                int volunteerId = rs2.getInt("volunteerID");
                String volunteerName = rs2.getString("name");

                // Set volunteer details as request attributes
                request.setAttribute("volunteerName", volunteerName);
                request.setAttribute("volunteerID", volunteerId);
            } else {
                // Handle case where no volunteer is found
                request.setAttribute("errorMessage", "Volunteer not found.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
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
            // Retrieve form data
            String eventID = request.getParameter("eventID");
            String donorName = request.getParameter("name");
            String contactInfo = request.getParameter("contactInfo"); // Add a field for contact info in your form if needed
            String amount = request.getParameter("amount");
            java.sql.Date date = new java.sql.Date(System.currentTimeMillis());

            // Handle file upload
            Part filePart = request.getPart("receipt");

            // Ensure file is provided
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect("error.jsp?error=NoReceiptProvided");
                return;
            }

            // Get input stream for the file
            InputStream fileContent = filePart.getInputStream();

            // Get a database connection
            conn = dbconnection.getConnection();

            // Check if donor exists in the donor table
            String checkDonorSQL = "SELECT donorID FROM donor WHERE name = ? AND contactInfo = ?";
            stmt = conn.prepareStatement(checkDonorSQL);
            stmt.setString(1, donorName);
            stmt.setInt(2, Integer.parseInt(contactInfo));
            rs = stmt.executeQuery();

            int donorID;
            if (rs.next()) {
                // Donor exists, get the donorID
                donorID = rs.getInt("donorID");
            } else {
                // Donor doesn't exist, insert into donor table
                String insertDonorSQL = "INSERT INTO donor (name, contactInfo) VALUES (?, ?)";
                stmt = conn.prepareStatement(insertDonorSQL, PreparedStatement.RETURN_GENERATED_KEYS);
                stmt.setString(1, donorName);
                stmt.setInt(2, Integer.parseInt(contactInfo));
                stmt.executeUpdate();

                // Retrieve the generated donorID
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    donorID = rs.getInt(1);
                } else {
                    throw new SQLException("Failed to retrieve donorID.");
                }
            }

            // Insert donation into the donation table
            String insertDonationSQL = "INSERT INTO donation (amount, date, receiptImage, eventID, donorID) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertDonationSQL);
            stmt.setDouble(1, Double.parseDouble(amount));
            stmt.setDate(2, date);
            stmt.setBinaryStream(3, fileContent, (int) filePart.getSize()); // Store the receipt as BLOB
            stmt.setInt(4, Integer.parseInt(eventID));
            stmt.setInt(5, donorID);

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
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
