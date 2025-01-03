package com.hub.controller;

import com.cm.model.address;
import com.cm.model.events;
import java.io.IOException;
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

public class listGuestEvent extends HttpServlet {

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
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        List<events> eventList = new ArrayList<>();
        List<address> addressList = new ArrayList<>();
        
        try {
            conn = dbconnection.getConnection();

            // Get the total number of events for pagination
            String countSql = "SELECT COUNT(*) as total FROM Events e JOIN Address a ON e.addressID = a.addressID";
            PreparedStatement countStmt = conn.prepareStatement(countSql);
            ResultSet countRs = countStmt.executeQuery();
            countRs.next();
            int totalEvents = countRs.getInt("total");
            countRs.close();
            countStmt.close();

            // Pagination parameters
            int eventsPerPage = 4;
            int currentPage = request.getParameter("page") != null
                    ? Integer.parseInt(request.getParameter("page")) : 1;
            int offset = (currentPage - 1) * eventsPerPage;
            int totalPages = (int) Math.ceil((double) totalEvents / eventsPerPage);

            // Query to fetch events with pagination
            String sql = "SELECT e.eventID, e.name, e.date, e.time, e.duration, e.image, e.donationLimit, "
                    + "e.description, e.volunteerNeeded, e.status, e.addressID, "
                    + "a.city, a.state, a.country, a.street, a.postalCode "
                    + "FROM events e JOIN address a ON e.addressID = a.addressID "
                    + "LIMIT ? OFFSET ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, eventsPerPage);
            stmt.setInt(2, offset);

            rs = stmt.executeQuery();

            // Process the result set and populate the eventList
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

                // Add the event to the list (address is not necessary in the JSP)
                eventList.add(event);
                addressList.add(addr);
            }

            // Set attributes for the JSP page
            request.setAttribute("events", eventList);
            request.setAttribute("address", addressList);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);

            // Forward to the JSP page to display the events
            request.getRequestDispatcher("/guest/eventListingGuest.jsp").forward(request, response);

        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(listGuestEvent.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Error fetching events from the database.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            // Close resources to prevent memory leaks
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(listGuestEvent.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to list events for guests with pagination.";
    }
}
