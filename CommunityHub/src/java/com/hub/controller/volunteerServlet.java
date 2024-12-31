/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.*;
import javax.servlet.http.HttpSession;
/**
 *
 * @author Rina
 */
@WebServlet(name = "volunteerServlet", urlPatterns = {"/volunteer_servlet.do"})
public class volunteerServlet extends HttpServlet {

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
            out.println("<title>Servlet volunteerServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet volunteerServlet at " + request.getContextPath() + "</h1>");
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String volunteerID = (String) session.getAttribute("volunteer");
        String eventID = request.getParameter("eventID");
        String selectedTask = request.getParameter("task");

        if (volunteerID == null || eventID == null || selectedTask == null) {
            response.sendRedirect("../login.jsp?message=Please login and provide all necessary details.");
            return;
        }

        try (Connection conn = dbconnection.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            // Insert into eventsVolunteer table
            String sqlEventVolunteer = "INSERT INTO eventsVolunteer (eventID, volunteerID) VALUES (?, ?)";
            try (PreparedStatement stmtEventVolunteer = conn.prepareStatement(sqlEventVolunteer)) {
                stmtEventVolunteer.setInt(1, Integer.parseInt(eventID));
                stmtEventVolunteer.setInt(2, Integer.parseInt(volunteerID));
                stmtEventVolunteer.executeUpdate();
            }

            // Insert into task table
            String sqlTask = "INSERT INTO task (status, description, eventID, volunteerID) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmtTask = conn.prepareStatement(sqlTask)) {
                stmtTask.setInt(1, 1);
                stmtTask.setString(2, selectedTask);
                stmtTask.setInt(3, Integer.parseInt(eventID));
                stmtTask.setInt(4, Integer.parseInt(volunteerID));
                stmtTask.executeUpdate();
            }

            conn.commit(); // Commit transaction
            response.sendRedirect("success.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
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
