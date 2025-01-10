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
import javax.servlet.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author HAZIQ
 */
public class UpdateEventStatus extends HttpServlet {

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
            out.println("<title>Servlet UpdateEventStatus</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateEventStatus at " + request.getContextPath() + "</h1>");
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

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Check if eventId and status are provided
            String eventIdParam = request.getParameter("eventId");
            String statusParam = request.getParameter("status");

            if (eventIdParam == null || statusParam == null) {
                response.sendRedirect("index.jsp?msg=missing_params");
                return;
            }

            // Parse eventId and status, handling invalid input
            int eventId = 0;
            int status = 0;

            try {
                eventId = Integer.parseInt(eventIdParam);
                status = Integer.parseInt(statusParam);
            } catch (NumberFormatException e) {
                response.sendRedirect("index.jsp?msg=invalid_input");
                return;
            }

            // Validate status value (1, 2, or 3 for Pending, Approved, Rejected)
            if (status != 1 && status != 2 && status != 3) {
                response.sendRedirect("index.jsp?msg=invalid_status");
                return;
            }

//             Retrieve the current adminID from the session
            Integer adminID = (Integer) request.getSession().getAttribute("admin");
            if (adminID == null) {
                response.sendRedirect("index.jsp?msg=not_logged_in");
                return;
            }
            
            // Database connection
            conn = dbconnection.getConnection();
            String sql = "UPDATE events SET status = ?, adminID = ? WHERE eventID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, status);
            stmt.setInt(2, adminID);
            stmt.setInt(3, eventId);

            // Execute the update
            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("success.jsp?msg=Status Updated");
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
