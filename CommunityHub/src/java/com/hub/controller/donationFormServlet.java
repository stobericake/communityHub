package com.hub.controller;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(name = "donationFormServlet", urlPatterns = {"/addDonor.do"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB
        maxRequestSize = 1024 * 1024 * 60) // 60MB
public class donationFormServlet extends HttpServlet {

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
            stmt.setString(2, contactInfo);
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
                stmt.setString(2, contactInfo);
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
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
