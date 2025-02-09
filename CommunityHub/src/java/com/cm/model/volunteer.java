/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cm.model;


import java.io.Serializable;
import java.sql.*;

public class volunteer implements Serializable {
    private int volunteerID;
    private String name;
    private int contactInfo;
    private String username;
    private String password;
    private int addressID;
    private Blob image;
    
    public volunteer(int id, String name, int contact, String username, String password, int addressID, Blob image){
        this.volunteerID = id;
        this.name = name;
        this.contactInfo = contact;
        this.username = username;
        this.password = password;
        this.addressID = addressID;
        this.image = image;
    }
    
    public volunteer(int id, String name, int contact){
        this.volunteerID = id;
        this.name = name;
        this.contactInfo = contact;
    }
    /**
     * @return the volunteerID
     */
    public int getVolunteerID() {
        return volunteerID;
    }

    /**
     * @param volunteerID the volunteerID to set
     */
    public void setvolunteerID(int volunteerID) {
        this.volunteerID = volunteerID;
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
    
    /**
     * @return the image
     */
    public Blob getImage() {
        return image;
    }

    /**
     * @param addressID the addressID to set
     */
    public void setImage(Blob Image) {
        this.image = Image;
    }

    @Override
    public String toString() {
        return "Volunteer{" + "volunteerID=" + volunteerID + ", name=" + name + ", contactINfo=" + contactInfo + '}';
    }


    public void joinEvent(int eventID, Connection conn) throws SQLException {
        String sql = "INSERT INTO Event (volunteerID, eventID) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, this.volunteerID);
            ps.setInt(2, eventID);
            ps.executeUpdate();
        }
    }


    public void leaveEvent(int eventID, Connection conn) throws SQLException {
        String sql = "DELETE FROM Volunteer_Event WHERE volunteerID = ? AND eventID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, this.volunteerID);
            ps.setInt(2, eventID);
            ps.executeUpdate();
        }
    }


    public int makeDonation(int eventID, double amount, Connection conn) throws SQLException {
        String sql = "INSERT INTO Donations (volunteerID, eventID, amount) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, this.volunteerID);
            ps.setInt(2, eventID);
            ps.setDouble(3, amount);
            ps.executeUpdate();
            
            // Get the generated donation ID
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); // Returning the donation ID
                } else {
                    return -1; // Indicating failure to get donation ID
                }
            }
        }
    }

    // Choose task
    public void chooseTask(int eventID, int taskID, Connection conn) throws SQLException {
        String sql = "INSERT INTO Volunteer_Tasks (volunteerID, eventID, taskID) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, this.volunteerID);
            ps.setInt(2, eventID);
            ps.setInt(3, taskID);
            ps.executeUpdate();
        }
    }
}
