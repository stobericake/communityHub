package com.cm.model;

import java.io.Serializable;
import java.sql.*;
import java.util.Map;

public class address implements Serializable{
    private int addressID;
    private String country;
    private int postalCode;
    private String street;
    private String city;
    private String state;

    // Constructor
    public address(int addressID, String country, int postalCode, String street, String city, String state) {
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

    public int getPostalCode() {
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

    public void setPostalCode(int postalCode) {
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


}
