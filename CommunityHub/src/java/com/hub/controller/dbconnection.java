/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;
import java.sql.*;


/**
 *
 * @author anaqi
 */

public class dbconnection {
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        String url = "jdbc:mysql://localhost:3307/communityhub"; // Replace with your DB name
        String user = "root"; // Replace with your DB username
        String password = ""; // Replace with your DB password

        // Load the MySQL JDBC driver
        Class.forName("com.mysql.jdbc.Driver");

        // Establish and return the database connection
        return DriverManager.getConnection(url, user, password);
    }
}
