package com.profile.servlet;

import com.profile.bean.ProfileBean;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

  
    private static final String DB_URL  = "jdbc:derby://localhost:1527/StudentProfilesDB";
    private static final String DB_USER = "app";
    private static final String DB_PASS = "app";

    // Method 
    private Connection getConnection() throws Exception {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    // POST requests
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action.equals("save")) {
            saveProfile(request, response);
        } else if (action.equals("delete")) {
            deleteProfile(request, response);
        }
    }

    // GET requests
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.equals("view")) {
            viewProfiles(request, response);
        } else if (action.equals("search")) {
            searchProfile(request, response);
        } else if (action.equals("delete")) {
            deleteProfile(request, response);
        }
    }

    // Save profile 
    private void saveProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String studentID    = request.getParameter("studentID");
        String name         = request.getParameter("name");
        String programme    = request.getParameter("programme");
        String email        = request.getParameter("email");
        String introduction = request.getParameter("introduction");

        // Get hobbies checkboxes
        String[] hobbiesArray = request.getParameterValues("hobbies");
        String hobbies = "";
        if (hobbiesArray != null) {
            hobbies = String.join(", ", hobbiesArray);
        }

        // Create ProfileBean object and set values
        ProfileBean profile = new ProfileBean();
        profile.setStudentID(studentID);
        profile.setName(name);
        profile.setProgramme(programme);
        profile.setEmail(email);
        profile.setHobbies(hobbies);
        profile.setIntroduction(introduction);

        try {
            // Connect to Java DB
            Connection conn = getConnection();

            // Insert into database
            String sql = "INSERT INTO Profile (studentID, name, programme, email, hobbies, introduction) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, profile.getStudentID());
            ps.setString(2, profile.getName());
            ps.setString(3, profile.getProgramme());
            ps.setString(4, profile.getEmail());
            ps.setString(5, profile.getHobbies());
            ps.setString(6, profile.getIntroduction());
            ps.executeUpdate();

            // Close connection
            ps.close();
            conn.close();

            // Send to profile.jsp for display
            request.setAttribute("profile", profile);
            request.setAttribute("message", "Profile saved successfully!");
            request.getRequestDispatcher("profile.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }

    // View all profiles
    private void viewProfiles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<ProfileBean> profileList = new ArrayList<ProfileBean>();

        try {
            Connection conn = getConnection();

            String sql = "SELECT * FROM Profile";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            // Loop through results and add to list
            while (rs.next()) {
                ProfileBean profile = new ProfileBean();
                profile.setStudentID(rs.getString("studentID"));
                profile.setName(rs.getString("name"));
                profile.setProgramme(rs.getString("programme"));
                profile.setEmail(rs.getString("email"));
                profile.setHobbies(rs.getString("hobbies"));
                profile.setIntroduction(rs.getString("introduction"));
                profileList.add(profile);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        request.setAttribute("profileList", profileList);
        request.getRequestDispatcher("viewProfiles.jsp").forward(request, response);
    }

    // Search profile by student ID or name
    private void searchProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";

        List<ProfileBean> profileList = new ArrayList<ProfileBean>();

        try {
            Connection conn = getConnection();

            // Search by studentID or name
            String sql = "SELECT * FROM Profile WHERE studentID LIKE ? OR name LIKE ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ProfileBean profile = new ProfileBean();
                profile.setStudentID(rs.getString("studentID"));
                profile.setName(rs.getString("name"));
                profile.setProgramme(rs.getString("programme"));
                profile.setEmail(rs.getString("email"));
                profile.setHobbies(rs.getString("hobbies"));
                profile.setIntroduction(rs.getString("introduction"));
                profileList.add(profile);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        request.setAttribute("profileList", profileList);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("viewProfiles.jsp").forward(request, response);
    }

    // Delete profile
    private void deleteProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentID = request.getParameter("studentID");

        try {
            Connection conn = getConnection();

            String sql = "DELETE FROM Profile WHERE studentID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, studentID);
            ps.executeUpdate();

            ps.close();
            conn.close();

        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        // Redirect back to view all profiles
        response.sendRedirect("ProfileServlet?action=view");
    }
}
