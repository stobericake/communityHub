/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hub.controller;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author anaqi
 */
public class getImage extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet getImage</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet getImage at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
 protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Set appropriate content type (for example, image/jpeg for image BLOB)
    response.setContentType("image/jpeg"); // or "application/pdf", etc.

    try {
        // Establish connection to the database (adjust connection parameters)
        conn = dbconnection.getConnection();
        conn.setAutoCommit(false);  // Start transaction
        String type = request.getParameter("type");
        
        switch (type) {
            case "events":
                {
                    // Query to fetch the BLOB data
                    String sql = "SELECT image FROM events WHERE eventID = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(request.getParameter("id"))); // Get ID from request
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        // Retrieve BLOB as InputStream
                        InputStream inputStream = rs.getBinaryStream("image");
                        
                        // Check if the BLOB is NULL or empty
                        if (inputStream == null) {
                            // If BLOB is NULL, use the default image from assets folder
                            FileInputStream fileInputStream = new FileInputStream(getServletContext().getRealPath("/assets/noevent.jpg"));
                            OutputStream outStream = response.getOutputStream();
                            
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                                outStream.write(buffer, 0, bytesRead);
                            }
                            
                            fileInputStream.close();
                            outStream.flush();
                        } else {
                            // Otherwise, send the BLOB data to the response
                            OutputStream outStream = response.getOutputStream();
                            
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outStream.write(buffer, 0, bytesRead);
                            }
                            
                            inputStream.close();
                            outStream.flush();
                        }
                    }           break;
                }
            case "volunteer":
                {
                    // Query to fetch the BLOB data
                    String sql = "SELECT image FROM volunteer WHERE volunteerID = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(request.getParameter("id"))); // Get ID from request
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        // Retrieve BLOB as InputStream
                        InputStream inputStream = rs.getBinaryStream("image");
                        
                        // Check if the BLOB is NULL or empty
                        if (inputStream == null) {
                            // If BLOB is NULL, use the default image from assets folder
                            FileInputStream fileInputStream = new FileInputStream(getServletContext().getRealPath("/assets/nopicture.png"));
                            OutputStream outStream = response.getOutputStream();
                            
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                                outStream.write(buffer, 0, bytesRead);
                            }
                            
                            fileInputStream.close();
                            outStream.flush();
                        } else {
                            // Otherwise, send the BLOB data to the response
                            OutputStream outStream = response.getOutputStream();
                            
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outStream.write(buffer, 0, bytesRead);
                            }
                            
                            inputStream.close();
                            outStream.flush();
                        }
                    }           break;
                }
            case "beneficiary":
                {
                    // Query to fetch the BLOB data
                    String sql = "SELECT image FROM beneficiary WHERE beneficiaryID = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(request.getParameter("id"))); // Get ID from request
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        // Retrieve BLOB as InputStream
                        InputStream inputStream = rs.getBinaryStream("image");
                        
                        // Check if the BLOB is NULL or empty
                        if (inputStream == null) {
                            // If BLOB is NULL, use the default image from assets folder
                            FileInputStream fileInputStream = new FileInputStream(getServletContext().getRealPath("/assets/nopicture.png"));
                            OutputStream outStream = response.getOutputStream();
                            
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                                outStream.write(buffer, 0, bytesRead);
                            }
                            
                            fileInputStream.close();
                            outStream.flush();
                        } else {
                            // Otherwise, send the BLOB data to the response
                            OutputStream outStream = response.getOutputStream();
                            
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outStream.write(buffer, 0, bytesRead);
                            }
                            
                            inputStream.close();
                            outStream.flush();
                        }
                    }           break;
                }
            case "admin":
                {
                    // Query to fetch the BLOB data
                    String sql = "SELECT image FROM admin WHERE adminID = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(request.getParameter("id"))); // Get ID from request
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        // Retrieve BLOB as InputStream
                        InputStream inputStream = rs.getBinaryStream("image");
                        
                        // Check if the BLOB is NULL or empty
                        if (inputStream == null) {
                            // If BLOB is NULL, use the default image from assets folder
                            FileInputStream fileInputStream = new FileInputStream(getServletContext().getRealPath("/assets/nopicture.png"));
                            OutputStream outStream = response.getOutputStream();
                            
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                                outStream.write(buffer, 0, bytesRead);
                            }
                            
                            fileInputStream.close();
                            outStream.flush();
                        } else {
                            // Otherwise, send the BLOB data to the response
                            OutputStream outStream = response.getOutputStream();
                            
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outStream.write(buffer, 0, bytesRead);
                            }
                            
                            inputStream.close();
                            outStream.flush();
                        }
                    }           break;
                }
                case "donation":
                {
                    // Query to fetch the BLOB data
                    String sql = "SELECT receiptImage FROM donation WHERE donationID = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(request.getParameter("id"))); // Get ID from request
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        // Retrieve BLOB as InputStream
                        InputStream inputStream = rs.getBinaryStream("receiptImage");
                        
                        // Check if the BLOB is NULL or empty
                        if (inputStream == null) {
                            // If BLOB is NULL, use the default image from assets folder
                            FileInputStream fileInputStream = new FileInputStream(getServletContext().getRealPath("/assets/nopicture.jpg"));
                            OutputStream outStream = response.getOutputStream();
                            
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                                outStream.write(buffer, 0, bytesRead);
                            }
                            
                            fileInputStream.close();
                            outStream.flush();
                        } else {
                            // Otherwise, send the BLOB data to the response
                            OutputStream outStream = response.getOutputStream();
                            
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outStream.write(buffer, 0, bytesRead);
                            }
                            
                            inputStream.close();
                            outStream.flush();
                        }
                    }           break;
                }
            default:
                break;
        }
    } catch (SQLException | IOException e) {
        e.printStackTrace();
    } catch (ClassNotFoundException ex) {
        Logger.getLogger(getImage.class.getName()).log(Level.SEVERE, null, ex);
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(getImage.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
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
