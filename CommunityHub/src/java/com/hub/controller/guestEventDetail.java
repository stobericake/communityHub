package com.hub.controller;

import com.cm.model.address;
import com.cm.model.beneficiary;
import com.cm.model.events;
import com.cm.model.task;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author HAZIQ
 */
public class guestEventDetail extends HttpServlet {

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
            out.println("<title>Servlet AdminEventDetails</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminEventDetails at " + request.getContextPath() + "</h1>");
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
   

        int eventID = Integer.parseInt(request.getParameter("eventID"));
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        events event = null;
        address address = null;
        beneficiary beneficiary = null;
        List<task> taskList = new ArrayList<>();

        try {
            conn = dbconnection.getConnection();
            String sql = "SELECT * FROM events e "
                    + "INNER JOIN address a ON e.addressID = a.addressID "
                    + "INNER JOIN beneficiary b ON e.beneficiaryID = b.beneficiaryID "
                    + "WHERE e.eventID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, eventID);
            rs = stmt.executeQuery();

            if (rs.next()) {
                event = new events(
                        rs.getInt("e.eventID"),
                        rs.getString("e.name"),
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
                address = new address(
                        rs.getInt("addressID"),
                        rs.getString("country"),
                        rs.getInt("postalCode"),
                        rs.getString("street"),
                        rs.getString("city"),
                        rs.getString("state")
                );
                beneficiary = new beneficiary(
                        rs.getInt("beneficiaryID"),
                        rs.getString("b.name")
                );

                // Get tasks
                String taskSql = "SELECT * FROM task WHERE eventID = ?";
                PreparedStatement taskStmt = conn.prepareStatement(taskSql);
                taskStmt.setInt(1, eventID);
                ResultSet taskRs = taskStmt.executeQuery();
                while (taskRs.next()) {
                    taskList.add(new task(
                            taskRs.getInt("taskID"),
                            taskRs.getString("description")
                    ));
                }

                // Format date and time
                SimpleDateFormat outputFormat = new SimpleDateFormat("hh:mma");
                SimpleDateFormat inputDateFormat = new SimpleDateFormat("MM/dd/yyyy - ");

                LocalDate eventLocalDate = new java.util.Date(rs.getDate("date").getTime())
                        .toInstant()
                        .atZone(ZoneId.systemDefault())
                        .toLocalDate();

                LocalTime startTime = rs.getTime("time").toLocalTime();
                LocalTime duration = rs.getTime("duration").toLocalTime();
                LocalTime endTime = startTime.plusHours(duration.getHour()).plusMinutes(duration.getMinute());

                String formattedDate = inputDateFormat.format(rs.getDate("date"));
                String formattedStartTime = outputFormat.format(rs.getTime("time"));
                String formattedEndTime = outputFormat.format(Time.valueOf(endTime));

                // Calculate days remaining
                LocalDate currentDate = LocalDate.now();
                long daysLeft = ChronoUnit.DAYS.between(currentDate, eventLocalDate);

                // Get donation information
                String donationSql = "SELECT SUM(amount) AS totalDonation, COUNT(DISTINCT donorID) as totalContributors FROM donation WHERE eventID = ?";
                PreparedStatement donationStmt = conn.prepareStatement(donationSql);
                donationStmt.setInt(1, eventID);
                ResultSet donationRs = donationStmt.executeQuery();

                double totalDonation = 0;
                int totalContributors = 0;
                if (donationRs.next()) {
                    totalDonation = donationRs.getDouble("totalDonation");
                    totalContributors = donationRs.getInt("totalContributors");
                }

                double donationLimit = event.getDonationLimit();
                double remainingAmount = donationLimit - totalDonation;
                double progress = (totalDonation / donationLimit) * 100;

                // Set attributes
                request.setAttribute("event", event);
                request.setAttribute("address", address);
                request.setAttribute("beneficiary", beneficiary);
                request.setAttribute("tasks", taskList);
                request.setAttribute("formattedDate", formattedDate);
                request.setAttribute("formattedStartTime", formattedStartTime);
                request.setAttribute("formattedEndTime", formattedEndTime);
                request.setAttribute("daysLeft", daysLeft);
                request.setAttribute("totalDonation", totalDonation);
                request.setAttribute("totalContributors", totalContributors);
                request.setAttribute("remainingAmount", remainingAmount);
                request.setAttribute("progress", progress);
            }

            request.getRequestDispatcher("/guest/guestEventDetail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Error fetching event details.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
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
