<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.profile.bean.ProfileBean" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>View Profiles — CSC584</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="css/style.css"/>
</head>
<body>

  <div class="bg-orb orb1"></div>
  <div class="bg-orb orb2"></div>

  <%
    List<ProfileBean> profileList = (List<ProfileBean>) request.getAttribute("profileList");
    String keyword = (String) request.getAttribute("keyword");
    String error   = (String) request.getAttribute("error");
  %>

  <div class="container">
    <header class="hero">
      <div class="badge">CSC584 Assignment 2</div>
      <h1>All Profiles</h1>
      <p class="subtitle">List of all registered student profiles</p>
    </header>

    
    <div class="nav-links">
      <a href="index.html" class="nav-btn">➕ Add Profile</a>
      <a href="ProfileServlet?action=view" class="nav-btn active">📋 View All Profiles</a>
    </div>

    <div class="view-card">

      <h2>Student Profiles</h2>
      <p>All registered profiles in the database</p>

      
      <form action="ProfileServlet" method="GET">
        <input type="hidden" name="action" value="search"/>
        <div class="search-box">
          <input type="text" name="keyword"
                 placeholder="🔍 Search by Student ID or Name..."
                 value="<%= keyword != null ? keyword : "" %>"/>
          <button type="submit" class="search-btn">Search</button>
          <a href="ProfileServlet?action=view" class="reset-btn">Reset</a>
        </div>
      </form>

      
      <% if (error != null) { %>
        <p style="color:#ef4444; margin-bottom:1rem;">❌ <%= error %></p>
      <% } %>

      
      <% if (keyword != null && !keyword.isEmpty()) { %>
        <div class="alert-info">
          🔍 Results for: <strong>"<%= keyword %>"</strong>
          — Found <strong><%= profileList.size() %></strong> result(s)
        </div>
      <% } %>

      
      <% if (profileList != null && profileList.size() > 0) { %>

        <div style="overflow-x:auto;">
          <table class="profile-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Student ID</th>
                <th>Name</th>
                <th>Programme</th>
                <th>Email</th>
                <th>Hobbies</th>
                <th>Introduction</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <%
                int count = 1;
                for (ProfileBean p : profileList) {
              %>
              <tr>
                <td><%= count++ %></td>
                <td><strong><%= p.getStudentID() %></strong></td>
                <td><%= p.getName() %></td>
                <td style="font-size:0.78rem;"><%= p.getProgramme() %></td>
                <td><%= p.getEmail() %></td>
                <td style="font-size:0.78rem;"><%= p.getHobbies() != null ? p.getHobbies() : "—" %></td>
                <td style="font-size:0.78rem; max-width:150px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                  <%= p.getIntroduction() != null ? p.getIntroduction() : "—" %>
                </td>
                <td>
                  <a href="ProfileServlet?action=delete&studentID=<%= p.getStudentID() %>"
                     class="delete-btn"
                     onclick="return confirm('Delete this profile?')">
                     🗑️ Delete
                  </a>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>

        <p style="color:var(--text-muted); font-size:0.8rem; margin-top:1rem; text-align:right;">
          Total: <strong><%= profileList.size() %></strong> profile(s)
        </p>

      <% } else { %>
        <div class="empty-state">
          <p>😕 No profiles found.</p>
          <a href="index.html" class="back-btn">➕ Add First Profile</a>
        </div>
      <% } %>

    </div>
  </div>

</body>
</html>
