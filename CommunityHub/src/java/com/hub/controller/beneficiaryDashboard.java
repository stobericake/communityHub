package com.hub.controller;

import com.cm.model.events;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author anaqi
 */
public class beneficiaryDashboard extends HttpServlet {

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
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet beneficiaryDashboard</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet beneficiaryDashboard at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String beneficiaryID = session.getAttribute("beneficiary").toString();

        if (beneficiaryID == null) {
            request.setAttribute("error", "Beneficiary not found in session.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        try (Connection conn = dbconnection.getConnection()) {
            // Fetch counts for the logged-in beneficiary
            int totalVolunteers = getCount(conn,
                    "SELECT COUNT(DISTINCT v.volunteerID) "
                    + "FROM eventsvolunteer v "
                    + "JOIN events e ON v.eventID = e.eventID "
                    + "WHERE e.beneficiaryID = ?",
                    beneficiaryID);
            int totalEvents = getCount(conn, "SELECT COUNT(*) FROM events WHERE beneficiaryID = ?", beneficiaryID);
            int completedEvents = getCount(conn,
                    "SELECT COUNT(*) FROM events "
                    + "WHERE beneficiaryID = ? "
                    + "AND status = 2 "
                    + "AND MONTH(date) = MONTH(CURDATE()) "
                    + "AND YEAR(date) = YEAR(CURDATE())",
                    beneficiaryID);
            
            double totalDonations = getTotalDonations(conn, beneficiaryID);

            // Fetch recent events for the logged-in beneficiary
            ArrayList<events> recentEvents = getRecentEvents(conn, beneficiaryID);

            // Set attributes for the JSP page
            request.setAttribute("totalVolunteers", totalVolunteers);
            request.setAttribute("totalEvents", totalEvents);
            request.setAttribute("completedEvents", completedEvents);
            request.setAttribute("totalDonations", totalDonations);
            request.setAttribute("recentEvents", recentEvents);

            // Forward to the beneficiary dashboard JSP
            request.getRequestDispatcher("beneficiary/beneficiaryDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while fetching dashboard data.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private double getTotalDonations(Connection conn, String beneficiaryID) throws Exception {
    String query = "SELECT SUM(d.amount) AS total_donations "
                 + "FROM donation d "
                 + "JOIN events e ON d.eventID = e.eventID "
                 + "WHERE e.beneficiaryID = ?";
    try (PreparedStatement stmt = conn.prepareStatement(query)) {
        stmt.setInt(1, Integer.parseInt(beneficiaryID));
        try (ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getDouble("total_donations") : 0.0;
        }
    }
}

    private int getCount(Connection conn, String query, String beneficiaryID) throws Exception {
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, Integer.parseInt(beneficiaryID));
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

  private ArrayList<events> getRecentEvents(Connection conn, String beneficiaryID) throws Exception {
    ArrayList<events> eventsList = new ArrayList<>();
    String query = "SELECT * FROM events WHERE beneficiaryID = ? ORDER BY date DESC LIMIT 3";
    try (PreparedStatement stmt = conn.prepareStatement(query)) {
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
                        rs.getBlob("image"), // Handle null in the events class
                        rs.getDouble("donationLimit"),
                        rs.getInt("addressID")
                );
                eventsList.add(event);
            }
        }
    }
    return eventsList;
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Beneficiary Dashboard Servlet";
    }
}
