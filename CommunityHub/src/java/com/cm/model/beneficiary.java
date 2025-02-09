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
    private Blob image;

    public beneficiary(int beneficiaryID, String name, int contactInfo, String username, String password, int addressID, Blob image) {
        this.beneficiaryID = beneficiaryID;
        this.name = name;
        this.contactInfo = contactInfo;
        this.username = username;
        this.password = password;
        this.addressID = addressID;
        this.image = image;
    }
    
        // Constructor
    public beneficiary(int beneficiaryID, String name) {
        this.beneficiaryID = beneficiaryID;
        this.name = name;
    }

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


}
