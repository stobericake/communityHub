package com.cm.model;

import java.io.Serializable;
import java.sql.*;

public class task implements Serializable  {
    private int taskID;
    private String description;
    private int volunteersNeeded;
    private String status;
    private int eventID;
    private int volunteerID;
    private Connection connection; // Database connection object

    // Constructor that initializes the Task object and the database connection
    public task(int taskID, String description, int volunteersNeeded, String status, Connection connection) {
        this.taskID = taskID;
        this.description = description;
        this.volunteersNeeded = volunteersNeeded;
        this.status = status;
        this.connection = connection; // Set the connection from outside
    }

    // Getters and setters for the attributes
    public int getTaskID() {
        return taskID;
    }

    public String getDescription() {
        return description;
    }

    public int getVolunteersNeeded() {
        return volunteersNeeded;
    }

    public String getStatus() {
        return status;
    }

    public void setTaskID(int taskID) {
        this.taskID = taskID;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setVolunteersNeeded(int volunteersNeeded) {
        this.volunteersNeeded = volunteersNeeded;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * @return the eventID
     */
    public int getEventID() {
        return eventID;
    }

    /**
     * @return the volunteerID
     */
    public int getVolunteerID() {
        return volunteerID;
    }

    // Method to assign the task to a volunteer (assuming volunteerID is passed)
    public void assignTask(int volunteerID) {
        String sql = "UPDATE tasks SET assigned_to = ? WHERE task_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, volunteerID); // Assign volunteer to the task
            stmt.setInt(2, this.taskID);  // Specify the task ID to update
            stmt.executeUpdate();         // Execute the update
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Method to update the status of the task
    public void updateStatus(String newStatus) {
        this.status = newStatus; // Update the status in the object
        String sql = "UPDATE tasks SET status = ? WHERE task_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, newStatus);  // Set the new status
            stmt.setInt(2, this.taskID);   // Specify the task ID to update
            stmt.executeUpdate();          // Execute the update
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public String toString() {
        return "Task{" + "taskID=" + taskID + ", description=" + description + ", volunteersNeeded=" + volunteersNeeded + ", status=" + status + '}';
    }
}

