package com.hub.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class registerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set response content type
        response.setContentType("text/html;charset=UTF-8");

        // Retrieve form parameters
        String fullName = request.getParameter("full_name");
        String username = request.getParameter("username");
        String phone = request.getParameter("phone_number");
        String street = request.getParameter("street");
        String postcode = request.getParameter("postcode");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String country = request.getParameter("country");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String role = request.getParameter("role");

        // Input validation
        if (fullName == null || fullName.isEmpty()
                || username == null || username.isEmpty()
                || phone == null || phone.isEmpty()
                || street == null || street.isEmpty()
                || postcode == null || postcode.isEmpty()
                || city == null || city.isEmpty()
                || state == null || state.isEmpty()
                || country == null || country.isEmpty()
                || password == null || password.isEmpty()
                || confirmPassword == null || confirmPassword.isEmpty()
                || role == null || role.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Save to database
        try (Connection conn = dbconnection.getConnection()) {
            String sql = "INSERT INTO address (country, postalCode, street, city, state) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, country);
                stmt.setInt(2, Integer.parseInt(postcode));
                stmt.setString(3, street);
                stmt.setString(4, city);
                stmt.setString(5, state);

                int rowsInserted = stmt.executeUpdate();

                if (rowsInserted > 0) {
                    ResultSet rs = stmt.getGeneratedKeys();
                    rs.next();
                    int addressID = rs.getInt(1);
                    if (role.equals("volunteer")) {

                        String sql1 = "INSERT INTO volunteer (name, contactInfo, username, password, addressID) VALUES (?, ?, ?, ?, ?)";
                        try (PreparedStatement stmt1 = conn.prepareStatement(sql1)) {
                            stmt1.setString(1, fullName);
                            stmt1.setInt(2, Integer.parseInt(phone));
                            stmt1.setString(3, username);
                            stmt1.setString(4, password);
                            stmt1.setInt(5, addressID);
                            // Hash in production

                            int rows = stmt1.executeUpdate();

                            if (rows > 0) {
                                response.sendRedirect("login.jsp");
                            } else {
                                request.setAttribute("error", "Registration failed. Please try again.");
                                request.getRequestDispatcher("register.jsp").forward(request, response);
                            }
                        }

                    } else if (role.equals("beneficiary")) {

                        String sql2 = "INSERT INTO beneficiary (name, contactInfo, username, password, addressID) VALUES (?, ?, ?, ?, ?)";
                        try (PreparedStatement stmt2 = conn.prepareStatement(sql2)) {
                            stmt2.setString(1, fullName);
                            stmt2.setInt(2, Integer.parseInt(phone));
                            stmt2.setString(3, username);
                            stmt2.setString(4, password);
                            stmt2.setInt(5, addressID); // Hash in production

                            int rows2 = stmt2.executeUpdate();
                            if (rows2 > 0) {
                                response.sendRedirect("login.jsp");
                            } else {
                                request.setAttribute("error", "Registration failed. Please try again.");
                                request.getRequestDispatcher("register.jsp").forward(request, response);
                            }
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error: " + e.getMessage());
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            Logger.getLogger(registerServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(registerServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
