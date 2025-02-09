package com.cm.model;

import java.util.HashMap;
import java.util.Map;
import java.io.Serializable;
import java.util.*;
import java.sql.Time;
import java.sql.Blob;

public class events implements Serializable{

    public static void add(events ev) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    private int eventID;
    private String name;
    private Blob image;
    private Date date;
    private Time time;
    private Time duration;
    private String description;
    private double donationLimit;
    private int volunteersNeeded;
    private String status;
    private int adminID;
    private int beneficiaryID;
    private int addressID;

    // Constructor
    public events(int eventID, String name, Date date, Time time, Time duration,String description, int volunteersNeeded, String status
                  ,Blob image, double donationLimit, int addressID) {
        this.eventID = eventID;
        this.name = name;
        this.date = date;
        this.time = time;
        this.duration = duration;
        this.description = description;
        this.volunteersNeeded = volunteersNeeded;
        this.status = status;
        this.image = image;
        this.donationLimit = donationLimit;
        this.addressID = addressID;
    }
    
    public events(String name, Date date, Time time, Time duration) {
        this.name = name;
        this.date = date ;
        this.time = time;
        this.duration = duration;
    }
    
    public events(int id, String name, Date date, Time time, Time duration) {
        this.eventID = id;
        this.name = name;
        this.date = date ;
        this.time = time;
        this.duration = duration;
    }
    
    public events(int id, String name, Date date) {
        this.eventID = id;
        this.name = name;
        this.date = date ;
    }
    
    
    // Getters
    public int getEventID() {
        return eventID;
    }

    public String getName() {
        return name;
    }

    public Date getDate() {
        return date;
    }

    public Time getTime() {
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
    
    public double getDonationLimit(){
        return donationLimit;
    }

    // Setters
    public void setEventID(int eventID) {
        this.eventID = eventID;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public void setTime(Time time) {
        this.time = time;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setVolunteersNeeded(int volunteersNeeded) {
        this.volunteersNeeded = volunteersNeeded;
    }
    
    public void setDonationLimit(double donationLimit){
        this.donationLimit = donationLimit;
    }

    /**
     * @return the duration
     */
    public Time getDuration() {
        return duration;
    }

    /**
     * @return the adminID
     */
    public int getAdminID() {
        return adminID;
    }

    /**
     * @return the beneficiaryID
     */
    public int getBeneficiaryID() {
        return beneficiaryID;
    }

    /**
     * @return the addressID
     */
    public int getAddressID() {
        return addressID;
    }
    // Update status method
    public void updateStatus(String newStatus) {
        this.status = newStatus;
    }
}
