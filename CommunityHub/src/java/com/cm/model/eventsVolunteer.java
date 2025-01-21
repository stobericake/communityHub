/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cm.model;

import java.io.Serializable;

/**
 *
 * @author Ipah
 */
public class eventsVolunteer implements Serializable{

    public eventsVolunteer(int eventsVolunteerID, int eventID, int volunteerID, int attendance) {
        this.eventsVolunteerID = eventsVolunteerID;
        this.eventID = eventID;
        this.volunteerID = volunteerID;
        this.attendance = attendance;
    }
    private int eventsVolunteerID;
    private int eventID;
    private int volunteerID;
    private int attendance;

    public int getEventsVolunteerID() {
        return eventsVolunteerID;
    }

    public void setEventsVolunteerID(int eventsVolunteerID) {
        this.eventsVolunteerID = eventsVolunteerID;
    }

    public int getEventID() {
        return eventID;
    }

    public void setEventID(int eventID) {
        this.eventID = eventID;
    }

    public int getVolunteerID() {
        return volunteerID;
    }

    public void setVolunteerID(int volunteerID) {
        this.volunteerID = volunteerID;
    }
    
    public int getAttendance() {
        return attendance;
    }

    public void setAttendance(int attendance) {
        this.attendance = attendance;
    }
}

