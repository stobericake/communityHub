/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author HAZIQ
 */
public class AdminEventReport extends HttpServlet {

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
            out.println("<title>Servlet AdminEventReport</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminEventReport at " + request.getContextPath() + "</h1>");
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
        String eventID = request.getParameter("eventID");
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbconnection.getConnection();

            // Fetch event details
            String eventQuery = "SELECT e.*, a.city, a.state, "
                    + "(SELECT COUNT(*) FROM eventsvolunteer ev WHERE ev.eventID = e.eventID) AS volunteerCount "
                    + "FROM events e JOIN address a ON e.addressID = a.addressID WHERE e.eventID = ?";
            stmt = conn.prepareStatement(eventQuery);
            stmt.setInt(1, Integer.parseInt(eventID));
            rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("eventName", rs.getString("name"));
                request.setAttribute("eventDate", rs.getDate("date"));
                request.setAttribute("eventTime", rs.getTime("time"));
                request.setAttribute("eventDuration", rs.getTime("duration"));
                request.setAttribute("city", rs.getString("city"));
                request.setAttribute("state", rs.getString("state"));
                request.setAttribute("volunteerCount", rs.getInt("volunteerCount"));
            }

            rs.close();

            // Fetch service report details
            String serviceQuery = "SELECT * FROM servicereport WHERE eventID = ?";
            stmt = conn.prepareStatement(serviceQuery);
            stmt.setInt(1, Integer.parseInt(eventID));
            rs = stmt.executeQuery();

            ArrayList<String> feedbackList = new ArrayList<>();
            ArrayList<String> challengeList = new ArrayList<>();
            ArrayList<String> solutionList = new ArrayList<>();
            ArrayList<String> recommendationList = new ArrayList<>();

            while (rs.next()) {
                feedbackList.add(rs.getString("feedback"));
                challengeList.add(rs.getString("challenge"));
                solutionList.add(rs.getString("solution"));
                recommendationList.add(rs.getString("recommendation"));
            }

            request.setAttribute("feedbackList", feedbackList);
            request.setAttribute("challengeList", challengeList);
            request.setAttribute("solutionList", solutionList);
            request.setAttribute("recommendationList", recommendationList);

            // Forward to JSP
            request.getRequestDispatcher("admin/reportEvent.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AdminEventReport.class.getName()).log(Level.SEVERE, null, ex);
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
