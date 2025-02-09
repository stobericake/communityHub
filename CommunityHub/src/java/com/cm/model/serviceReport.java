/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


package com.cm.model;
import java.io.Serializable;
import java.util.Date;

public class serviceReport implements Serializable {
    private int reportID;
    private int eventID;
    private int volunteerID;
    private String problem;
    private String solution;
    private String recommendation;
    private Date dateSubmitted;
    private String feedback;

    public serviceReport(int reportID, int eventID, int volunteerID, String problem, String solution, String recommendation, Date dateSubmitted, String feedback) {
        this.reportID = reportID;
        this.eventID = eventID;
        this.volunteerID = volunteerID;
        this.problem = problem;
        this.solution = solution;
        this.recommendation = recommendation;
        this.dateSubmitted = dateSubmitted;
        this.feedback = feedback;
    }

    public int getReportID() {
        return reportID;
    }

    public int getEventID() {
        return eventID;
    }

    public int getVolunteerID() {
        return volunteerID;
    }

    public String getProblem() {
        return problem;
    }

    public String getSolution() {
        return solution;
    }

    public String getRecommendation() {
        return recommendation;
    }

    public Date getDateSubmitted() {
        return dateSubmitted;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setReportID(int reportID) {
        this.reportID = reportID;
    }

    public void setEventID(int eventID) {
        this.eventID = eventID;
    }

    public void setVolunteerID(int volunteerID) {
        this.volunteerID = volunteerID;
    }

    public void setProblem(String problem) {
        this.problem = problem;
    }

    public void setSolution(String solution) {
        this.solution = solution;
    }

    public void setRecommendation(String recommendation) {
        this.recommendation = recommendation;
    }

    public void setDateSubmitted(Date dateSubmitted) {
        this.dateSubmitted = dateSubmitted;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    @Override
    public String toString() {
        return "ServiceReport{" + "reportID=" + reportID + ", eventID=" + eventID + ", volunteerID=" + volunteerID + ", problem=" + problem + ", solution=" + solution + ", recommendation=" + recommendation + ", dateSubmitted=" + dateSubmitted + ", feedback=" + feedback + '}';
    }

    
}

