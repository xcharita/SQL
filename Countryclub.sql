/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name 
FROM Facilities 
WHERE membercost <> 0.0

/* Q2: How many facilities do not charge a fee to members? */

SELECT count(name) AS "Amount facilities with no charge"
FROM Facilities
WHERE membercost = 0.0

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost < 0.2*monthlymaintenance

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE facid = 1 OR facid = 5

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name "Facility", monthlymaintenance "Cost",
CASE	WHEN monthlymaintenance > 100 THEN "Expensive"
		WHEN monthlymaintenance <= 100 THEN "Cheap"
		ELSE "100"
END AS Indication
FROM Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
SELECT firstname, surname
FROM Members
ORDER BY joindate DESC

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT firstname "Firstname", surname "Lastname", f.name "Facility used"
FROM Members m

INNER JOIN Bookings b  ON m.memid =  b.memid
INNER JOIN Facilities f ON f.facid = b.facid
WHERE (f.name = "Tennis Court 1") OR (f.name = "Tennis Court 2")

GROUP BY firstname, surname, f.name

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT CONCAT(m.surname, " ", m.firstname) AS "Name", f.name "Facility name", 

CASE 
WHEN b.memid = 0 THEN f.guestcost*b.slots
ELSE f.membercost*b.slots
END AS Cost

FROM Bookings b, Members m, Facilities f
WHERE (b.starttime > '2012-09-13 23:59:59' AND
b.starttime < '2012-09-15 00:00:00') AND
(m.memid = b.memid AND
f.facid = b.facid)

GROUP BY m.memid, f.facid, Cost DESC

HAVING Cost>30


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT CONCAT(m.surname, " ", m.firstname) AS "Name", f.name "Facility name", 

CASE 
WHEN b.memid = 0 THEN f.guestcost*b.slots
ELSE f.membercost*b.slots
END AS Cost

from
  (select memid, facid, slots from Bookings where DATE(starttime) = '2012-09-14' limit 100) b
join
  Members m
on
  b.memid = m.memid
join
  Facilities f
on
  b.facid = f.facid

Having Cost>30


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT f.name "Facility name",

SUM(CASE 
WHEN b.memid = 0 THEN (f.guestcost*b.slots) 
ELSE (f.membercost*b.slots)
END) AS Revenue

FROM Bookings b

JOIN Facilities f ON b.facid = f.facid

Group By f.name

HAVING Revenue<1000



