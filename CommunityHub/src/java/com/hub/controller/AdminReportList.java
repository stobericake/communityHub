/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import com.cm.model.events;
import com.cm.model.volunteer;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AdminReportList extends HttpServlet {

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
            out.println("<title>Servlet AdminReportList</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminReportList at " + request.getContextPath() + "</h1>");
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

        try {
            conn = dbconnection.getConnection();

            // Get parameters
            String status = request.getParameter("status") != null ? request.getParameter("status") : "all";
            int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int currentPage1 = request.getParameter("page2") != null ? Integer.parseInt(request.getParameter("page2")) : 1;
            String activeTab = request.getParameter("activeTab") != null ? request.getParameter("activeTab") : "events";

            // Events pagination
            String countSql = "SELECT COUNT(*) as total FROM events";
            stmt = conn.prepareStatement(countSql);
            rs = stmt.executeQuery();
            rs.next();
            int totalEvents = rs.getInt("total");

            int eventsPerPage = 5;
            int totalPages = (int) Math.ceil((double) totalEvents / eventsPerPage);
            int offset = (currentPage - 1) * eventsPerPage;

            // Events retrieval
            ArrayList<events> eventsList = new ArrayList<>();
            int idstat = 0;
            String sql = "SELECT * FROM events";

            if (status != null && !"All".equalsIgnoreCase(status)) {
                if (status.equalsIgnoreCase("Pending")) {
                    idstat = 1;
                } else if (status.equalsIgnoreCase("Approved")) {
                    idstat = 2;
                } else {
                    idstat = 3;
                }

                sql += " WHERE status = ? LIMIT ? OFFSET ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, idstat);
                stmt.setInt(2, eventsPerPage);
                stmt.setInt(3, offset);
            } else {
                sql += " LIMIT ? OFFSET ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, eventsPerPage);
                stmt.setInt(2, offset);
            }

            rs = stmt.executeQuery();
            while (rs.next()) {
                events event = new events(
                        rs.getInt("eventID"),
                        rs.getString("name"),
                        rs.getDate("date")
                );
                // Add event object to the events list
                eventsList.add(event);
            }

            // Volunteers pagination
            String countVol = "SELECT COUNT(*) as total FROM volunteer";
            stmt = conn.prepareStatement(countVol);
            rs = stmt.executeQuery();
            rs.next();
            int totalVolunteer = rs.getInt("total");

            int volunteerPerPage = 5;
            int totalPages1 = (int) Math.ceil((double) totalVolunteer / volunteerPerPage);
            int offset1 = (currentPage1 - 1) * volunteerPerPage;

            // Volunteers retrieval
            ArrayList<volunteer> volunteerList = new ArrayList<>();
            String sql1 = "SELECT * FROM volunteer LIMIT ? OFFSET ?";
            stmt = conn.prepareStatement(sql1);
            stmt.setInt(1, volunteerPerPage);
            stmt.setInt(2, offset1);

            rs = stmt.executeQuery();
            while (rs.next()) {
                volunteer vol = new volunteer(
                    rs.getInt("volunteerID"),
                    rs.getString("name"),
                    rs.getInt("contactInfo")
                );
                volunteerList.add(vol);
            }

            // Set attributes
            request.setAttribute("eventsList", eventsList);
            request.setAttribute("volunteerList", volunteerList);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalPages1", totalPages1);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("currentPage1", currentPage1);
            request.setAttribute("status", status);
            request.setAttribute("activeTab", activeTab);

            request.getRequestDispatcher("admin/adminReport.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
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
