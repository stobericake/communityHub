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
//        if (volunteerId == 0) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp");
//            return;
//        } 
        int eventID = Integer.parseInt(request.getParameter("eventID"));
//        if (eventID == 0) {
//            response.sendRedirect(request.getContextPath() + "/volunteer/newListingEvent.jsp");
//            return;
//        } 
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        events event = null;
        address address = null;
        beneficiary beneficiary = null;
        PreparedStatement donationStmt = null;
        ResultSet donationRs = null;
        List<task> taskList = new ArrayList<>();
        
        if (eventID != 0 ) {
                try {
                    conn = dbconnection.getConnection();
                    String sql = "SELECT * FROM events e " +
                                 "INNER JOIN address a ON e.addressID = a.addressID " +
                                 "INNER JOIN beneficiary b ON e.beneficiaryID = b.beneficiaryID WHERE e.eventID = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, eventID);
                    rs = stmt.executeQuery();

                if (rs.next()) {
                event = new events(
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
                address = new address(
                                rs.getInt("addressID"),
                                rs.getString("country"),
                                rs.getInt("postalCode"),
                                rs.getString("street"),
                                rs.getString("city"),
                                rs.getString("state")
                        );

                beneficiary = new beneficiary(
                        rs.getInt("beneficiaryID"), 
                        rs.getString("b.name")
                );

                String taskSql = "SELECT * FROM task WHERE eventID = ?";
                PreparedStatement taskStmt = conn.prepareStatement(taskSql);
                taskStmt.setInt(1, eventID);
                ResultSet taskRs = taskStmt.executeQuery();
                while (taskRs.next()) {
                    int taskId = taskRs.getInt("taskID");
                    String taskDescription = taskRs.getString("description");
                    taskList.add(new task(taskId, taskDescription, volunteerId));
                }
                

                    SimpleDateFormat outputFormat = new SimpleDateFormat("MM/dd/yyyy - hh:mma");
                    SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd");

                    // Convert eventDate to LocalDate
                    LocalDate eventLocalDate = new java.util.Date(rs.getDate("date").getTime())
                            .toInstant()
                            .atZone(ZoneId.systemDefault())
                            .toLocalDate();

                    // Convert SQL Time to LocalTime
                    LocalTime startTime = rs.getTime("time").toLocalTime();
                    LocalTime duration = rs.getTime("duration").toLocalTime();

                    // Calculate the event's end time
                    LocalTime endTime = startTime.plusHours(duration.getHour()).plusMinutes(duration.getMinute());

                    // Format the date and time for display
                    String formattedDate = inputDateFormat.format(rs.getDate("date"));
                    String formattedStartTime = outputFormat.format(rs.getTime("time"));
                    String formattedEndTime = outputFormat.format(Time.valueOf(endTime));

                    // Calculate days left from the current date to the event date
                    LocalDate currentDate = LocalDate.now();
                    long daysLeft = ChronoUnit.DAYS.between(currentDate, eventLocalDate); 
                    
                    request.setAttribute("formattedDate", formattedDate);
                    request.setAttribute("formattedStartTime", formattedStartTime);
                    request.setAttribute("formattedEndTime", formattedEndTime);
                    request.setAttribute("daysLeft", daysLeft);
                    request.setAttribute("event", event);
                    request.setAttribute("address", address);
                    request.setAttribute("beneficiary", beneficiary);
                    request.setAttribute("tasks", taskList);
                }
      
            
            // Fetch donation details
           double donationLimit  = rs.getDouble("donationLimit");

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
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }    }}

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
