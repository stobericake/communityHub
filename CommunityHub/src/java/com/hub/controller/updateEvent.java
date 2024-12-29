package com.hub.controller;

import com.cm.model.address;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.cm.model.events;
import java.io.InputStream;
import java.sql.Blob;
import javax.servlet.http.Part;

public class updateEvent extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String editEventId = request.getParameter("editEventId");
        String eventdeleteId = request.getParameter("eventDeleteId");
 
        if (editEventId != null && !editEventId.isEmpty()) {
        int eventId = Integer.parseInt(editEventId);
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

    try {
        conn = dbconnection.getConnection();
        String sql = "SELECT e.eventID, e.name, e.date, e.time, e.duration, e.image, e.donationLimit, a.city, a.state, a.country, a.street, a.postalCode, e.description, e.volunteerNeeded "
                   + ", e.status, a.addressID FROM events e JOIN address a ON e.addressID = a.addressID WHERE e.eventID = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, eventId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            // Create an events object using the data from the ResultSet
                int eventID = rs.getInt("eventID");
                String name = rs.getString("name");
                Date date = rs.getDate("date");
                Time time = rs.getTime("time");
                Time duration = rs.getTime("duration");
                String description = rs.getString("description");
                int volunteersNeeded = rs.getInt("volunteerNeeded");
                String status = rs.getString("status");
                Blob image = rs.getBlob("image");
                double donationLimit = rs.getDouble("donationLimit");
                int addressID = rs.getInt("addressID");
                String country = rs.getString("country");
                int postalCode = rs.getInt("postalCode");
                String street= rs.getString("street");
                String city = rs.getString("city");
                String state = rs.getString("state");
            
                int temp = eventId;

            events event = new events(eventID, name, date, time, duration, description, volunteersNeeded, status, image, donationLimit, addressID);

              
            address address = new address(addressID, country, postalCode, street, city, state);
            
            // Now you can pass this event object to the request
            request.setAttribute("event", event);  // Pass the entire event object
            request.setAttribute("address", address);
            request.setAttribute("id", temp);

            // Forward the request to the JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("beneficiary/editEvent.jsp");
            dispatcher.forward(request, response);
            }
        } catch (SQLException e) {
            getServletContext().log("Database error while fetching event", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving event data. Please try again later.");
            return;
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(updateEvent.class.getName()).log(Level.SEVERE, "Database driver not found", ex);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database driver error. Please contact support.");
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { getServletContext().log("Error closing result set", e); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { getServletContext().log("Error closing statement", e); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { getServletContext().log("Error closing connection", e); }
        }
    }

        else if (eventdeleteId != null) {
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                conn = dbconnection.getConnection(); // Get DB connection
                
                // SQL query to delete the event from the database
                String deleteSQL = "DELETE FROM events WHERE eventID = ?";
                stmt = conn.prepareStatement(deleteSQL);
                stmt.setInt(1, Integer.parseInt(eventdeleteId));

                int rowsDeleted = stmt.executeUpdate();
                
                if (rowsDeleted > 0) {
                    // Redirect back to the event list or show a success message
                    response.sendRedirect("eventmanagement.jsp"); // You may need to adjust the redirect
                } else {
                    // Handle the case where the event ID was not found
                    request.setAttribute("error", "Event not found.");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                // Handle errors (e.g., database issues)
                request.setAttribute("error", "Database error occurred.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(updateEvent.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        } else {
            // Event ID was not provided, handle the error
            request.setAttribute("error", "Event ID is missing.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

 
  
    
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    // Parse parameters
    String eventId = request.getParameter("eventID");
    if (eventId == null ) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid eventID format.");
        return;
    }
    
    int eventIdInt = Integer.parseInt(eventId);  // Convert to integer after validation

    String eventName = request.getParameter("eventName");
    String eventDate = request.getParameter("eventDate"); // yyyy-MM-dd format
    String eventTime = request.getParameter("eventTime"); // HH:mm format
    String city = request.getParameter("city");
    String country = request.getParameter("country");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String desc = request.getParameter("eventDescription");
    String street = request.getParameter("street");
    String hoursStr = request.getParameter("durationHours"); // "3"
    String minutesStr = request.getParameter("durationMinutes"); // "0"
    Double donationLimit = Double.parseDouble(request.getParameter("donationLimit"));   

    Part filePart = request.getPart("eventImage"); // Get the image file from the form
    InputStream imageInputStream = filePart.getInputStream();
    
    PreparedStatement psTask = null;

    // Parse the hours and minutes
    int hours = (hoursStr != null && !hoursStr.isEmpty()) ? Integer.parseInt(hoursStr) : 0;
    int minutes = (minutesStr != null && !minutesStr.isEmpty()) ? Integer.parseInt(minutesStr) : 0;

    // Validate minutes
    if (minutes < 0 || minutes >= 60) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid duration. Minutes must be between 0 and 59.");
        return;
    }

    // Create a Time object for the duration
    String timeString = String.format("%02d:%02d:%02d", hours, minutes, 00); // Format without seconds
    Time duration = Time.valueOf(timeString); // Append ":00" for seconds as zero

    // Establish database connection and execute update query
    try (Connection conn = dbconnection.getConnection()) {
        String sql = "UPDATE events e "
                   + "JOIN address a ON e.addressID = a.addressID "
                   + "SET e.name = ?, e.date = ?, e.time = ?, e.duration = ?, e.description = ?, "
                   + "e.image = ?, e.donationLimit = ?, a.city = ?, a.country = ?, a.state = ?, a.postalCode = ?, a.street = ? "
                   + "WHERE e.eventID = ?";

        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, eventName);
        stmt.setDate(2, Date.valueOf(eventDate)); // Convert to SQL Date
        stmt.setTime(3, Time.valueOf(eventTime)); // Event time (HH:mm:ss)
        stmt.setTime(4, duration); 
        stmt.setString(5, desc); 
        stmt.setBlob(6, imageInputStream);
        stmt.setDouble(7, donationLimit);
        stmt.setString(8, city);
        stmt.setString(9, country);
        stmt.setString(10, state);
        stmt.setInt(11, Integer.parseInt(postalCode));
        stmt.setString(12, street);
        stmt.setInt(13, eventIdInt); // Use validated eventID

        stmt.executeUpdate();
        
        /*
        String sqlTask = "INSERT INTO task (status, description, eventID, volunteerID) VALUES (?, ?, ?, ?)";
        psTask = conn.prepareStatement(sqlTask);

        // Retrieve tasks dynamically
        for (int i = 0; ; i++) {
            String taskName = request.getParameter("task[" + i + "].name");
            if (taskName == null || taskName.trim().isEmpty()) { 
                break;  // No more tasks or invalid task name
            }

            psTask.setInt(1, 1);
            psTask.setString(2, taskName);
            psTask.setInt(3, eventIdInt);
            psTask.setNull(4, java.sql.Types.NULL);
            psTask.addBatch();
        }

        // Execute batch task insertions
        if (psTask != null) {
            psTask.executeBatch();
        } */

        String message = "The Event Name: " + eventName + " Successfully Updated";
        String encodedMessage = URLEncoder.encode(message, "UTF-8");

        response.sendRedirect("success.jsp?msg=" + encodedMessage);

    } catch (NumberFormatException e) {
        getServletContext().log("Invalid input format for numeric fields", e);
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input format for numeric fields, please check your input.");
    } catch (SQLException e) {
        getServletContext().log("Error updating event", e);
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error while updating event. Please try again later.");
    } catch (ClassNotFoundException ex) {
        getServletContext().log("Database driver not found", ex);
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database connection error. Please contact support.");
    }
}


    @Override
    public String getServletInfo() {
        return "Handles event updates and repopulates the form.";
    }
}
