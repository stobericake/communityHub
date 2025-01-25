package com.hub.controller;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
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

@WebServlet("/UpdateProfile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class UpdateProfile extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set response content type
        response.setContentType("text/html;charset=UTF-8");

        // Retrieve form parameters
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");

        // Retrieve user ID based on role
        String userId;
        if (userRole.equals("admin")) {
            userId = session.getAttribute("admin").toString(); // Admin ID
        } else if (userRole.equals("volunteer")) {
            userId = session.getAttribute("volunteer").toString(); // Volunteer ID
        } else {
            userId = session.getAttribute("beneficiary").toString(); // Beneficiary ID
        }

        String updateType = request.getParameter("type");

        try (Connection conn = dbconnection.getConnection()) {
            if (updateType.equals("basic")) {
                // Update User Info (for all users)
                updateUserInfo(request, conn, userId, userRole);
            } else if (updateType.equals("address")) {
                // Update Address (only for volunteers and beneficiaries)
                if (!userRole.equals("admin")) {
                    updateAddress(request, conn, userId);
                }
            } else if (updateType.equals("password")) {
                // Update Password (for all users)
                updatePassword(request, conn, userId, userRole);
            }

            // Redirect to profile page after successful update
            response.sendRedirect(request.getContextPath() + "/ProfileDetail");

        } catch (SQLException ex) {
            Logger.getLogger(UpdateProfile.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Database error: " + ex.getMessage());
            request.getRequestDispatcher(request.getContextPath() + "/ProfileDetail").forward(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UpdateProfile.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Application error: " + ex.getMessage());
            request.getRequestDispatcher(request.getContextPath() + "/ProfileDetail").forward(request, response);
        }
    }

    // Method to update user info (name, email, contact, username, profile picture)
    private void updateUserInfo(HttpServletRequest request, Connection conn, String userId, String userRole)
            throws SQLException, IOException, ServletException {
        // Retrieve form parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String contact = request.getParameter("phone_number");
        String username = request.getParameter("username");

        // Retrieve the uploaded image file
        Part filePart = request.getPart("profilePicture");
        InputStream imageInputStream = null;

        // Check if a new image was uploaded
        boolean hasNewImage = false;
        if (filePart != null && filePart.getSize() > 0) {
            imageInputStream = filePart.getInputStream();
            hasNewImage = true; // Flag to indicate a new image was uploaded
        }

        // Prepare the SQL query based on the user role
        String updateUserSQL;
        if (userRole.equals("admin")) {
            if (hasNewImage) {
                updateUserSQL = "UPDATE admin SET name = ?, email = ?, contactInfo = ?, username = ?, image = ? WHERE adminID = ?";
            } else {
                updateUserSQL = "UPDATE admin SET name = ?, email = ?, contactInfo = ?, username = ? WHERE adminID = ?";
            }
        } else if (userRole.equals("volunteer")) {
            if (hasNewImage) {
                updateUserSQL = "UPDATE volunteer SET name = ?, contactInfo = ?, username = ?, image = ? WHERE volunteerID = ?";
            } else {
                updateUserSQL = "UPDATE volunteer SET name = ?, contactInfo = ?, username = ? WHERE volunteerID = ?";
            }
        } else {
            if (hasNewImage) {
                updateUserSQL = "UPDATE beneficiary SET name = ?, contactInfo = ?, username = ?, image = ? WHERE beneficiaryID = ?";
            } else {
                updateUserSQL = "UPDATE beneficiary SET name = ?, contactInfo = ?, username = ? WHERE beneficiaryID = ?";
            }
        }

        try (PreparedStatement userStmt = conn.prepareStatement(updateUserSQL)) {
            // Set parameters based on the user role
            if (userRole.equals("admin")) {
                userStmt.setString(1, name);
                userStmt.setString(2, email);
                userStmt.setInt(3, Integer.parseInt(contact));
                userStmt.setString(4, username);
                if (hasNewImage) {
                    userStmt.setBlob(5, imageInputStream); // Set the new image
                    userStmt.setInt(6, Integer.parseInt(userId));
                } else {
                    userStmt.setInt(5, Integer.parseInt(userId));
                }
            } else {
                userStmt.setString(1, name);
                userStmt.setInt(2, Integer.parseInt(contact));
                userStmt.setString(3, username);
                if (hasNewImage) {
                    userStmt.setBlob(4, imageInputStream); // Set the new image
                    userStmt.setInt(5, Integer.parseInt(userId));
                } else {
                    userStmt.setInt(4, Integer.parseInt(userId));
                }
            }

            // Execute the update
            int rowsUpdated = userStmt.executeUpdate();
            if (rowsUpdated <= 0) {
                throw new SQLException("Failed to update user info.");
            }
        }
    }

    // Method to update address (only for volunteers and beneficiaries)
    private void updateAddress(HttpServletRequest request, Connection conn, String userId)
            throws SQLException {
        String country = request.getParameter("country");
        String postcode = request.getParameter("postcode");
        String street = request.getParameter("street");
        String city = request.getParameter("city");
        String state = request.getParameter("state");

       String updateAddressSQL = "UPDATE address " +
            "SET country = ?, postalCode = ?, street = ?, city = ?, state = ? " +
            "WHERE addressID IN (" +
            "    SELECT addressID FROM volunteer WHERE volunteerID = ? " +
            "    UNION " +
            "    SELECT addressID FROM beneficiary WHERE beneficiaryID = ?" +
            ")";

        try (PreparedStatement addressStmt = conn.prepareStatement(updateAddressSQL)) {
            addressStmt.setString(1, country);
            addressStmt.setInt(2, Integer.parseInt(postcode));
            addressStmt.setString(3, street);
            addressStmt.setString(4, city);
            addressStmt.setString(5, state);
            addressStmt.setInt(6, Integer.parseInt(userId));
            addressStmt.setInt(7, Integer.parseInt(userId));

            int rowsUpdated = addressStmt.executeUpdate();
            if (rowsUpdated <= 0) {
                throw new SQLException("Failed to update address.");
            }
        }
    }

    // Method to update password (for all users)
    private void updatePassword(HttpServletRequest request, Connection conn, String userId, String userRole)
            throws SQLException {
        // Retrieve the new password from the form
        String newPassword = request.getParameter("password");

        // Only update the password if a new password is provided
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            String updatePasswordSQL;
            if (userRole.equals("admin")) {
                updatePasswordSQL = "UPDATE admin SET password = ? WHERE adminID = ?";
            } else if (userRole.equals("volunteer")) {
                updatePasswordSQL = "UPDATE volunteer SET password = ? WHERE volunteerID = ?";
            } else {
                updatePasswordSQL = "UPDATE beneficiary SET password = ? WHERE beneficiaryID = ?";
            }

            try (PreparedStatement passwordStmt = conn.prepareStatement(updatePasswordSQL)) {
                passwordStmt.setString(1, newPassword); // Set the new password
                passwordStmt.setInt(2, Integer.parseInt(userId));

                // Execute the update
                int rowsUpdated = passwordStmt.executeUpdate();
                if (rowsUpdated <= 0) {
                    throw new SQLException("Failed to update password.");
                }
            }
        }
        // If the password field is empty, do nothing (retain the current password)
    }
}