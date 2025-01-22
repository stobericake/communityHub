/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.cm.model.address;
import com.cm.model.events;
import javax.servlet.RequestDispatcher;
/**
 *
 * @author Rina
 */
public class vEventList extends HttpServlet {

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
            out.println("<title>Servlet volunteerEventListing</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet volunteerEventListing at " + request.getContextPath() + "</h1>");
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int volunteerId = Integer.parseInt(request.getSession().getAttribute("volunteer").toString());
        if (volunteerId == 0) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<events> eventList = new ArrayList<>();
        List<address> addressList = new ArrayList<>();

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbconnection.getConnection();
                if (conn == null) {
                    System.out.println("DB Connection: " + (conn != null));
                    return;
                }

            // Fetch postal code for volunteer
            String postalCodeQuery = "SELECT a.postalCode FROM volunteer v JOIN address a ON v.addressID = a.addressID WHERE v.volunteerID = ?";
            stmt = conn.prepareStatement(postalCodeQuery);
            stmt.setInt(1, volunteerId);
            rs = stmt.executeQuery();

            int postalCode = 0;

            if(rs.next()){
            postalCode = rs.getInt("postalCode");
            System.out.println(postalCode);
            }
            rs.close();
            stmt.close();

            if (postalCode != 0) {
                // Count total events for pagination
                String countSql =  "SELECT COUNT(*) as total FROM events e JOIN address a ON e.addressID = a.addressID WHERE a.postalCode = ? "
                    + "AND status = 2 AND e.eventID NOT IN "
                    + "(SELECT eventID FROM eventsVolunteer "
                    + "WHERE volunteerID = ?) "
                    + "AND e.date >= CURDATE()";  // Add this condition to filter out past events
                PreparedStatement countStmt = conn.prepareStatement(countSql);
                countStmt.setInt(1, postalCode);
                countStmt.setInt(2, volunteerId);
                ResultSet countRs = countStmt.executeQuery();
                countRs.next();
                int totalEvents = countRs.getInt("total");
                countRs.close();
                countStmt.close();

                int eventsPerPage = 3;
                int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                int offset = (currentPage - 1) * eventsPerPage;
                int totalPages = (int) Math.ceil((double) totalEvents / eventsPerPage);

                String sql = "SELECT * FROM events e "
                    + "JOIN address a ON e.addressID = a.addressID WHERE a.postalCode = ? "
                    + "AND status = 2 AND e.eventID NOT IN "
                    + "(SELECT eventID FROM eventsVolunteer "
                    + "WHERE volunteerID = ?) "
                    + "AND e.date >= CURDATE() "  // Add this condition to filter out past events
                    + "LIMIT ? OFFSET ?";
                
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, postalCode);
                stmt.setInt(2, volunteerId);
                stmt.setInt(3, eventsPerPage);  // Limit to 3 events per page
                stmt.setInt(4, offset);         // Skip previous pages' events

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
                }

                request.setAttribute("events", eventList);
                request.setAttribute("address", addressList);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", currentPage);

                request.getRequestDispatcher("/volunteer/newListingEvent.jsp").forward(request, response);
            } else {
                request.setAttribute("msg", "No postal code found for the volunteer.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "An error occurred while fetching events.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
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
