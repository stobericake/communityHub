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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author anaqi
 */
public class listHistoryEventMgmt extends HttpServlet {

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
            out.println("<title>Servlet listHistoryEventMgmt</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet listHistoryEventMgmt at " + request.getContextPath() + "</h1>");
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
        List<events> eventList = new ArrayList<>();
        List<address> addressList = new ArrayList<>();
        HttpSession session = request.getSession();
        String beneficiaryID = session.getAttribute("beneficiary").toString();

        if (beneficiaryID == null) {
            request.setAttribute("error", "Beneficiary not found in session.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        } else {
        }
        ResultSet rs;
        PreparedStatement stmt;

        try (Connection conn = dbconnection.getConnection()) {

            String sortBy = request.getParameter("sortBy") != null ? request.getParameter("sortBy") : "eventID";
            String monthFilter = request.getParameter("month");
            String yearFilter = request.getParameter("year"); // New year filter

            // Base SQL for counting total events
            StringBuilder countSql = new StringBuilder(
                    "SELECT COUNT(*) as total FROM events WHERE status = 2 AND (date > CURDATE() OR (date = CURDATE() AND time > CURTIME()))"
            );

            // Add month filter if selected
            if (monthFilter != null && !monthFilter.isEmpty()) {
                countSql.append(" AND MONTH(date) = ?");
            }

            // Add year filter if selected
            if (yearFilter != null && !yearFilter.isEmpty()) {
                countSql.append(" AND YEAR(date) = ?");
            }

            stmt = conn.prepareStatement(countSql.toString());
            int paramIndex = 1;

            if (monthFilter != null && !monthFilter.isEmpty()) {
                stmt.setInt(paramIndex++, Integer.parseInt(monthFilter));
            }
            if (yearFilter != null && !yearFilter.isEmpty()) {
                stmt.setInt(paramIndex++, Integer.parseInt(yearFilter));
            }

            rs = stmt.executeQuery();
            rs.next();
            int totalEvents = rs.getInt("total");

            int eventsPerPage = 6;
            int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int offset = (currentPage - 1) * eventsPerPage;
            int totalPages = (int) Math.ceil((double) totalEvents / eventsPerPage);

            // Base SQL for fetching events
            StringBuilder sql = new StringBuilder(
                    "SELECT e.*, a.* FROM events e "
                    + "JOIN address a ON e.addressID = a.addressID "
                    + "WHERE e.status = 2 AND e.beneficiaryID = ? AND "
                    + " (e.date < CURDATE() OR (e.date = CURDATE() AND e.time < CURTIME()))"
            );

            // Add month filter if selected
            if (monthFilter != null && !monthFilter.isEmpty()) {
                sql.append(" AND MONTH(e.date) = ?");
            }

            // Add year filter if selected
            if (yearFilter != null && !yearFilter.isEmpty()) {
                sql.append(" AND YEAR(e.date) = ?");
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
            paramIndex = 1;
            stmt.setInt(paramIndex++, Integer.parseInt(beneficiaryID));

            if (monthFilter != null && !monthFilter.isEmpty()) {
                stmt.setInt(paramIndex++, Integer.parseInt(monthFilter));
            }
            if (yearFilter != null && !yearFilter.isEmpty()) {
                stmt.setInt(paramIndex++, Integer.parseInt(yearFilter));
            }
            stmt.setInt(paramIndex++, eventsPerPage);
            stmt.setInt(paramIndex, offset);

            rs = stmt.executeQuery();

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

                address addr = new address(
                        rs.getInt("addressID"),
                        rs.getString("country"),
                        rs.getInt("postalCode"),
                        rs.getString("street"),
                        rs.getString("city"),
                        rs.getString("state")
                );

                eventList.add(event);
                addressList.add(addr);
            }

            int pageSize = 6;  // Limit of data per page
            int page = 1; // Default to first page
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }

            // Calculate start index for slicing
            int startIndex = (page - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, eventList.size());

            // Slice the eventList and addressList based on the current page
            List<events> paginatedEventList = eventList.subList(startIndex, endIndex);
            List<address> paginatedAddressList = addressList.subList(startIndex, endIndex);

            // Get the total number of events for pagination controls
            totalEvents = eventList.size();
            totalPages = (int) Math.ceil((double) totalEvents / pageSize);

            request.setAttribute("event", paginatedEventList);
            request.setAttribute("address", paginatedAddressList);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("monthFilter", monthFilter);
            request.setAttribute("yearFilter", yearFilter);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);// Pass year filter to JSP

            request.getRequestDispatcher("beneficiary/eventHistory.jsp").forward(request, response);

        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(listEventMgmt.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "An error occurred while fetching event data.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
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
