package com.cm.model;


import java.sql.*;
import java.util.*;

public class beneficiary {
    private int beneficiaryID;
    private String name;
    private int contactInfo;
    private String username;
    private String password;
    private int addressID;

    /**
     * @return the beneficiaryID
     */
    public int getBeneficiaryID() {
        return beneficiaryID;
    }

    /**
     * @param beneficiaryID the beneficiaryID to set
     */
    public void setBeneficiaryID(int beneficiaryID) {
        this.beneficiaryID = beneficiaryID;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the contactInfo
     */
    public int getContactInfo() {
        return contactInfo;
    }

    /**
     * @param contactInfo the contactInfo to set
     */
    public void setContactInfo(int contactInfo) {
        this.contactInfo = contactInfo;
    }

    /**
     * @return the username
     */
    public String getUsername() {
        return username;
    }

    /**
     * @param username the username to set
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * @return the password
     */
    public String getPassword() {
        return password;
    }

    /**
     * @param password the password to set
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * @return the addressID
     */
    public int getAddressID() {
        return addressID;
    }

    /**
     * @param addressID the addressID to set
     */
    public void setAddressID(int addressID) {
        this.addressID = addressID;
    }
    
        @Override
    public String toString() {
        return "Beneficiary{" + "BeneficiaryID=" + beneficiaryID + ", name=" + getName() + ", contactInfo=" + getContactInfo() + '}';
    }

    // Add a new event to the database
    public void addEvent(Map<String, Object> eventDetails, Connection conn) throws SQLException {
        String sql = "INSERT INTO Events (name, date, description, status) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            // Explicitly use java.sql.Date to store SQL Date in the database
            ps.setString(1, (String) eventDetails.get("name"));
            ps.setDate(2, (java.sql.Date) eventDetails.get("date")); // Use java.sql.Date
            ps.setString(3, (String) eventDetails.get("description"));
            ps.setString(4, (String) eventDetails.get("status"));
            ps.executeUpdate();
        }
    }

    // Set roles for an event
    public void setEventRoles(int eventID, String roles, Connection conn) throws SQLException {
        String sql = "UPDATE Events SET roles = ? WHERE eventID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roles);
            ps.setInt(2, eventID);
            ps.executeUpdate();
        }
    }

    // View the list of participants (beneficiaries) for a given event
    public List<String> viewParticipantList(int eventID, Connection conn) throws SQLException {
        List<String> participants = new ArrayList<>();
        String sql = "SELECT name FROM Beneficiaries WHERE BeneficiaryID IN (SELECT BeneficiaryID FROM Volunteer_Event WHERE eventID = ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    participants.add(rs.getString("name"));
                }
            }
        }
        return participants;
    }

    // Update an event's details
    public void updateEvent(Map<String, Object> eventDetails, Connection conn) throws SQLException {
        String sql = "UPDATE Events SET name = ?, date = ?, description = ?, status = ? WHERE eventID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, (String) eventDetails.get("name"));
            ps.setDate(2, (java.sql.Date) eventDetails.get("date")); 
            ps.setString(3, (String) eventDetails.get("description"));
            ps.setString(4, (String) eventDetails.get("status"));
            ps.setInt(5, (int) eventDetails.get("eventID"));
            ps.executeUpdate();
        }
    }

    // Delete an event from the database
    public void deleteEvent(int eventID, Connection conn) throws SQLException {
        String sql = "DELETE FROM Events WHERE eventID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventID);
            ps.executeUpdate();
        }
    }
}
