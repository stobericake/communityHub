package com.cm.model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.Map;

public class events {
    private int eventID;
    private String name;
    private LocalDate date;
    private LocalTime time;
    private LocalTime duration;
    private String description;
    private int volunteersNeeded;
    private String status;
    private String adminID;
    private String beneficiaryID;
    private String addressID;

    // Constructor
    public events(int eventID, String name, LocalDate date, LocalTime time, String description, int volunteersNeeded, String status) {
        this.eventID = eventID;
        this.name = name;
        this.date = date;
        this.time = time;
        this.description = description;
        this.volunteersNeeded = volunteersNeeded;
        this.status = status;
    }

    // Getters
    public int getEventID() {
        return eventID;
    }

    public String getName() {
        return name;
    }

    public LocalDate getDate() {
        return date;
    }

    public LocalTime getTime() {
        return time;
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

    // Setters
    public void setEventID(int eventID) {
        this.eventID = eventID;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public void setTime(LocalTime time) {
        this.time = time;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setVolunteersNeeded(int volunteersNeeded) {
        this.volunteersNeeded = volunteersNeeded;
    }

    // Update status method
    public void updateStatus(String newStatus) {
        this.status = newStatus;
    }

    // Get event details method
    public Map<String, Object> getEventDetails(int eventID) {
        // Create a map to store event details
        Map<String, Object> eventDetails = new HashMap<>();
        
        // Check if eventID matches the current object's eventID
        if (this.eventID == eventID) {
            eventDetails.put("eventID", this.eventID);
            eventDetails.put("name", this.name);
            eventDetails.put("date", this.date);
            eventDetails.put("time", this.time);
            eventDetails.put("description", this.description);
            eventDetails.put("volunteersNeeded", this.volunteersNeeded);
            eventDetails.put("status", this.status);
        }
        
        return eventDetails;
    }

    // Override toString for better representation
    @Override
    public String toString() {
        return "Event{" + "eventID=" + eventID + ", name=" + name + ", date=" + date + ", time=" + time + ", description=" + description + ", volunteersNeeded=" + volunteersNeeded + ", status=" + status + '}';
    }

    /**
     * @return the duration
     */
    public LocalTime getDuration() {
        return duration;
    }

    /**
     * @return the adminID
     */
    public String getAdminID() {
        return adminID;
    }

    /**
     * @return the beneficiaryID
     */
    public String getBeneficiaryID() {
        return beneficiaryID;
    }

    /**
     * @return the addressID
     */
    public String getAddressID() {
        return addressID;
    }
}
