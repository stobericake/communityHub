package com.hub.controller;

import com.cm.model.address;
import com.cm.model.events;
import com.cm.model.task;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.util.List;

@MultipartConfig
public class updateEvent extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String editEventId = null;
        String eventdeleteId = null;

        editEventId = request.getParameter("editEventId");
        eventdeleteId = request.getParameter("eventDeleteId");

        if (editEventId != null && !editEventId.isEmpty()) {
            List<task> taskList = new ArrayList<>();

            int eventId = Integer.parseInt(editEventId);
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            PreparedStatement stmtTask = null;
            ResultSet rsTask = null;

            try {
                conn = dbconnection.getConnection();
                String sql = "SELECT e.eventID, e.name, e.date, e.time, e.duration, e.image, e.donationLimit, a.city, a.state, a.country, "
                        + "a.street, a.postalCode, e.description, e.volunteerNeeded, "
                        + "e.status, a.addressID FROM events e JOIN address a ON e.addressID = a.addressID "
                        + "WHERE e.eventID = ?";
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
                    String street = rs.getString("street");
                    String city = rs.getString("city");
                    String state = rs.getString("state");

                    String task = "SELECT * from task where eventID = ?";
                    stmtTask = conn.prepareStatement(task);
                    stmtTask.setInt(1, eventID);
                    rsTask = stmtTask.executeQuery();

                    while (rsTask.next()) {
                        int taskID = rsTask.getInt("taskID");
                        String desc = rsTask.getString("description");
                        int statusTask = rsTask.getInt("status");
                        int eventIDTask = rsTask.getInt("eventID");
                        int volunteerIDTask = rsTask.getInt("volunteerID");

                        task temp = new task(taskID, desc, statusTask, eventIDTask, volunteerIDTask, conn);
                        taskList.add(temp);
                    }

                    events event = new events(eventID, name, date, time, duration, description, volunteersNeeded, status, image, donationLimit, addressID);
                    address address = new address(addressID, country, postalCode, street, city, state);

                    // Set the pagination parameters
                    int pageSize = 3;  // Limit of data per page
                    int page = 1; // Default to first page
                    String pageParam = request.getParameter("page");
                    if (pageParam != null) {
                        page = Integer.parseInt(pageParam);
                    }

                    // Calculate start index for slicing
                    int startIndex = (page - 1) * pageSize;
                    int endIndex = Math.min(startIndex + pageSize, taskList.size());

                    // Slice the eventList and addressList based on the current page
                    List<task> paginatedTaskList = taskList.subList(startIndex, endIndex);

                    // Get the total number of events for pagination controls
                    int totalList = taskList.size();
                    int totalPages = (int) Math.ceil((double) totalList / pageSize);

                    request.setAttribute("event", event);
                    request.setAttribute("address", address);
                    request.setAttribute("task", paginatedTaskList);
                    request.setAttribute("totalPages", totalPages);
                    request.setAttribute("currentPage", page);

                    // Forward the request to the JSP
                    RequestDispatcher dispatcher = request.getRequestDispatcher("beneficiary/editEvent.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            } catch (SQLException e) {
                getServletContext().log("Database error while fetching event", e);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving event data. Please try again later.");
                return;
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(updateEvent.class.getName()).log(Level.SEVERE, "Database driver not found", ex);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database driver error. Please contact support.");
            }

        } else if (eventdeleteId != null && !eventdeleteId.isEmpty()) {
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                conn = dbconnection.getConnection(); // Get DB connection

                // Fetch the addressID for the event being deleted
                String fetchAddressSQL = "SELECT addressID FROM events WHERE eventID = ?";
                stmt = conn.prepareStatement(fetchAddressSQL);
                stmt.setInt(1, Integer.parseInt(eventdeleteId));

                ResultSet rs = stmt.executeQuery();
                int addressID = -1;
                if (rs.next()) {
                    addressID = rs.getInt("addressID");
                }
                rs.close();
                stmt.close();

                // Check if the addressID is shared with other events
                String checkSharedAddressSQL = "SELECT COUNT(*) FROM events WHERE addressID = ?";
                stmt = conn.prepareStatement(checkSharedAddressSQL);
                stmt.setInt(1, addressID);
                rs = stmt.executeQuery();

                boolean isAddressShared = false;
                if (rs.next()) {
                    int eventCount = rs.getInt(1);
                    if (eventCount > 1) {
                        isAddressShared = true; // Address is shared with other events
                    }
                }
                rs.close();
                stmt.close();

                // Delete tasks associated with the event
                String deleteSQL = "DELETE FROM task WHERE eventID = ?";
                stmt = conn.prepareStatement(deleteSQL);
                stmt.setInt(1, Integer.parseInt(eventdeleteId));
                stmt.executeUpdate();
                stmt.close();

                // Delete the event
                deleteSQL = "DELETE FROM donation WHERE eventID = ?";
                stmt = conn.prepareStatement(deleteSQL);
                stmt.setInt(1, Integer.parseInt(eventdeleteId));
                stmt.executeUpdate();
                stmt.close();

                deleteSQL = "DELETE FROM servicereport WHERE eventID = ?";
                stmt = conn.prepareStatement(deleteSQL);
                stmt.setInt(1, Integer.parseInt(eventdeleteId));
                stmt.executeUpdate();
                stmt.close();

                deleteSQL = "DELETE FROM eventsvolunteer WHERE eventID = ?";
                stmt = conn.prepareStatement(deleteSQL);
                stmt.setInt(1, Integer.parseInt(eventdeleteId));
                stmt.executeUpdate();
                stmt.close();

                deleteSQL = "DELETE FROM events WHERE eventID = ?";
                stmt = conn.prepareStatement(deleteSQL);
                stmt.setInt(1, Integer.parseInt(eventdeleteId));
                stmt.executeUpdate();
                stmt.close();

                // Delete the address only if it is not shared with other events
                if (!isAddressShared) {
                    String deleteAddressSQL = "DELETE FROM address WHERE addressID = ?";
                    stmt = conn.prepareStatement(deleteAddressSQL);
                    stmt.setInt(1, addressID);
                    stmt.executeUpdate();
                    stmt.close();
                }

                response.sendRedirect("listEventMgmt.do"); // Redirect after deletion

            } catch (SQLException e) {
                e.printStackTrace();
                // Handle errors (e.g., database issues)
                request.setAttribute("msg", "Database error occurred.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(updateEvent.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                try {
                    if (stmt != null) {
                        stmt.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                try {
                    if (conn != null) {
                        conn.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            // Event ID was not provided, handle the error
            request.setAttribute("msg", "Event ID is missing.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idValue = request.getParameter("id");
        String eventName = request.getParameter("eventName");
        String eventDate = request.getParameter("eventDate"); // yyyy-MM-dd format
        String eventTime = request.getParameter("eventTime"); // HH:mm format
        String city = request.getParameter("city");
        String country = request.getParameter("country");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
        String desc = request.getParameter("eventDescription");
        String street = request.getParameter("street");
        String hoursStr = request.getParameter("durationHours");
        String minutesStr = request.getParameter("durationMinutes");
        Double donationLimit = Double.parseDouble(request.getParameter("donationLimit"));

        String[] updatedTask = request.getParameterValues("updatedTask");
        String[] taskIDs = request.getParameterValues("taskID");

        String[] newTasks = request.getParameterValues("newTask");

        String deleteTasks = request.getParameter("deleteTasks");

        Part filePart = request.getPart("eventImage"); // Get the uploaded file
        InputStream imageInputStream = null;

        if (filePart != null && filePart.getSize() > 0) {
            imageInputStream = filePart.getInputStream();
        } else {
            // Fallback to existing image from the database
            try (Connection conn = dbconnection.getConnection();
                    PreparedStatement stmt = conn.prepareStatement("SELECT image FROM events WHERE eventID = ?")) {
                stmt.setInt(1, Integer.parseInt(idValue));
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        imageInputStream = rs.getBlob("image").getBinaryStream();
                    }
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching existing image.");
                return;
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(updateEvent.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        int hours = (hoursStr != null && !hoursStr.isEmpty()) ? Integer.parseInt(hoursStr) : 0;
        int minutes = (minutesStr != null && !minutesStr.isEmpty()) ? Integer.parseInt(minutesStr) : 0;

        if (minutes < 0 || minutes >= 60) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid duration. Minutes must be between 0 and 59.");
            return;
        }

        String timeString = String.format("%02d:%02d:%02d", hours, minutes, 0);
        Time duration = Time.valueOf(timeString);

        try (Connection conn = dbconnection.getConnection()) {

            String findAddressSQL = "SELECT addressID FROM address WHERE UPPER(street) = UPPER(?) AND UPPER(city) = UPPER(?) AND state = ? AND postalCode = ? AND country = ?";
            int addressID = -1;

            try (PreparedStatement findStmt = conn.prepareStatement(findAddressSQL)) {
                findStmt.setString(1, street);
                findStmt.setString(2, city);
                findStmt.setString(3, state);
                findStmt.setInt(4, Integer.parseInt(postalCode));
                findStmt.setString(5, country);

                try (ResultSet rs = findStmt.executeQuery()) {
                    if (rs.next()) {
                        // Address already exists, reuse its ID
                        addressID = rs.getInt("addressID");
                    }
                }
            }

            if (addressID == -1) {
                // Address does not exist, create a new one
                String insertAddressSQL = "INSERT INTO address (country, postalCode, street, city, state) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertAddressSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    insertStmt.setString(1, country);
                    insertStmt.setInt(2, Integer.parseInt(postalCode));
                    insertStmt.setString(3, street);
                    insertStmt.setString(4, city);
                    insertStmt.setString(5, state);
                    insertStmt.executeUpdate();

                    // Retrieve the new addressID
                    try (ResultSet generatedKeys = insertStmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            addressID = generatedKeys.getInt(1);
                        }
                    }
                }
            }

            // Check if the original address is shared with other tables (events, volunteer, beneficiary)
            boolean isAddressShared = false;

            // Query to check if the address is used in the events table
            String checkEventsSQL = "SELECT COUNT(*) FROM events WHERE addressID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkEventsSQL)) {
                stmt.setInt(1, Integer.parseInt(request.getParameter("addressID"))); // Original addressID
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int eventCount = rs.getInt(1);
                        if (eventCount > 1) { // If more than one event uses this address
                            isAddressShared = true;
                        }
                    }
                }
            }

            // Query to check if the address is used in the volunteer table
            String checkVolunteerSQL = "SELECT COUNT(*) FROM volunteer WHERE addressID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkVolunteerSQL)) {
                stmt.setInt(1, Integer.parseInt(request.getParameter("addressID"))); // Original addressID
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int volunteerCount = rs.getInt(1);
                        if (volunteerCount > 0) { // If any volunteer uses this address
                            isAddressShared = true;
                        }
                    }
                }
            }
                
            // Query to check if the address is used in the beneficiary table
            String checkBeneficiarySQL = "SELECT COUNT(*) FROM beneficiary WHERE addressID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkBeneficiarySQL)) {
                stmt.setInt(1, Integer.parseInt(request.getParameter("addressID"))); // Original addressID
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int beneficiaryCount = rs.getInt(1);
                        if (beneficiaryCount > 0) { // If any beneficiary uses this address
                            isAddressShared = true;
                        }
                    }
                }
            }

            // Update the event with the new or eisting addressID
            String updateEventSQL = "UPDATE events SET name = ?, date = ?, time = ?, duration = ?, description = ?, "
                    + "image = ?, donationLimit = ?, addressID = ? WHERE eventID = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateEventSQL)) {
                updateStmt.setString(1, eventName);
                updateStmt.setDate(2, Date.valueOf(eventDate));
                String formattedTime;

                if (eventTime.matches("\\d{2}:\\d{2}")) {

                    formattedTime = eventTime + ":00";
                } else if (eventTime.matches("\\d{2}:\\d{2}:\\d{2}")) {

                    formattedTime = eventTime;
                } else {

                    throw new IllegalArgumentException("Invalid time format: " + eventTime);
                }

                // Set the formatted time in the prepared statement
                updateStmt.setTime(3, Time.valueOf(formattedTime));
                updateStmt.setTime(4, duration);
                updateStmt.setString(5, desc);
                updateStmt.setBlob(6, imageInputStream);
                updateStmt.setDouble(7, donationLimit);
                updateStmt.setInt(8, addressID); // Use the new or existing addressID
                updateStmt.setInt(9, Integer.parseInt(idValue));
                updateStmt.executeUpdate();
            }

      

            PreparedStatement psTask = null;
            String sqlTask = null;
            
                  // If the original address is not shared, delete it
            if (!isAddressShared) {
                String deleteAddressSQL = "DELETE FROM address WHERE addressID = ?";
                try (PreparedStatement deleteStmt = conn.prepareStatement(deleteAddressSQL)) {
                    deleteStmt.setInt(1, Integer.parseInt(request.getParameter("addressID"))); // Original addressID
                    deleteStmt.executeUpdate();
                }
            }
            if (updatedTask != null) {

                sqlTask = "UPDATE task SET description = ?, eventID = ? WHERE taskID = ?";
                psTask = conn.prepareStatement(sqlTask);

                for (int i = 0; i < updatedTask.length; i++) {
                    String newTask = updatedTask[i];
                    String taskID = taskIDs[i];

                    psTask.setString(1, newTask);
                    psTask.setInt(2, Integer.parseInt(idValue));
                    psTask.setInt(3, Integer.parseInt(taskID));
                    psTask.addBatch();
                }

                if (psTask != null) {
                    psTask.executeBatch();
                }
            }

            if (!(newTasks == null)) {
                sqlTask = "INSERT INTO task (status, description, eventID, volunteerID) VALUES (?, ?, ?, ?)";
                psTask = conn.prepareStatement(sqlTask);

                for (int i = 0; i < newTasks.length; i++) {
                    String taskName = newTasks[i];

                    System.out.println("TaskName: " + taskName);

                    if (taskName == null || taskName.trim().isEmpty()) {
                        break;
                    }

                    psTask.setInt(1, 1);
                    psTask.setString(2, taskName);
                    psTask.setInt(3, Integer.parseInt(idValue));
                    psTask.setNull(4, java.sql.Types.NULL);
                    psTask.addBatch();
                }

                // Execute batch task insertions
                if (psTask != null) {
                    psTask.executeBatch();
                }
            }

            if (deleteTasks != null) {
                String[] taskIdsArray = deleteTasks.split(",");
                String sqlDeleteTask = "DELETE FROM task WHERE taskID = ?";
                PreparedStatement psDeleteTask = conn.prepareStatement(sqlDeleteTask);
                for (String taskIdStr : taskIdsArray) {
                    taskIdStr = taskIdStr.trim();
                    if (!taskIdStr.isEmpty()) {

                        int taskId = Integer.parseInt(taskIdStr);
                        psDeleteTask.setInt(1, taskId);
                        psDeleteTask.addBatch();

                    }
                }
                psDeleteTask.executeBatch();
                psDeleteTask.close();
            }

            String message = "The Event Name: " + eventName + " Successfully Updated";
            response.sendRedirect("/CommunityHub/success.jsp?msg=" + URLEncoder.encode(message, "UTF-8"));
            return;

        } catch (SQLException | ClassNotFoundException ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while updating the event.");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for updating event details including image upload.";
    }
}
