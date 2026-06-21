CREATE TABLE Profile (
    studentID    VARCHAR(20)  PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    programme    VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL,
    hobbies      VARCHAR(255),
    introduction VARCHAR(500)
);