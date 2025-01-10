/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author HAZIQ
 */
public class GenerateCertificate extends HttpServlet {

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
            out.println("<title>Servlet GenerateCertificate</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GenerateCertificate at " + request.getContextPath() + "</h1>");
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
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("volunteer") == null) {
            out.println("Error: No volunteer ID found in session.");
            return;
        }

        int volunteerID = (Integer) session.getAttribute("volunteer");

        String eventIDParam = request.getParameter("eventID");
        if (eventIDParam == null || eventIDParam.isEmpty()) {
            out.println("Error: Event ID is required.");
            return;
        }

        int eventID;
        try {
            eventID = Integer.parseInt(eventIDParam);
        } catch (NumberFormatException e) {
            out.println("Error: Invalid event ID format.");
            return;
        }

        try {
            conn = dbconnection.getConnection();

            String query = "SELECT e.name AS eventName, e.date, e.description, "
                    + "b.name AS beneficiaryName, v.name AS volunteerName "
                    + "FROM events e "
                    + "JOIN beneficiary b ON e.beneficiaryID = b.beneficiaryID "
                    + "JOIN volunteer v ON v.volunteerID = ? "
                    + "WHERE e.eventID = ?";

            stmt = conn.prepareStatement(query);
            stmt.setInt(1, volunteerID);
            stmt.setInt(2, eventID);

            rs = stmt.executeQuery();

            if (rs.next()) {
                String eventName = rs.getString("eventName");
                Date eventDate = rs.getDate("date");
                String eventDescription = rs.getString("description");
                String beneficiaryName = rs.getString("beneficiaryName");
                String volunteerName = rs.getString("volunteerName");

                request.setAttribute("eventName", eventName);
                request.setAttribute("eventDate", eventDate);
                request.setAttribute("eventDescription", eventDescription);
                request.setAttribute("beneficiaryName", beneficiaryName);
                request.setAttribute("volunteerName", volunteerName);

                RequestDispatcher dispatcher = request.getRequestDispatcher("volunteer/certificate.jsp");
                dispatcher.forward(request, response);
            } else {
                out.println("Error: No matching records found.");
            }

        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(GenerateCertificate.class.getName()).log(Level.SEVERE, null, e);
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
                Logger.getLogger(GenerateCertificate.class.getName()).log(Level.SEVERE, null, e);
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
