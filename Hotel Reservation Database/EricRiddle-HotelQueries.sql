USE Hotel;

-- QUERY 1
-- Write a query that returns a list of reservations that end in July 2023, 
-- including the name of the guest, the room number(s), and the reservation dates.
--------------------
SELECT 
	Guest.FirstName,
    Guest.LastName,
    Room.RoomNumber,
    Reservation.CheckInDate,
    Reservation.CheckOutDate
FROM Guest
INNER JOIN GuestReservation ON Guest.GuestId = GuestReservation.GuestId
INNER JOIN Reservation ON  GuestReservation.ReservationId = Reservation.ReservationId
INNER JOIN RoomReservation ON Reservation.ReservationId = RoomReservation.ReservationId
INNER JOIN Room ON RoomReservation.RoomNumber = Room.RoomNumber
WHERE CheckOutDate BETWEEN '2023-07-01' AND '2023-07-31';

-- 4 rows
-- Eric		Riddle	205	2023-06-28	2023-07-02
-- Walter	Holaway	204	2023-07-13	2023-07-14
-- Wilfred	Vise	401	2023-07-18	2023-07-21
-- Bettyann	Seery	303	2023-07-28	2023-07-29


-- QUERY 2
-- Write a query that returns a list of all reservations for rooms with a jacuzzi, 
-- displaying the guest's name, the room number, and the dates of the reservation.
--------------------
SELECT
	Guest.FirstName,
    Guest.LastName,
    Room.RoomNumber,
    Reservation.CheckInDate,
    Reservation.CheckOutDate
FROM Room
INNER JOIN RoomReservation ON Room.RoomNumber = RoomReservation.RoomNumber
INNER JOIN Reservation ON RoomReservation.ReservationId = Reservation.ReservationId
INNER JOIN GuestReservation ON Reservation.ReservationId = GuestReservation.ReservationId
INNER JOIN Guest ON GuestReservation.GuestId = Guest.GuestId
WHERE HasJacuzzi = 1;
-- 11 rows
-- Karie		Yang		201	2023-03-06	2023-03-07
-- Bettyann		Seery		203	2023-02-05	2023-02-10
-- Karie		Yang		203	2023-09-13	2023-09-15
-- Eric			Riddle		205	2023-06-28	2023-07-02
-- Wilfred		Vise		207	2023-04-23	2023-04-24
-- Walter		Holaway		301	2023-04-09	2023-04-13
-- Mack			Simmer		301	2023-11-22	2023-11-25
-- Bettyann		Seery		303	2023-07-28	2023-07-29
-- Duane		Cullison	305	2023-02-22	2023-02-24
-- Bettyann		Seery		305	2023-08-30	2023-09-01
-- Eric			Riddle		307	2023-03-17	2023-03-20


