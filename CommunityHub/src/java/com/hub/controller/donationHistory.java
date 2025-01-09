/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import com.cm.model.donation;
import com.cm.model.events;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
/**
 *
 * @author Rina
 */
public class donationHistory extends HttpServlet {

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
            out.println("<title>Servlet donationHistory</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet donationHistory at " + request.getContextPath() + "</h1>");
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
        int volunteerId = Integer.parseInt(request.getSession().getAttribute("volunteer").toString());
        List<events> eventList = new ArrayList<>();
        List<donation> donationList = new ArrayList<>();
        double totalDonation = 0;
        double latestDonation = 0;
        int itemsPerPage = 5;
        int currentPage = 1;
        int totalPages = 0;
        int totalDonations = 0;
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            currentPage = Integer.parseInt(pageParam);
        }

        try {
            conn = dbconnection.getConnection();
            // Fetch total donation amount
            String totalDonationQuery = "SELECT SUM(amount) AS totalDonation FROM donation WHERE volunteerID = ?";
            stmt = conn.prepareStatement(totalDonationQuery);
            stmt.setInt(1, volunteerId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                totalDonation = rs.getDouble("totalDonation");
             }
             rs.close();
             stmt.close();
                
            

            // Fetch the latest donation
            String latestDonationQuery = "SELECT amount FROM donation WHERE volunteerID = ? ORDER BY date DESC LIMIT 1";
            stmt = conn.prepareStatement(latestDonationQuery);
            stmt.setInt(1, volunteerId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                latestDonation = rs.getDouble("amount");
            }
            rs.close();
            stmt.close();
                
            // Get total number of donations
            String countQuery = "SELECT COUNT(*) AS total FROM donation WHERE volunteerID = ?";
            stmt = conn.prepareStatement(countQuery);
            stmt.setInt(1, volunteerId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                totalDonations = rs.getInt("total");
                totalPages = (int) Math.ceil((double) totalDonations / itemsPerPage);
            }
            rs.close();
            stmt.close();

            // Fetch donation history with pagination
            String donationHistoryQuery = "SELECT *" + 
                "FROM donation d JOIN events e ON d.eventID = e.eventID " + 
                "WHERE d.volunteerID = ? " + 
                "ORDER BY d.date DESC LIMIT ? OFFSET ?";
            stmt = conn.prepareStatement(donationHistoryQuery);
            stmt.setInt(1, volunteerId);
            stmt.setInt(2, itemsPerPage);
            stmt.setInt(3, (currentPage - 1) * itemsPerPage);
            rs = stmt.executeQuery();
            while (rs.next()) {
                donation donation = new donation(
                        rs.getInt("donationID"),
                        rs.getInt("eventID"),
                        rs.getInt("donorID"),
                        rs.getInt("volunteerID"),
                        rs.getDouble("amount"),
                        rs.getDate("d.date"),
                        rs.getBlob("receiptImage")
                );
                donationList.add(donation);
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
                    eventList.add(event);
                }
                
        

        // Set attributes for the JSP
        request.setAttribute("totalDonation", totalDonation);
        request.setAttribute("latestDonation", latestDonation);
        request.setAttribute("totalDonations", totalDonations);
        request.setAttribute("eventList", eventList);
        request.setAttribute("donationList", donationList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Forward to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/volunteer/donationHistory.jsp");
        dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }  finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
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
