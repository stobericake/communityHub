/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.hub.controller.dbconnection;
/**
 *
 * @author HAZIQ
 */
public class volunteerServlet1 extends HttpServlet {

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
            out.println("<title>Servlet volunteerServlet1</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet volunteerServlet1 at " + request.getContextPath() + "</h1>");
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
             HttpSession session = request.getSession();
        int volunteerID = (Integer) session.getAttribute("volunteer");
        String eventID = request.getParameter("eventID");
        String taskID = request.getParameter("taskID");
        int status = 0;

        Connection conn = null;
        PreparedStatement insertStmt = null;
        PreparedStatement updateStmt = null;

        try {
            // Database connection
            conn = dbconnection.getConnection();
             if (volunteerID == 0) {
                // Redirect to login page if not logged in
                response.sendRedirect("login.jsp?message=Please login to volunteer for this event.");
            } else {
            // Insert into eventsVolunteer table
            String sql = "INSERT INTO eventsVolunteer (eventID, volunteerID) VALUES (?, ?)";
            insertStmt = conn.prepareStatement(sql);
            insertStmt.setInt(1, Integer.parseInt(eventID));
            insertStmt.setInt(2, volunteerID);
            
            String sqlTask = "UPDATE task SET status = ?, volunteerID = ? WHERE taskID = ?";
            updateStmt = conn.prepareStatement(sqlTask);
            updateStmt.setInt(1, status);
            updateStmt.setInt(2, volunteerID);
            updateStmt.setInt(3, Integer.parseInt(taskID));
            
            int rowsInserted = insertStmt.executeUpdate();
            updateStmt.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect(request.getContextPath() + "/success.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/error.jsp");
            }
            }
        } catch (Exception e) {
            e.printStackTrace();
             response.sendRedirect(request.getContextPath() + "/error.jsp");
             return; // Stop further execution
        } finally {
            try { if (insertStmt != null) insertStmt.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (updateStmt != null) updateStmt.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
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
