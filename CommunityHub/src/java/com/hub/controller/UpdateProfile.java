package com.hub.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateProfile extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set response content type
        response.setContentType("text/html;charset=UTF-8");

        // Retrieve form parameters
        HttpSession session = request.getSession();
//        String userId = session.getAttribute("admin").toString();
        String userId = "1";
//        String fullName = request.getParameter("full_name");
        String updateType = request.getParameter("type");
        String phone = request.getParameter("phone_number");
        String email = request.getParameter("email");
//        String street = request.getParameter("street");
//        String postcode = request.getParameter("postcode");
//        String city = request.getParameter("city");
//        String state = request.getParameter("state");
//        String country = request.getParameter("country");
        String username = request.getParameter("username");
//        String role = request.getParameter("role"); // Assume this is constant during updates

        // Input validation
        if (userId == null || userId.isEmpty()
                //                || fullName == null || fullName.isEmpty()
                || phone == null || phone.isEmpty()
                //                || street == null || street.isEmpty()
                //                || postcode == null || postcode.isEmpty()
                //                || city == null || city.isEmpty()
                //                || state == null || state.isEmpty()
                //                || country == null || country.isEmpty()
                || username == null || username.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        // Update profile in database
        try (Connection conn = dbconnection.getConnection()) {
            // Update address
//            String updateAddressSQL = "UPDATE address SET country = ?, postalCode = ?, street = ?, city = ?, state = ? "
//                    + "WHERE addressID = (SELECT addressID FROM admin WHERE userID = ?)";
//            try (PreparedStatement addressStmt = conn.prepareStatement(updateAddressSQL)) {
//                addressStmt.setString(1, country);
//                addressStmt.setInt(2, Integer.parseInt(postcode));
//                addressStmt.setString(3, street);
//                addressStmt.setString(4, city);
//                addressStmt.setString(5, state);
//                addressStmt.setInt(6, Integer.parseInt(userId));
//
//                int addressRowsUpdated = addressStmt.executeUpdate();
//
//                if (addressRowsUpdated > 0) {
//                    // Update user details
//                    String updateUserSQL = "UPDATE admin SET name = ?, contactInfo = ?, username = ?, eamil = ? WHERE userID = ?";
//                    try (PreparedStatement userStmt = conn.prepareStatement(updateUserSQL)) {
//                        userStmt.setString(1, fullName);
//                        userStmt.setInt(2, Integer.parseInt(phone));
//                        userStmt.setString(3, username);
//                        userStmt.setString(3, email);
//                        userStmt.setInt(4, Integer.parseInt(userId));
//
//                        int userRowsUpdated = userStmt.executeUpdate();
//
//                        if (userRowsUpdated > 0) {
//                            request.setAttribute("success", "Profile updated successfully!");
//                            request.getRequestDispatcher("success.jsp").forward(request, response);
//                        } else {
//                            request.setAttribute("error", "Failed to update user details.");
//                            request.getRequestDispatcher("profile.jsp").forward(request, response);
//                        }
//                    }
//                } else {
//                    request.setAttribute("error", "Failed to update address.");
//                    request.getRequestDispatcher("profile.jsp").forward(request, response);
//                }
//            }
            if (updateType.equals("basic")) {
                String updateUserSQL = "UPDATE admin SET contactInfo = ?, username = ?, email = ? WHERE adminID = ?";
                try (PreparedStatement userStmt = conn.prepareStatement(updateUserSQL)) {
                    userStmt.setInt(1, Integer.parseInt(phone));
                    userStmt.setString(2, username);
                    userStmt.setString(3, email);
                    userStmt.setInt(4, Integer.parseInt(userId));

                    int userRowsUpdated = userStmt.executeUpdate();

                    if (userRowsUpdated > 0) {
                        request.setAttribute("success", "Profile updated successfully!");
                        request.getRequestDispatcher("success.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Failed to update user details.");
                        request.getRequestDispatcher("profile.jsp").forward(request, response);
                    }
                }
            } else if (updateType.equals("password")) {
                
            } else {
                
            }

        } catch (SQLException ex) {
            Logger.getLogger(UpdateProfile.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Database error: " + ex.getMessage());
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UpdateProfile.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Application error: " + ex.getMessage());
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
}
