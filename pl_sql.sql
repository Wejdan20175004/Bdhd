-- Procedure: Monthly Report
CREATE OR REPLACE PROCEDURE Monthly_Report(
    p_year IN NUMBER,
    p_month IN NUMBER,
    p_venue_id IN NUMBER
)
IS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM venues WHERE venue_id = p_venue_id) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid Venue ID');
    END IF;

    FOR rec IN (
        SELECT *
        FROM events
        WHERE venue_id = p_venue_id
          AND EXTRACT(YEAR FROM start_date) = p_year
          AND EXTRACT(MONTH FROM start_date) = p_month
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Event ID: ' || rec.event_id || ', Name: ' || rec.event_name);
    END LOOP;
END;
/

-- Procedure: Organizer Services
CREATE OR REPLACE PROCEDURE Organizer_Services(
    p_name IN VARCHAR2
)
IS
BEGIN
    FOR rec IN (
        SELECT o.*, e.*
        FROM organizers o
        JOIN events e ON o.organizer_id = e.organizer_id
        WHERE o.name = p_name
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Organizer: ' || rec.name || ', Event: ' || rec.event_name);
    END LOOP;
END;
/

-- Procedure: Add Organizer
CREATE OR REPLACE PROCEDURE Add_Organizer(
    p_name IN VARCHAR2,
    p_email IN VARCHAR2,
    p_phone_number IN VARCHAR2
)
IS
BEGIN
    INSERT INTO organizers (name, email, phone_number)
    VALUES (p_name, p_email, p_phone_number);
    COMMIT;
END;
/

-- Procedure: Event Status
CREATE OR REPLACE PROCEDURE Event_Status(
    p_event_id IN NUMBER
)
IS
BEGIN
    FOR rec IN (
        SELECT *
        FROM events
        WHERE event_id = p_event_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Event ID: ' || rec.event_id || ', Name: ' || rec.event_name);
    END LOOP;
END;
/

-- Procedure: Event Registration
CREATE OR REPLACE PROCEDURE Event_Registration(
    p_event_name IN VARCHAR2,
    p_description IN VARCHAR2,
    p_start_date IN DATE,
    p_end_date IN DATE,
    p_organizer_id IN NUMBER,
    p_venue_id IN NUMBER,
    p_category_id IN NUMBER,
    p_budget IN NUMBER
)
IS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM organizers WHERE organizer_id = p_organizer_id) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid Organizer ID');
    ELSIF NOT EXISTS (SELECT 1 FROM venues WHERE venue_id = p_venue_id) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Invalid Venue ID');
    ELSIF NOT EXISTS (SELECT 1 FROM categories WHERE category_id = p_category_id) THEN
        RAISE_APPLICATION_ERROR(-20004, 'Invalid Category ID');
    END IF;

    INSERT INTO events (
        event_name, description, start_date, end_date, 
        organizer_id, venue_id, category_id, budget
    )
    VALUES (
        p_event_name, p_description, p_start_date, p_end_date, 
        p_organizer_id, p_venue_id, p_category_id, p_budget
    );
    COMMIT;
END;
/
