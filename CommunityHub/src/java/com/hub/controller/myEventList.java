/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.cm.model.address;
import com.cm.model.events;
import com.cm.model.eventsVolunteer;
import com.cm.model.task;
import java.text.SimpleDateFormat;

/**
 *
 * @author Rina
 */
public class myEventList extends HttpServlet {

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
            out.println("<title>Servlet myEventList</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet myEventList at " + request.getContextPath() + "</h1>");
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
                int volunteerId = Integer.parseInt(request.getSession().getAttribute("volunteer").toString());
//        if (volunteerId == 0) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp");
//            return;
//        }
                int pageSize = 5; // Number of events per page
                int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                int totalRecords = 0;
                int totalPages = 0;
                List<events> eventList = new ArrayList<>();
                List<eventsVolunteer> eventsVolList = new ArrayList<>();
                List<address> addressList = new ArrayList<>();
                List<task> taskList = new ArrayList<>();

                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    conn = dbconnection.getConnection(); // Get DB connection

                    // Count total records
                    String countQuery = "SELECT COUNT(*) AS total FROM events e " +
                                        "INNER JOIN eventsVolunteer ev ON e.eventID = ev.eventID " +
                                        "WHERE ev.volunteerID = ?";
                    stmt = conn.prepareStatement(countQuery);
                    stmt.setInt(1, volunteerId);
                    rs = stmt.executeQuery();
                    if (rs.next()) {
                        totalRecords = rs.getInt("total");
                        totalPages = (int) Math.ceil(totalRecords / (double) pageSize);
                    }
                    rs.close();
                    stmt.close();

                     // Fetch paginated data
                    String sql ="SELECT * FROM events e " +
                                "INNER JOIN address a ON e.addressID = a.addressID " +
                                "INNER JOIN eventsVolunteer ev ON e.eventID = ev.eventID " +
                                "INNER JOIN task t ON ev.volunteerID = t.volunteerID AND e.eventID = t.eventID " +
                                "WHERE ev.volunteerID = ? "+
                                "LIMIT ? OFFSET ?";

                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, volunteerId);
                    stmt.setInt(2, pageSize);
                    stmt.setInt(3, (currentPage - 1) * pageSize);
                    rs = stmt.executeQuery();
                   while (rs.next()) {
                    address address = new address(
                            rs.getInt("addressID"),
                            rs.getString("country"),
                            rs.getInt("postalCode"),
                            rs.getString("street"),
                            rs.getString("city"),
                            rs.getString("state")
                    );

                    addressList.add(address);

                    eventsVolunteer eventsv = new eventsVolunteer(
                            rs.getInt("eventsVolunteerID"), 
                            rs.getInt("eventID"), 
                            rs.getInt("volunteerID")
                    );
                    
                    eventsVolList.add(eventsv);
                    
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
                    eventList.add(event);
                    
                     task tasks = new task(
                             rs.getInt("taskID"),
                             rs.getString("t.description"),
                             rs.getInt("t.volunteerID")
                     ); 
                     taskList.add(tasks);
                }

                request.setAttribute("events", eventList);
                request.setAttribute("address", addressList);
                request.setAttribute("tasks", taskList);
                request.setAttribute("eventsV", eventsVolList);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", currentPage);
                
                request.getRequestDispatcher("/volunteer/myEventList.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
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
