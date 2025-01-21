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
        if (filePart != null && filePart.getSize() > 0) {
            imageInputStream = filePart.getInputStream();
        }

        // Prepare the SQL query based on the user role
        String updateUserSQL;
        if (userRole.equals("admin")) {
            updateUserSQL = "UPDATE admin SET name = ?, email = ?, contactInfo = ?, username = ?, image = ? WHERE adminID = ?";
        } else if (userRole.equals("volunteer")) {
            updateUserSQL = "UPDATE volunteer SET name = ?, contactInfo = ?, username = ?, image = ? WHERE volunteerID = ?";
        } else {
            updateUserSQL = "UPDATE beneficiary SET name = ?, contactInfo = ?, username = ?, image = ? WHERE beneficiaryID = ?";
        }

        try (PreparedStatement userStmt = conn.prepareStatement(updateUserSQL)) {
            // Set common parameters for all roles
            if (userRole.equals("admin")) {
                userStmt.setString(1, name);
                userStmt.setString(2, email);
                userStmt.setInt(3, Integer.parseInt(contact));
                userStmt.setString(4, username);
                if (imageInputStream != null) {
                    userStmt.setBlob(5, imageInputStream); // Set the new image
                } else {
                    userStmt.setNull(5, java.sql.Types.BLOB); // Keep the existing image
                }
                userStmt.setInt(6, Integer.parseInt(userId));
            } else {
                userStmt.setString(1, name);
                userStmt.setInt(2, Integer.parseInt(contact));
                userStmt.setString(3, username);
                if (imageInputStream != null) {
                    userStmt.setBlob(4, imageInputStream); // Set the new image
                } else {
                    userStmt.setNull(4, java.sql.Types.BLOB); // Keep the existing image
                }
                userStmt.setInt(5, Integer.parseInt(userId));
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
        String street = request.getParameter("street");
        String postcode = request.getParameter("postcode");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String country = request.getParameter("country");

        String updateAddressSQL = "UPDATE address SET street = ?, postalCode = ?, city = ?, state = ?, country = ? "
                + "WHERE addressID = (SELECT addressID FROM volunteer WHERE volunteerID = ? "
                + "UNION SELECT addressID FROM beneficiary WHERE beneficiaryID = ?)";

        try (PreparedStatement addressStmt = conn.prepareStatement(updateAddressSQL)) {
            addressStmt.setString(1, street);
            addressStmt.setInt(2, Integer.parseInt(postcode));
            addressStmt.setString(3, city);
            addressStmt.setString(4, state);
            addressStmt.setString(5, country);
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
        String newPassword = request.getParameter("password");

        String updatePasswordSQL;
        if (userRole.equals("admin")) {
            updatePasswordSQL = "UPDATE admin SET password = ? WHERE adminID = ?";
        } else if (userRole.equals("volunteer")) {
            updatePasswordSQL = "UPDATE volunteer SET password = ? WHERE volunteerID = ?";
        } else {
            updatePasswordSQL = "UPDATE beneficiary SET password = ? WHERE beneficiaryID = ?";
        }

        try (PreparedStatement passwordStmt = conn.prepareStatement(updatePasswordSQL)) {
            passwordStmt.setString(1, newPassword);
            passwordStmt.setInt(2, Integer.parseInt(userId));

            int rowsUpdated = passwordStmt.executeUpdate();
            if (rowsUpdated <= 0) {
                throw new SQLException("Failed to update password.");
            }
        }
    }
}