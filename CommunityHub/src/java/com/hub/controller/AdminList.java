/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import com.cm.model.address;
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
public class AdminList extends HttpServlet {

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
            out.println("<title>Servlet adminList2</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet adminList2 at " + request.getContextPath() + "</h1>");
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
            String sortBy = request.getParameter("sortBy") != null ? request.getParameter("sortBy") : "eventID";
            String monthFilter = request.getParameter("month");

            // Base SQL for counting total events
            StringBuilder countSql = new StringBuilder(
                    "SELECT COUNT(*) as total FROM events WHERE status = 1 AND (date > CURDATE() OR (date = CURDATE() AND time > CURTIME()))"
            );

            // Add month filter if selected
            if (monthFilter != null && !monthFilter.isEmpty()) {
                countSql.append(" AND MONTH(date) = ?");
            }

            stmt = conn.prepareStatement(countSql.toString());
            if (monthFilter != null && !monthFilter.isEmpty()) {
                stmt.setInt(1, Integer.parseInt(monthFilter));
            }

            rs = stmt.executeQuery();
            rs.next();
            int totalEvents = rs.getInt("total");

            int eventsPerPage = 3;
            int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int offset = (currentPage - 1) * eventsPerPage;
            int totalPages = (int) Math.ceil((double) totalEvents / eventsPerPage);

            // Base SQL for fetching events
            StringBuilder sql = new StringBuilder(
                    "SELECT e.*, a.* FROM events e "
                    + "JOIN address a ON e.addressID = a.addressID "
                    + "WHERE e.status = 1 AND (e.date > CURDATE() OR (e.date = CURDATE() AND e.time > CURTIME()))"
            );

            // Add month filter if selected
            if (monthFilter != null && !monthFilter.isEmpty()) {
                sql.append(" AND MONTH(e.date) = ?");
            }

            // Add sorting
            sql.append(" ORDER BY ");
            switch (sortBy) {
                case "eventID":
                    sql.append("e.eventID ASC"); // Earlier created events first
                    break;
                case "date":
                    sql.append("e.date ASC, e.time ASC");
                    break;
                case "donationLimit":
                    sql.append("e.donationLimit DESC");
                    break;
                case "volunteerNeeded":
                    sql.append("e.volunteerNeeded DESC");
                    break;
                default:
                    sql.append("e.eventID ASC");
            }

            sql.append(" LIMIT ? OFFSET ?");

            stmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (monthFilter != null && !monthFilter.isEmpty()) {
                stmt.setInt(paramIndex++, Integer.parseInt(monthFilter));
            }
            stmt.setInt(paramIndex++, eventsPerPage);
            stmt.setInt(paramIndex, offset);

            rs = stmt.executeQuery();

            ArrayList<events> events = new ArrayList<>();
            ArrayList<address> addresses = new ArrayList<>();

            while (rs.next()) {
                address address = new address(
                        rs.getInt("addressID"),
                        rs.getString("country"),
                        rs.getInt("postalCode"),
                        rs.getString("street"),
                        rs.getString("city"),
                        rs.getString("state")
                );
                addresses.add(address);

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
                events.add(event);
            }

            request.setAttribute("events", events);
            request.setAttribute("addresses", addresses);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("monthFilter", monthFilter);

            request.getRequestDispatcher("admin/adminListing.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AdminList.class.getName()).log(Level.SEVERE, null, ex);
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
