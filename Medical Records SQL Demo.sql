-- Create the patients table
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender CHAR(1),
    date_joined DATE
);

-- Insert patient data
INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, date_joined) VALUES
(1, 'John', 'Doe', '1985-05-15', 'M', '2020-01-01'),
(2, 'Jane', 'Smith', '1990-10-22', 'F', '2020-02-15'),
(3, 'Emily', 'Johnson', '1975-03-10', 'F', '2019-11-30'),
(4, 'Michael', 'Brown', '1988-08-05', 'M', '2021-05-20');

-- Create the medical_records table
CREATE TABLE medical_records (
    record_id INT PRIMARY KEY,
    patient_id INT,
    visit_date DATE,
    diagnosis VARCHAR(100),
    medication VARCHAR(100),
    follow_up_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Insert medical records data
INSERT INTO medical_records (record_id, patient_id, visit_date, diagnosis, medication, follow_up_date) VALUES
(1, 1, '2022-01-15', 'Hypertension', 'Lisinopril', '2022-07-15'),
(2, 2, '2022-03-10', 'Hyperlipidemia', 'Atorvastatin', '2022-09-10'),
(3, 3, '2023-02-20', 'Heart Failure', 'Furosemide', '2023-08-20'),
(4, 4, '2023-05-05', 'Atrial Fibrillation', 'Dronedarone', '2023-11-05');

-- Create the appointments table
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    appointment_date DATE,
    doctor_id INT,
    type VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Insert appointment data
INSERT INTO appointments (appointment_id, patient_id, appointment_date, doctor_id, type) VALUES
(1, 1, '2023-01-10', 101, 'Check-up'),
(2, 2, '2023-03-15', 102, 'Follow-up'),
(3, 3, '2023-04-20', 103, 'Consultation'),
(4, 4, '2023-07-25', 101, 'Check-up');

-- Create the doctors table
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialty VARCHAR(50)
);

-- Insert doctor data
INSERT INTO doctors (doctor_id, first_name, last_name, specialty) VALUES
(101, 'Alice', 'Green', 'Cardiology'),
(102, 'Bob', 'White', 'General Medicine'),
(103, 'Charlie', 'Black', 'Cardiology');




-- Count number of patients with their diagnoses

SELECT diagnosis, COUNT(*) AS patient_count
FROM medical_records
GROUP BY diagnosis;


-- Average age of patients diagnosed with Hypertension

SELECT AVG(YEAR(CURRENT_DATE) - YEAR(date_of_birth)) AS average_age
FROM patients
WHERE patient_id IN (
    SELECT patient_id
    FROM medical_records
    WHERE diagnosis = 'Hypertension'
);


-- List of patients with upcoming follow-up appointments within the next 30 days

SELECT p.first_name, p.last_name, a.appointment_date
FROM patients p
JOIN medical_records m ON p.patient_id = m.patient_id
JOIN appointments a ON p.patient_id = a.patient_id
WHERE a.appointment_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY);


-- List of doctors along with the number of patients they have seen

SELECT d.first_name, d.last_name, COUNT(a.patient_id) AS patient_count
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id;


-- Most common medication prescribed for each diagnosis

SELECT diagnosis, medication, COUNT(*) AS medication_count
FROM medical_records
GROUP BY diagnosis, medication
HAVING medication_count = (
    SELECT MAX(medication_count)
    FROM (
        SELECT COUNT(*) AS medication_count
        FROM medical_records
        WHERE diagnosis = m.diagnosis
        GROUP BY medication
    ) AS subquery
);


-- Patients who have both a diagnosis of Heart Failure and have an appointment scheduled in the next month

SELECT p.first_name, p.last_name
FROM patients p
WHERE p.patient_id IN (
    SELECT patient_id
    FROM medical_records
    WHERE diagnosis = 'Heart Failure'
)
AND p.patient_id IN (
    SELECT patient_id
    FROM appointments
    WHERE appointment_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)
);















