package com.hub.controller;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.cm.model.address;
import com.cm.model.beneficiary;
import com.cm.model.events;
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

            if (eventID != 0) {
                try {
                    conn = dbconnection.getConnection();
                    String sql = "SELECT* FROM events e "
                            + "INNER JOIN address a ON e.addressID = a.addressID "
                            + "INNER JOIN eventsVolunteer ev ON e.eventID = ev.eventID "
                            + "INNER JOIN task t ON ev.volunteerID = t.volunteerID AND e.eventID = t.eventID "
                            + "INNER JOIN beneficiary b ON e.beneficiaryID = b.beneficiaryID WHERE e.eventID = ?";
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
                        tasks = new task(
                             rs.getInt("taskID"),
                             rs.getString("t.description"),
                             rs.getInt("t.volunteerID")
                        );

                        SimpleDateFormat outputFormat = new SimpleDateFormat("hh:mma");
                        SimpleDateFormat inputDateFormat = new SimpleDateFormat("MM/dd/yyyy - ");

                        // Convert `eventDate` to LocalDate (compatible approach)
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
                        String formattedStartTime = outputFormat.format(rs.getDate("time"));
                        String formattedEndTime = outputFormat.format(Time.valueOf(endTime));
                        
                        request.setAttribute("formattedDate", formattedDate);
                        request.setAttribute("formattedStartTime", formattedStartTime);
                        request.setAttribute("formattedEndTime", formattedEndTime);
                        request.setAttribute("event", event);
                        request.setAttribute("address", address);
                        request.setAttribute("beneficiary", beneficiary);
                        request.setAttribute("task", tasks);
                        
                        request.getRequestDispatcher("/volunteer/myEventDetail.jsp").forward(request, response);
                        } 
            } catch (SQLException e) {
                e.printStackTrace();
            }   catch (ClassNotFoundException ex) {
                    Logger.getLogger(myEventDetail.class.getName()).log(Level.SEVERE, null, ex);
                } finally {
                // Close resources manually
                try {
                    if (taskRs != null) {
                        taskRs.close();
                    }
                    if (taskStmt != null) {
                        taskStmt.close();
                    }
                    if (donationRs != null) {
                        donationRs.close();
                    }
                    if (donationStmt != null) {
                        donationStmt.close();
                    }
                    if (rs != null) {
                        rs.close();
                    }
                    if (stmt != null) {
                        stmt.close();
                    }
                    if (conn != null) {
                        conn.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
                } else { }
                        
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
