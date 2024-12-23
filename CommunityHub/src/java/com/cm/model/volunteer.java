/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cm.model;

/**
 *
 * @author Rina
 */
public class volunteer {
    private int volunteerID;
    private String name;
    private int contactInfo;
    private String username;
    private String password;
    private int addressID;

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

}
