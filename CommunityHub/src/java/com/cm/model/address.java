package com.cm.model;

import java.io.Serializable;
import java.sql.*;
import java.util.Map;

public class address implements Serializable{
    private int addressID;
    private String country;
    private String postalCode;
    private String street;
    private String city;
    private String state;

    // Constructor
    public address(int addressID, String country, String postalCode, String street, String city, String state) {
        this.addressID = addressID;
        this.country = country;
        this.postalCode = postalCode;
        this.street = street;
        this.city = city;
        this.state = state;
    }

    // Getters and Setters
    public int getAddressID() {
        return addressID;
    }

    public String getCountry() {
        return country;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public String getStreet() {
        return street;
    }

    public String getCity() {
        return city;
    }

    public String getState() {
        return state;
    }

    public void setAddressID(int addressID) {
        this.addressID = addressID;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public void setState(String state) {
        this.state = state;
    }

    @Override
    public String toString() {
        return "Address{" + "addressID=" + addressID + ", country=" + country + ", postalCode=" + postalCode + ", street=" + street + ", city=" + city + ", state=" + state + '}';
    }

    // Method to update an address in the database
    public void updateAddress(Map<String, Object> addressDetails, Connection conn) throws SQLException {
        String sql = "UPDATE Address SET country = ?, postalCode = ?, street = ?, city = ?, state = ? WHERE addressID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, (String) addressDetails.get("country"));
            ps.setString(2, (String) addressDetails.get("postalCode"));
            ps.setString(3, (String) addressDetails.get("street"));
            ps.setString(4, (String) addressDetails.get("city"));
            ps.setString(5, (String) addressDetails.get("state"));
            ps.setInt(6, (int) addressDetails.get("addressID"));
            
            // Execute the update query
            ps.executeUpdate();
        }
    }
}
