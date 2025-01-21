/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import com.cm.model.admin;
import com.cm.model.address;
import com.cm.model.volunteer;
import com.cm.model.beneficiary;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author solah
 */
public class profileDetail extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userRole = session.getAttribute("userRole").toString();
        int userID = 1; // Replace with actual logic to fetch the logged-in user's ID.
        Connection conn = null;
        PreparedStatement stmt = null;
        PreparedStatement stmt1 = null;
        ResultSet rs = null;
        String query = null;

        int id = 0;
        address addressVar = null; // Initialize addressVar to null
        volunteer v1;

        try {
            conn = dbconnection.getConnection();

            // Fetch user data based on role
            if (userRole.equals("volunteer")) {
                id = Integer.parseInt(session.getAttribute("volunteer").toString());
                query = "SELECT * FROM volunteer WHERE volunteerID = ?";
            } else if (userRole.equals("beneficiary")) {
                id = Integer.parseInt(session.getAttribute("beneficiary").toString());
                query = "SELECT * FROM beneficiary WHERE beneficiaryID = ?";
            } else if (userRole.equals("admin")) {
                id = Integer.parseInt(session.getAttribute("admin").toString());
                query = "SELECT * FROM admin WHERE adminID = ?";
            }

            stmt = conn.prepareStatement(query);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            int addressID = 0; // Initialize addressID to 0

            if (rs.next()) {
                String name = rs.getString("name");
                int contactInfo = rs.getInt("contactInfo");
                Blob image = rs.getBlob("image");
                String username = rs.getString("username");
                String password = rs.getString("password");

                // Only retrieve addressID for volunteers and beneficiaries
                if (userRole.equals("volunteer") || userRole.equals("beneficiary")) {
                    addressID = rs.getInt("addressID");
                }

                if (userRole.equals("volunteer")) {
                    volunteer v = new volunteer(
                            rs.getInt("volunteerID"),
                            rs.getString("name"),
                            rs.getInt("contactInfo"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getInt("addressID"),
                            rs.getBlob("image")
                    );
                    request.setAttribute("volunteerObj", v);
                } else if (userRole.equals("beneficiary")) {
                    beneficiary b = new beneficiary(
                            rs.getInt("beneficiaryID"),
                            rs.getString("name"),
                            rs.getInt("contactInfo"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getInt("addressID"),
                            rs.getBlob("image")
                    );
                    request.setAttribute("beneficiaryObj", b);
                } else if (userRole.equals("admin")) {
                    admin a = new admin(
                            rs.getInt("adminID"),
                            rs.getString("name"),
                            rs.getString("email"),
                            rs.getInt("contactInfo"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getBlob("image")
                    );
                    request.setAttribute("adminObj", a);
                }

                // Set the image attribute
                request.setAttribute("profileImage", image);
            }

            // Fetch address data only for volunteers and beneficiaries
            if (userRole.equals("volunteer") || userRole.equals("beneficiary")) {
                String addressQuery = "SELECT * FROM address WHERE addressID = ?";
                stmt1 = conn.prepareStatement(addressQuery);
                stmt1.setInt(1, addressID);
                rs = stmt1.executeQuery();

                if (rs.next()) {
                    addressVar = new address(
                            rs.getInt("addressID"),
                            rs.getString("country"),
                            rs.getInt("postalCode"),
                            rs.getString("street"),
                            rs.getString("city"),
                            rs.getString("state")
                    );
                    request.setAttribute("addressObj", addressVar);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (stmt1 != null) {
                    stmt1.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
