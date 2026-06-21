<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.profile.bean.ProfileBean" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Profile Saved — CSC584</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="css/style.css"/>
</head>
<body>

  <div class="bg-orb orb1"></div>
  <div class="bg-orb orb2"></div>

  <%
    ProfileBean profile = (ProfileBean) request.getAttribute("profile");
    String message = (String) request.getAttribute("message");
    String error   = (String) request.getAttribute("error");
  %>

  <div class="container">
    <header class="hero">
      <div class="badge">CSC584 Assignment 2</div>
      <h1>Profile Submitted</h1>
      <p class="subtitle">Here's your profile summary</p>
    </header>

    <!-- Navigation -->
    <div class="nav-links">
      <a href="index.html" class="nav-btn">➕ Add Profile</a>
      <a href="ProfileServlet?action=view" class="nav-btn">📋 View All Profiles</a>
    </div>

    <% if (error != null) { %>
      <div class="result-card">
        <p style="color:#ef4444;">❌ <%= error %></p>
        <a href="index.html" class="back-btn">← Go Back</a>
      </div>

    <% } else if (profile != null) { %>

      <div class="result-card">
        <div class="success-badge">✔ <%= message %></div>

        <%
          // Generate avatar initials
          String initials = "?";
          if (profile.getName() != null && !profile.getName().isEmpty()) {
            String[] parts = profile.getName().trim().split("\\s+");
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < Math.min(parts.length, 2); i++) {
              if (!parts[i].isEmpty()) sb.append(parts[i].charAt(0));
            }
            initials = sb.toString().toUpperCase();
          }
        %>

        <!-- Avatar + Name -->
        <div style="display:flex; align-items:center; gap:1.2rem; margin-bottom:2rem;">
          <div style="width:64px; height:64px; border-radius:50%;
            background:linear-gradient(135deg,#7c6ef7,#9b8df8);
            display:flex; align-items:center; justify-content:center;
            font-family:'Playfair Display',serif; font-size:1.5rem;
            font-weight:700; color:#fff; flex-shrink:0;
            box-shadow:0 4px 18px rgba(124,110,247,0.4);">
            <%= initials %>
          </div>
          <div>
            <h2 style="margin-bottom:0.1rem;"><%= profile.getName() %></h2>
            <p class="tagline"><%= profile.getProgramme() %></p>
          </div>
        </div>

        <!-- Info Grid -->
        <div class="info-grid">
          <div class="info-item">
            <div class="label">🎓 Student ID</div>
            <div class="value"><%= profile.getStudentID() %></div>
          </div>
          <div class="info-item">
            <div class="label">✉️ Email</div>
            <div class="value"><%= profile.getEmail() %></div>
          </div>
        </div>

        <!-- Programme -->
        <div class="info-full">
          <div class="label">📚 Programme</div>
          <div class="value"><%= profile.getProgramme() %></div>
        </div>

        <!-- Hobbies -->
        <div class="info-full">
          <div class="label">🎯 Hobbies</div>
          <div class="value">
            <%
              if (profile.getHobbies() != null && !profile.getHobbies().isEmpty()) {
                String[] hobbyList = profile.getHobbies().split(", ");
                out.print("<div class='hobby-tags'>");
                for (String h : hobbyList) {
                  out.print("<span class='hobby-tag'>" + h + "</span>");
                }
                out.print("</div>");
              } else {
                out.print("<span style='color:var(--text-muted)'>None selected</span>");
              }
            %>
          </div>
        </div>

        <!-- Introduction -->
        <div class="info-full">
          <div class="label">📝 Self Introduction</div>
          <div class="value" style="white-space:pre-wrap;">
            <%= profile.getIntroduction() != null ? profile.getIntroduction() : "—" %>
          </div>
        </div>

        <!-- Buttons -->
        <div style="display:flex; gap:0.8rem; flex-wrap:wrap; margin-top:1.5rem;">
          <a href="index.html" class="back-btn">← Add Another Profile</a>
          <a href="ProfileServlet?action=view" class="back-btn">📋 View All Profiles</a>
        </div>
      </div>

    <% } %>
  </div>

</body>
</html>