-- QUERY 3
-- Write a query that returns all the rooms reserved for a specific guest, 
-- including the guest's name, the room(s) reserved, the starting date of the reservation, 
-- and how many people were included in the reservation. (Choose a guest's name from the existing data.)
--------------------
SELECT
	Guest.FirstName,
    Guest.LastName,
    Room.RoomNumber,
    Reservation.CheckInDate,
    Reservation.CheckOutDate,
    Reservation.Adults + Reservation.Children AS TotalPeople
FROM Guest
INNER JOIN GuestReservation ON Guest.GuestId = GuestReservation.GuestId
INNER JOIN Reservation ON  GuestReservation.ReservationId = Reservation.ReservationId
INNER JOIN RoomReservation ON Reservation.ReservationId = RoomReservation.ReservationId
INNER JOIN Room ON RoomReservation.RoomNumber = Room.RoomNumber
WHERE Guest.GuestId = 2;
-- RESULTS
-- 4 rows
-- Mack	Simmer	308	2023-02-02	2023-02-04	1
-- Mack	Simmer	208	2023-09-16	2023-09-17	2
-- Mack	Simmer	206	2023-11-22	2023-11-25	2
-- Mack	Simmer	301	2023-11-22	2023-11-25	4

-- QUERY 4
-- Write a query that returns a list of rooms, reservation ID, and per-room cost for each reservation. 
-- The results should include all rooms, whether or not there is a reservation associated with the room.
--------------------
SELECT
	Room.RoomNumber,
    Reservation.ReservationId,
    CASE
		WHEN (((Room.RoomNumber BETWEEN '201' AND '204') OR (Room.RoomNumber BETWEEN '301' AND '304')) AND Reservation.Adults <= 2)
			THEN ((Room.BasePrice) * DATEDIFF(Reservation.CheckOutDate, Reservation.CheckInDate))
		 WHEN (((Room.RoomNumber BETWEEN '201' AND '204') OR (Room.RoomNumber BETWEEN '301' AND '304')) AND Reservation.Adults > 2)
			 THEN ((Room.BasePrice + ((Reservation.Adults - Room.StandardOccupancy) * 10) * DATEDIFF(Reservation.CheckOutDate, Reservation.CheckInDate)))
		WHEN ((Room.RoomNumber BETWEEN '205' AND '208') OR (Room.RoomNumber BETWEEN '305' AND '308'))
			 THEN ((Room.BasePrice) * DATEDIFF(Reservation.CheckOutDate, Reservation.CheckInDate))
		WHEN (((Room.RoomNumber BETWEEN '401' AND '402')) AND Reservation.Adults <= 3)
			THEN ((Room.BasePrice) * DATEDIFF(Reservation.CheckOutDate, Reservation.CheckInDate))
		WHEN (((Room.RoomNumber BETWEEN '401' AND '402')) AND Reservation.Adults > 3)
			THEN ((Room.BasePrice + ((Reservation.Adults - Room.StandardOccupancy) * 20) * DATEDIFF(Reservation.CheckOutDate, Reservation.CheckInDate)))
	END AS Total
FROM Guest
RIGHT OUTER JOIN GuestReservation ON Guest.GuestId = GuestReservation.GuestId
RIGHT OUTER JOIN Reservation ON  GuestReservation.ReservationId = Reservation.ReservationId
RIGHT OUTER JOIN RoomReservation ON Reservation.ReservationId = RoomReservation.ReservationId
RIGHT OUTER JOIN Room ON RoomReservation.RoomNumber = Room.RoomNumber;
    
-- 26 rows
-- 201	4	199.99
-- 202	7	349.98
-- 203	2	999.95
-- 203	21	399.98
-- 204	16	184.99
-- 205	15	699.96
-- 206	12	599.96
-- 206	23	449.97
-- 207	10	174.99
-- 208	13	599.96
-- 208	20	149.99
-- 301	9	799.96
-- 301	24	599.97
-- 302	6	224.99
-- 302	25	699.96
-- 303	18	199.99
-- 304	14	184.99
-- 305	3	349.98
-- 305	19	349.98
-- 306		
-- 307	5	524.97
-- 308	1	299.98
-- 401	11	1199.97
-- 401	17	459.99
-- 401	22	1199.97
-- 402		
    

-- QUERY 5
-- Write a query that returns all the rooms accommodating at least 
-- three guests and that are reserved on any date in April 2023.
SELECT 
	Room.RoomNumber
FROM RESERVATION
INNER JOIN RoomReservation ON Reservation.ReservationId = RoomReservation.ReservationId
INNER JOIN Room ON RoomReservation.RoomNumber = Room.RoomNumber
WHERE 	(Reservation.Adults + Reservation.Children) > 2
		AND ((Reservation.CheckInDate BETWEEN '2023-04-01' AND '2023-04-30')
		OR (Reservation.CheckOutDate BETWEEN '2023-04-01' AND '2023-04-30'));
-- No rows returned

-- QUERY 6
-- Write a query that returns a list of all guest names and the number of reservations per guest, 
-- sorted starting with the guest with the most reservations and then by the guest's last name.
--------------------
SELECT 
	g.Firstname,
    g.Lastname,
    COUNT(gr.GuestId) AS TotalReservations
FROM Reservation r
INNER JOIN GuestReservation gr ON r.ReservationId = gr.ReservationId
INNER JOIN Guest g ON gr.GuestId = g.GuestId
GROUP BY g.FirstName
ORDER BY TotalReservations DESC, g.LastName;

-- 11 rows returned
-- Mack			Simmer			4
-- Bettyann		Seery			3
-- Duane		Cullison		2
-- Walter		Holaway			2
-- Aurore		Lipton			2
-- Eric			Riddle			2
-- Maritza		Tilton			2
-- Joleen		Tison			2
-- Wilfred		Vise			2
-- Karie		Yang			2
-- Zachery		Luechtefield	1

-- QUERY 7
-- Write a query that displays the name, address, and phone number of a guest 
-- based on their phone number. (Choose a phone number from the existing data.)
--------------------
SELECT 
	g.FirstName,
    g.LastName,
    g.Street,
    g.City,
    g.State,
    g.Zip,
    g.Phone
FROM GUEST g
WHERE g.Phone LIKE '%(291) 553-0508%';

-- 1 row
-- Mack		Simmer		379 Old Shore Street		Council Bluffs		IA		51501		(291) 553-0508


