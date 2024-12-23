/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

//import com.hub.model.ServiceReport;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

/**
 *
 * @author HAZIQ
 */
public class addServiceReport extends HttpServlet {

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
            out.println("<title>Servlet addServiceReport</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet addServiceReport at " + request.getContextPath() + "</h1>");
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

        PrintWriter out = response.getWriter();

        // Read form data
        String eventId = request.getParameter("eventMenu");
        String volunteerId = request.getParameter("volunteer");
        String challenge = request.getParameter("challenge");
        String solution = request.getParameter("solution");
        String feedback = request.getParameter("feedback");
        String recommend = request.getParameter("recommend");
        java.sql.Date dateSubmitted = new java.sql.Date(System.currentTimeMillis());

        
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Get database connection
            conn = dbconnection.getConnection();

            String sql = "INSERT INTO servicereport (eventID, volunteerID, problem, solution, feedback, recommendations, dateSubmitted) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(eventId));
            stmt.setInt(2, Integer.parseInt(volunteerId));
            stmt.setString(3, challenge);
            stmt.setString(4, solution);
            stmt.setString(5, feedback);
            stmt.setString(6, recommend);
            stmt.setDate(7, dateSubmitted);

            // Execute update
            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
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
