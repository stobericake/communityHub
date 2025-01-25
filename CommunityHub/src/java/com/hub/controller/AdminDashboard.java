/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import com.cm.model.events;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author HAZIQ
 */
public class AdminDashboard extends HttpServlet {

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
            out.println("<title>Servlet AdminDashboard</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminDashboard at " + request.getContextPath() + "</h1>");
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = dbconnection.getConnection()) {
            // Fetch counts
            int totalAdmins = getCount(conn, "SELECT COUNT(*) FROM admin");
            int totalVolunteers = getCount(conn, "SELECT COUNT(*) FROM volunteer");
            int totalBeneficiaries = getCount(conn, "SELECT COUNT(*) FROM beneficiary");
            int totalEvents = getCount(conn, "SELECT COUNT(*) FROM events");
            int completedEvents = getCount(conn,
                    "SELECT COUNT(*) FROM events WHERE MONTH(date) = MONTH(CURDATE()) AND YEAR(date) = YEAR(CURDATE())");
            int pendingApprovals = getCount(conn, "SELECT COUNT(*) FROM events WHERE status = 1");
            double totalDonations = getTotalDonations(conn);
            

            // Fetch recent events
            ArrayList<events> recentEvents = getRecentEvents(conn);

            // Set attributes
            request.setAttribute("totalAdmins", totalAdmins);
            request.setAttribute("totalVolunteers", totalVolunteers);
            request.setAttribute("totalBeneficiaries", totalBeneficiaries);
            request.setAttribute("totalEvents", totalEvents);
            request.setAttribute("completedEvents", completedEvents);
            request.setAttribute("pendingApprovals", pendingApprovals);
            request.setAttribute("totalDonations", totalDonations);
            request.setAttribute("recentEvents", recentEvents);

            request.getRequestDispatcher("admin/adminDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private double getTotalDonations(Connection conn) throws Exception {
        String query = "SELECT SUM(amount) AS total_donations FROM donation";
        try (PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getDouble("total_donations") : 0.0;
        }
    }

    private int getCount(Connection conn, String query) throws Exception {
        try (PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private ArrayList<events> getRecentEvents(Connection conn) throws Exception {
        ArrayList<events> eventsList = new ArrayList<>();
        String query = "SELECT * FROM events ORDER BY eventID DESC LIMIT 3";
        try (PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                events event = new events(
                        rs.getInt("eventID"),
                        rs.getString("name"),
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
                eventsList.add(event);
            }
        }
        return eventsList;
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
