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
public class donor {

    private int donorID;         // Primary key
    private String name;         // Donor name
    private int contactInfo;     // Contact info

    // Default constructor
    public donor() {}

    // Parameterized constructor
    public donor(int donorID, String name, int contactInfo) {
        this.donorID = donorID;
        this.name = name;
        this.contactInfo = contactInfo;
    }

    // Getters and Setters
    public int getDonorID() {
        return donorID;
    }

    public void setDonorID(int donorID) {
        this.donorID = donorID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(int contactInfo) {
        this.contactInfo = contactInfo;
    }

    @Override
    public String toString() {
        return "Donor{" +
                "donorID=" + donorID +
                ", name='" + name + '\'' +
                ", contactInfo=" + contactInfo +
                '}';
    }
}

