package com.hub.controller;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.cm.model.address;
import com.cm.model.beneficiary;
import com.cm.model.events;
import com.cm.model.eventsVolunteer;
import com.cm.model.task;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Rina
 */
public class myEventDetail extends HttpServlet {

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
            out.println("<title>Servlet myEventDetail</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet myEventDetail at " + request.getContextPath() + "</h1>");
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
        int eventID = Integer.parseInt(request.getParameter("eventID"));
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        PreparedStatement taskStmt = null;
        ResultSet taskRs = null;
        PreparedStatement donationStmt = null;
        ResultSet donationRs = null;
        events event = null;
        address address = null;
        beneficiary beneficiary = null;
        task tasks = null;
        eventsVolunteer ev = null;

        if (eventID != 0) {
            try {
                conn = dbconnection.getConnection();

                // Fetch event details with LEFT JOIN for task to handle null tasks
                String sql = "SELECT e.*, a.*, ev.*, b.*, t.taskID, t.description AS taskDescription " +
                             "FROM events e " +
                             "INNER JOIN address a ON e.addressID = a.addressID " +
                             "INNER JOIN eventsVolunteer ev ON e.eventID = ev.eventID " +
                             "INNER JOIN beneficiary b ON e.beneficiaryID = b.beneficiaryID " +
                             "LEFT JOIN task t ON ev.volunteerID = t.volunteerID AND e.eventID = t.eventID " +
                             "WHERE e.eventID = ? AND ev.volunteerID = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, eventID);
                stmt.setInt(2, volunteerId);
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

                    ev = new eventsVolunteer(
                            rs.getInt("eventsVolunteerID"),
                            rs.getInt("eventID"),
                            rs.getInt("volunteerID"),
                            rs.getInt("attendance")
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

                    // Handle null task (Crew)
                    int taskID = rs.getInt("taskID");
                    String taskDescription = rs.getString("taskDescription");
                    if (rs.wasNull()) { // Check if taskID or taskDescription is null
                        taskDescription = "Crew"; // Default to "Crew" if no task is assigned
                    }

                    tasks = new task(
                            taskID,
                            taskDescription,
                            volunteerId
                    );

                    // Format date and time
                    SimpleDateFormat outputFormat = new SimpleDateFormat("hh:mma");
                    SimpleDateFormat inputDateFormat = new SimpleDateFormat("dd/MM/yyyy");

                    LocalDate eventLocalDate = new java.util.Date(rs.getDate("date").getTime())
                            .toInstant()
                            .atZone(ZoneId.systemDefault())
                            .toLocalDate();

                    LocalTime startTime = rs.getTime("time").toLocalTime();
                    LocalTime duration = rs.getTime("duration").toLocalTime();
                    LocalTime endTime = startTime.plusHours(duration.getHour()).plusMinutes(duration.getMinute());

                    String formattedDate = inputDateFormat.format(rs.getDate("date"));
                    String formattedStartTime = outputFormat.format(rs.getTime("time"));
                    String formattedEndTime = outputFormat.format(Time.valueOf(endTime));

                    request.setAttribute("formattedDate", formattedDate);
                    request.setAttribute("formattedStartTime", formattedStartTime);
                    request.setAttribute("formattedEndTime", formattedEndTime);
                    request.setAttribute("event", event);
                    request.setAttribute("address", address);
                    request.setAttribute("beneficiary", beneficiary);
                    request.setAttribute("task", tasks);
                    request.setAttribute("eventsVolunteer", ev);
                    
                    // Fetch donation details
                double donationLimit = rs.getDouble("donationLimit");

                double totalDonation = 0;
                String donationSql = "SELECT SUM(amount) AS totalDonation FROM donation WHERE eventID = ?";
                donationStmt = conn.prepareStatement(donationSql);
                donationStmt.setInt(1, eventID);
                donationRs = donationStmt.executeQuery();
                if (donationRs.next()) {
                    totalDonation = donationRs.getDouble("totalDonation");
                }

                // Fetch the total number of contributors (donors)
                String contributorsQuery = "SELECT COUNT(DISTINCT donationID) AS totalContributors FROM donation WHERE eventID = ?";
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

                    request.getRequestDispatcher("/volunteer/myEventDetail.jsp").forward(request, response);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(myEventDetail.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                // Close resources manually
                try {
                    if (taskRs != null) taskRs.close();
                    if (taskStmt != null) taskStmt.close();
                    if (donationRs != null) donationRs.close();
                    if (donationStmt != null) donationStmt.close();
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            // Handle case where eventID is 0
        }
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
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Check if eventId and status are provided
            String eventIdParam = request.getParameter("eventId");
            String attendanceParam = request.getParameter("attendance");

            if (eventIdParam == null || attendanceParam == null) {
                response.sendRedirect("index.jsp?msg=missing_params");
                return;
            }

            // Parse eventId and status, handling invalid input
            int eventId = 0;
            int attendance = 0;

            try {
                eventId = Integer.parseInt(eventIdParam);
                attendance = Integer.parseInt(attendanceParam);
            } catch (NumberFormatException e) {
                response.sendRedirect("index.jsp?msg=invalid_input");
                return;
            }

            if (attendance != 0 && attendance != 1 && attendance != 2) {
                response.sendRedirect("index.jsp?msg=invalid_status");
                return;
            }

            Integer volunteerID = (Integer) request.getSession().getAttribute("volunteer");
            if (volunteerID == null) {
                response.sendRedirect("index.jsp?msg=not_logged_in");
                return;
            }
            
            // Database connection
            conn = dbconnection.getConnection();
            String sql = "UPDATE eventsVolunteer SET attendance = ? WHERE eventID = ? AND volunteerID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, attendance);
            stmt.setInt(2, eventId);
            stmt.setInt(3, volunteerID);

            // Execute the update
            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("success.jsp?msg=SAttendance Recorded");
//                RequestDispatcher view = request.getRequestDispatcher("/success.jsp");
//                view.forward(request, response);
            } else {
                response.sendRedirect("index.jsp?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?msg=exception");
        } finally {
            // Clean up resources
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
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
