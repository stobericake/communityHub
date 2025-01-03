/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import com.cm.model.address;
import com.cm.model.beneficiary;
import com.cm.model.events;
import com.cm.model.task;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Rina
 */
public class vEventDetail extends HttpServlet {

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
            out.println("<title>Servlet vEventDetail</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet vEventDetail at " + request.getContextPath() + "</h1>");
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
        int volunteerId = Integer.parseInt(request.getSession().getAttribute("volunteer").toString());
        if (volunteerId == 0) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        } 
        int eventID = Integer.parseInt(request.getParameter("eventID"));
        if (eventID == 0) {
            response.sendRedirect(request.getContextPath() + "/volunteer/newListingEvent.jsp");
            return;
        } 
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        events event = null;
        address addressObj = null;
        beneficiary beneficiaryObj = null;
        double donationLimit  = 0.0;
        PreparedStatement donationStmt = null;
        ResultSet donationRs = null;
        
        try {
            conn = dbconnection.getConnection();
            if (conn == null) {
                    System.out.println("DB Connection: " + (conn != null));
                    return;
                }
            
            // Fetch event details
            String sql = "SELECT * FROM events e " +
                         "INNER JOIN address a ON e.addressID = a.addressID " +
                         "INNER JOIN beneficiary b ON e.beneficiaryID = b.beneficiaryID WHERE e.eventID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, eventID);
            rs = stmt.executeQuery();

             // Retrieve event details
                Date startDate = rs.getDate("e.eventDate");
                Time eTime = rs.getTime("e.eventTime");
                Time eDuration = rs.getTime("e.duration");
                
                SimpleDateFormat outputFormat = new SimpleDateFormat("MM/dd/yyyy - hh:mma");
                SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd");

                // Convert eventDate to LocalDate
                LocalDate eventLocalDate = new java.util.Date(startDate.getTime()).toInstant().atZone(ZoneId.systemDefault()).toLocalDate();

                // Convert SQL Time to LocalTime
                LocalTime startTime = eTime.toLocalTime();
                LocalTime duration = eDuration.toLocalTime();

                // Calculate the event's end time
                LocalTime endTime = startTime.plusHours(duration.getHour()).plusMinutes(duration.getMinute());

                // Format the date and time for display
                String formattedDate = inputDateFormat.format(startDate);
                String formattedStartTime = outputFormat.format(eTime);
                String formattedEndTime = outputFormat.format(Time.valueOf(endTime));

                // Calculate days left from the current date to the event date
                LocalDate currentDate = LocalDate.now();
                long daysLeft = ChronoUnit.DAYS.between(currentDate, eventLocalDate);           
            

            if (rs.next()) {
            // Populate the event object
            int eventIDFromDB = rs.getInt("eventID");
            String eventName = rs.getString("name");
            Date eventDate = rs.getDate("date");
            Time eventTime = rs.getTime("time");
            Time eventDuration = rs.getTime("duration");
            String description = rs.getString("description");
            int volunteersNeeded = rs.getInt("volunteersNeeded");
            String status = rs.getString("status");
            Blob image = rs.getBlob("image");
            donationLimit = rs.getDouble("donationLimit");
            int addressIdFromDB = rs.getInt("addressID");

            // Create the events object
            event = new events(eventIDFromDB, eventName, eventDate, eventTime, eventDuration,
                               description, volunteersNeeded, status, image, donationLimit, addressIdFromDB);
            // Populate the address object
            int addressID = rs.getInt("addressID");
            String country = rs.getString("country");
            int postalCode = rs.getInt("postalCode");
            String street = rs.getString("street");
            String city = rs.getString("city");
            String state = rs.getString("state");
            addressObj = new address(addressID, country, postalCode, street, city, state);

            // Populate the beneficiary object
            int beneficiaryID = rs.getInt("beneficiaryID");
            String beneficiaryName = rs.getString("name");
            beneficiaryObj = new beneficiary(beneficiaryID, beneficiaryName);

        }
            List<task> taskList = new ArrayList<>();
            String taskSql = "SELECT * FROM task WHERE eventID = ?";
            PreparedStatement taskStmt = conn.prepareStatement(taskSql);
            taskStmt.setInt(1, eventID);
            ResultSet taskRs = taskStmt.executeQuery();
            while (taskRs.next()) {
                int taskId = taskRs.getInt("taskID");
                String taskDescription = taskRs.getString("description");
                taskList.add(new task(taskId, taskDescription));
            }
            request.setAttribute("events", event);
            request.setAttribute("address", addressObj);
            request.setAttribute("beneficiary", beneficiaryObj);
            request.setAttribute("tasks", taskList);
            request.setAttribute("formattedDate", formattedDate);
            request.setAttribute("formattedStartTime", formattedStartTime);
            request.setAttribute("formattedEndTime", formattedEndTime);
            request.setAttribute("daysLeft", daysLeft);

            // Fetch donation details
            double totalDonation = 0;
            String donationSql = "SELECT SUM(amount) AS totalDonation FROM donation WHERE eventID = ?";
            donationStmt = conn.prepareStatement(donationSql);
            donationStmt.setInt(1, eventID);
            donationRs = donationStmt.executeQuery();
            if (donationRs.next()) {
                totalDonation = donationRs.getDouble("totalDonation");
                }
                        
            // Fetch the total number of contributors (donors)
            String contributorsQuery = "SELECT COUNT(DISTINCT donorID) AS totalContributors FROM donation WHERE eventID = ?";
            PreparedStatement contributorsStmt = conn.prepareStatement(contributorsQuery);
            contributorsStmt.setInt(1, eventID);
            ResultSet contributorsRs = contributorsStmt.executeQuery();
            int totalContributors = 0;
            if (contributorsRs.next()) {
            totalContributors = contributorsRs.getInt("totalContributors");
            }
            double remainingAmount = donationLimit - totalDonation;
            double progress = (totalDonation / donationLimit) * 100;
            
            request.setAttribute("totalDonation", totalDonation);
            request.setAttribute("totalContributors", totalContributors);
            request.setAttribute("remainingAmount", remainingAmount);
            request.setAttribute("progress", progress);
            
            request.getRequestDispatcher("/eventDetail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while fetching events.");
            request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
