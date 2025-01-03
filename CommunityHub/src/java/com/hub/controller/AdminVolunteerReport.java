/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.cm.model.events;
import com.cm.model.eventsVolunteer;
import com.cm.model.task;
import com.cm.model.donation;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author HAZIQ
 */
public class AdminVolunteerReport extends HttpServlet {

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
            out.println("<title>Servlet AdminVolunteerReport</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminVolunteerReport at " + request.getContextPath() + "</h1>");
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
        String volunteerID = request.getParameter("volunteerID");
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbconnection.getConnection();

            // First query - Get volunteer basic info
            String sql = "SELECT name FROM volunteer WHERE volunteerID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(volunteerID));
            rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("volunteerName", rs.getString("name"));
                request.setAttribute("volunteerID", volunteerID);
            }

            // Second query - Get detailed participation data
            String sql2 = "SELECT v.name AS volunteerName, e.name AS eventName, "
                    + "e.date AS eventDate, e.time AS eventTime, e.duration AS eventDuration, "
                    + "t.description AS taskDescription, d.amount AS donationAmount, "
                    + "d.date AS donationDate "
                    + "FROM events e "
                    + "JOIN eventsvolunteer ev ON e.eventID = ev.eventID "
                    + "JOIN volunteer v ON ev.volunteerID = v.volunteerID "
                    + "LEFT JOIN task t ON t.volunteerID = v.volunteerID AND t.eventID = e.eventID "
                    + "LEFT JOIN donation d ON d.volunteerID = v.volunteerID AND d.eventID = e.eventID "
                    + "WHERE v.volunteerID = ?";

            stmt = conn.prepareStatement(sql2);
            stmt.setInt(1, Integer.parseInt(volunteerID));
            rs = stmt.executeQuery();

            ArrayList<events> eventsList = new ArrayList<>();
            ArrayList<String> tasks = new ArrayList<>();
            double totalDonation = 0;
            double recentDonation = 0;
            int totalHours = 0;

            while (rs.next()) {
                if (rs.getString("taskDescription") != null) {
                    tasks.add(rs.getString("taskDescription")); // Add task description to the list
                }

                events event = new events(
                        rs.getString("eventName"),
                        rs.getDate("eventDate"),
                        rs.getTime("eventTime"),
                        rs.getTime("eventDuration")
                );
                eventsList.add(event);
                 if (rs.getTime("eventDuration") != null) {
                    totalHours += rs.getTime("eventDuration").toLocalTime().getHour();
                }

                // Populate donations
                if (rs.getDouble("donationAmount") > 0) {
                    totalDonation += rs.getDouble("donationAmount");
                    recentDonation = rs.getDouble("donationAmount");
                }
            }

            request.setAttribute("events", eventsList);
            request.setAttribute("tasks", tasks);
            request.setAttribute("totalEvents", eventsList.size());
            request.setAttribute("totalHours", totalHours);
            request.setAttribute("totalDonation", totalDonation);
            request.setAttribute("recentDonation", recentDonation);

            // Forward to JSP
            request.getRequestDispatcher("admin/reportVolunteer.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AdminVolunteerReport.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
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
