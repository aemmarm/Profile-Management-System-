package com.profile.bean;

/**
 * ProfileBean.java
 * CSC584 Individual Assignment 2
 */
public class ProfileBean {

    // Private attributes
    private String studentID;
    private String name;
    private String programme;
    private String email;
    private String hobbies;
    private String introduction;

    // Default constructor
    public ProfileBean() {
    }

    // Getter methods
    public String getStudentID() {
        return studentID;
    }

    public String getName() {
        return name;
    }

    public String getProgramme() {
        return programme;
    }

    public String getEmail() {
        return email;
    }

    public String getHobbies() {
        return hobbies;
    }

    public String getIntroduction() {
        return introduction;
    }

    // Setter methods
    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setProgramme(String programme) {
        this.programme = programme;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setHobbies(String hobbies) {
        this.hobbies = hobbies;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }
}
