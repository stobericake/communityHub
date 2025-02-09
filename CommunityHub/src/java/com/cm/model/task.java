package com.cm.model;

import java.io.Serializable;
import java.sql.*;

public class task implements Serializable  {
    private int taskID;
    private String description;
    private int status;
    private int eventID;
    private int volunteerID;
    private Connection connection; // Database connection object

    // Constructor that initializes the Task object and the database connection
    public task(int taskID, String description, int status, int eventID, int volunteerID,
            Connection connection) {
        this.taskID = taskID;
        this.description = description;
        this.status = status;
        this.eventID = eventID;
        this.volunteerID = volunteerID;
        this.connection = connection; // Set the connection from outside
    }
        // Constructor that initializes the Task object and the database connection
    public task(int taskID, String description, int volunteerID) {
        this.taskID = taskID;
        this.description = description;
        this.volunteerID = volunteerID;
    }
    
    public task(int taskID, String description) {
        this.taskID = taskID;
        this.description = description;
    }

    // Getters and setters for the attributes
    public int getTaskID() {
        return taskID;
    }

    public String getDescription() {
        return description;
    }

    public int getStatus() {
        return status;
    }

    public void setTaskID(int taskID) {
        this.taskID = taskID;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setStatus(int status) {
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

}

