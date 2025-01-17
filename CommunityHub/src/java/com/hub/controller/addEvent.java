/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.net.URLEncoder;
import java.nio.file.Paths;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author anaqi
 */
@MultipartConfig
public class addEvent extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet addEvent</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet addEvent at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data
        String eventName = request.getParameter("eventName");
        String eventDescription = request.getParameter("eventDescription");
        String eventDate = request.getParameter("eventDate");
        String eventTime = request.getParameter("eventTime");
        String city = request.getParameter("city");
        String country = request.getParameter("country");
        String postalCode = request.getParameter("postalCode");
        String state = request.getParameter("state");
        String street = request.getParameter("street");
        int numParticipants = Integer.parseInt(request.getParameter("numParticipants"));
        double donationLimit = Double.parseDouble(request.getParameter("donationLimit"));
        String[] task = request.getParameterValues("newTask");

        Part filePart = request.getPart("eventImage"); // Get the image file from the form

        // Create an InputStream from the uploaded file
        InputStream imageInputStream = filePart.getInputStream();

        String hoursStr = request.getParameter("durationHours");
        String minutesStr = request.getParameter("durationMinutes");
        String secondsStr = "0";

        // Step 2: Parse the input values to integers, ensuring defaults to zero if empty
        int hours = hoursStr != null && !hoursStr.isEmpty() ? Integer.parseInt(hoursStr) : 0;
        int minutes = minutesStr != null && !minutesStr.isEmpty() ? Integer.parseInt(minutesStr) : 0;
        int seconds = secondsStr != null && !secondsStr.isEmpty() ? Integer.parseInt(secondsStr) : 0;

        // Step 3: Validate input ranges (hours can be any integer, minutes and seconds must be between 0 and 59)
        if (minutes < 0 || minutes >= 60 || seconds < 0 || seconds >= 60) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid duration values. Minutes and seconds must be between 0 and 59.");
            return;
        }

        // Step 4: Create a Time object from hours, minutes, and seconds
        // Note: Time is stored in the format 'HH:mm:ss'
        String timeString = String.format("%02d:%02d:%02d", hours, minutes, 00);
        Time duration = Time.valueOf(timeString);

        // Establish DB connection
        Connection conn = null;
        PreparedStatement psEvent = null, psAddress = null, psTask = null;
        ResultSet rs = null;

        HttpSession session = request.getSession();
        String beneficiaryID = session.getAttribute("beneficiary").toString();

        try {
            conn = dbconnection.getConnection();
            conn.setAutoCommit(false);  // Start transaction

            String sqlCheckAddress = "SELECT addressID FROM address WHERE UPPER(city) = UPPER(?) AND UPPER(country) = (?) "
                    + "AND postalCode = ? AND UPPER(state = ?) AND UPPER(street) = (?)";
            psAddress = conn.prepareStatement(sqlCheckAddress);
            psAddress.setString(1, city);
            psAddress.setString(2, country);
            psAddress.setInt(3, Integer.parseInt(postalCode));
            psAddress.setString(4, state);
            psAddress.setString(5, street);

            rs = psAddress.executeQuery();

            int addressID;

            if (rs.next()) {
                addressID = rs.getInt("addressID");
            } else {
                String sqlAddress = "INSERT INTO address (city, country, postalCode, state, street) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement psInsertAddress = conn.prepareStatement(sqlAddress, Statement.RETURN_GENERATED_KEYS)) {
                    psInsertAddress.setString(1, city);
                    psInsertAddress.setString(2, country);
                    psInsertAddress.setInt(3, Integer.parseInt(postalCode));
                    psInsertAddress.setString(4, state);
                    psInsertAddress.setString(5, street);
                    psInsertAddress.executeUpdate();

                    try (ResultSet generatedKeys = psInsertAddress.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            addressID = generatedKeys.getInt(1);
                        } else {
                            throw new SQLException("Address insertion failed, no ID obtained.");
                        }
                    }
                }
            }

                    // Insert event data
                    String sqlEvent = "INSERT INTO events (name, date, time, duration, description,"
                            + " volunteerNeeded, donationLimit, status, beneficiaryID, addressID, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    psEvent = conn.prepareStatement(sqlEvent, Statement.RETURN_GENERATED_KEYS);
                    psEvent.setString(1, eventName);
                    psEvent.setDate(2, Date.valueOf(eventDate));
                    psEvent.setTime(3, Time.valueOf(eventTime + ":00"));
                    psEvent.setTime(4, duration);
                    psEvent.setString(5, eventDescription);
                    psEvent.setInt(6, numParticipants);
                    psEvent.setDouble(7, donationLimit);
                    psEvent.setInt(8, 1);
                    psEvent.setInt(9, Integer.parseInt(beneficiaryID));
                    psEvent.setInt(10, addressID);
                    psEvent.setBlob(11, imageInputStream);

                    int eventRows = psEvent.executeUpdate();
                    if (eventRows > 0) {
                        // Get the generated event ID
                        ResultSet eventRs = psEvent.getGeneratedKeys();
                        if (eventRs.next()) {
                            int eventID = eventRs.getInt(1);

                            // Insert tasks
                            String sqlTask = "INSERT INTO task (status, description, eventID, volunteerID) VALUES (?, ?, ?, ?)";
                            psTask = conn.prepareStatement(sqlTask);

                            // Retrieve tasks dynamically
                            for (String addTask : task) {

                                psTask.setInt(1, 0);
                                psTask.setString(2, addTask);
                                psTask.setInt(3, eventID);
                                psTask.setNull(4, java.sql.Types.NULL);
                                psTask.addBatch();
                            }

                            // Execute batch task insertions
                            if (psTask != null) {
                                psTask.executeBatch();
                            }
                        }

                        // Commit transaction
                        conn.commit();

                        // Redirect to event listing page
                        // Create the success message
                        String message = "The Event Name: " + eventName + " Successfully created";

                        // URL encode the message to handle special characters
                        String encodedMessage = URLEncoder.encode(message, "UTF-8");

                        // Redirect to success.jsp with the encoded message
                        response.sendRedirect("success.jsp?msg=" + encodedMessage);
                        return;
                    }
                
            

            // If we reach here, something went wrong
            response.getWriter().println("Error: Event could not be created.");
            conn.rollback();

        } catch (SQLException e) {
            // Rollback the transaction in case of error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(addEvent.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                // Reset to default commit behavior
                if (conn != null) {
                    conn.setAutoCommit(true);
                }

                // Close resources
                if (psEvent != null) {
                    psEvent.close();
                }
                if (psAddress != null) {
                    psAddress.close();
                }
                if (psTask != null) {
                    psTask.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
