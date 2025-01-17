/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import com.cm.model.address;
import com.cm.model.events;
import com.cm.model.task;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
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
public class listEventMgmt extends HttpServlet {

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
            out.println("<title>Servlet listEventMgmt</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet listEventMgmt at " + request.getContextPath() + "</h1>");
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

        try (Connection conn = dbconnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(
                        "SELECT e.eventID, e.name, e.date, e.time, e.duration, e.image, e.donationLimit, "
                        + "e.description, e.volunteerNeeded, e.status, e.addressID, "
                        + "a.city, a.state, a.country, a.street, a.postalCode, a.addressID "
                        + "FROM events e JOIN address a ON e.addressID = a.addressID "
                        + "WHERE e.beneficiaryID = ?  AND  CURDATE() < e.date")) {

            stmt.setInt(1, Integer.parseInt(beneficiaryID));
            try (ResultSet rs = stmt.executeQuery()) {
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
            }
        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(listEventMgmt.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "An error occurred while fetching event data.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        // Set the pagination parameters
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
        int totalEvents = eventList.size();
        int totalPages = (int) Math.ceil((double) totalEvents / pageSize);

        request.setAttribute("event", paginatedEventList);
        request.setAttribute("address", paginatedAddressList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("beneficiary/eventManagement.jsp").forward(request, response);
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
