/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author anaqi
 */
package com.cm.model;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.time.LocalDate;
import java.sql.Blob;

public class donation {
    private int donationID;
    private double amount;
    private LocalDate date;
    private String receiptImagePath;
    private int eventID;
    private int donorID;
    private int volunteerID;
    
     public static Map<String, Object> getDonationDetails(int donationID, Connection conn) throws SQLException {
        String sql = "SELECT * FROM donations WHERE donationID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, donationID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Create a Map to hold the result
                    Map<String, Object> donationDetails = new HashMap<>();
                    donationDetails.put("donationID", rs.getInt("donationID"));
                    donationDetails.put("eventID", rs.getInt("eventID"));
                    donationDetails.put("donorID", rs.getInt("donorID"));
                    donationDetails.put("volunteerID", rs.getInt("volunteerID"));
                    donationDetails.put("amount", rs.getDouble("amount"));
                    donationDetails.put("date", rs.getDate("date").toLocalDate()); // Convert SQL Date to LocalDate
                    donationDetails.put("receiptImagePath", rs.getString("receiptImagePath"));
                    
                    return donationDetails;
                }
            }
        }
        
        return null; // Return null if no donation found
    }

    // Method to add a new donation to the database
    public static int addDonation(Map<String, Object> donationDetails, Connection conn) throws SQLException {
        String sql = "INSERT INTO Donation (eventID, donorID, volunteerID, amount, date, receiptImage) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, (Integer) donationDetails.get("eventID"));
            ps.setInt(2, (Integer) donationDetails.get("donorID"));
            ps.setInt(3, (Integer) donationDetails.get("volunteerID"));
            ps.setDouble(4, (Double) donationDetails.get("amount"));
            ps.setDate(5, Date.valueOf((LocalDate) donationDetails.get("date"))); // Convert LocalDate to SQL Date
            ps.setBlob(6, (Blob) donationDetails.get("receiptImage"));
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1); // Return the generated donationID
                    }
                }
            }
        }
        
        return -1;
    
}

    /**
     * @return the donationID
     */
    public int getDonationID() {
        return donationID;
    }

    /**
     * @param donationID the donationID to set
     */
    public void setDonationID(int donationID) {
        this.donationID = donationID;
    }

    /**
     * @return the amount
     */
    public double getAmount() {
        return amount;
    }

    /**
     * @param amount the amount to set
     */
    public void setAmount(double amount) {
        this.amount = amount;
    }

    /**
     * @return the date
     */
    public LocalDate getDate() {
        return date;
    }

    /**
     * @param date the date to set
     */
    public void setDate(LocalDate date) {
        this.date = date;
    }

    /**
     * @return the receiptImagePath
     */
    public String getReceiptImagePath() {
        return receiptImagePath;
    }

    /**
     * @param receiptImagePath the receiptImagePath to set
     */
    public void setReceiptImagePath(String receiptImagePath) {
        this.receiptImagePath = receiptImagePath;
    }

    /**
     * @return the eventID
     */
    public int getEventID() {
        return eventID;
    }

    /**
     * @param eventID the eventID to set
     */
    public void setEventID(int eventID) {
        this.eventID = eventID;
    }

    /**
     * @return the donorID
     */
    public int getDonorID() {
        return donorID;
    }

    /**
     * @param donorID the donorID to set
     */
    public void setDonorID(int donorID) {
        this.donorID = donorID;
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
    public void setVolunteerID(int volunteerID) {
        this.volunteerID = volunteerID;
    }
}
