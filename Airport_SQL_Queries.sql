create database airport_info ;
use  airport_info ;
select * from airports ;
select * from flights ;

-- Analysis 

/*1.What is the average departure and arrival delay per airline?*/
select Carrier,
round(avg(DepDelay)) as DepDelay,  round(avg(ArrDelay)) as ArrvlDelay
from  flights
group by Carrier
order by DepDelay desc  ;

/*2.Which airports have the highest average departure delays?*/
select a.name as AirportName, round(avg(f.DepDelay),2) as Avg_Delay
from airports as a join flights as f on a.airport_id = f.OriginAirportID
group by AirportName
order by Avg_Delay desc
limit 5 ; 

/*3.Which day of the week sees the most delays?*/
select  DayOfWeek, case
			when dayofweek = 1 then "Mon"
            when dayofweek = 2 then "Tue"
            when dayofweek = 3 then "Wed"
            when dayofweek = 4 then "Thur"
            when dayofweek = 5 then "Fri"
            when dayofweek = 6 then "Sat"
            else  "Sun"
            end as DayNAme,
	round(AVG(DepDelay), 2) AS AvgDepDelay,
       round(AVG(ArrDelay), 2) AS AvgArrDelay,
       round(AVG(DepDelay) + AVG(ArrDelay), 2) AS TotalAvgDelay
from flights
group by DayOfWeek
order by  TotalAvgDelay desc
limit 5;

/*4.Which city or state has the most delayed arrivals?*/
select a.city as City, avg(f.ArrDelay) as DelayArr
from airports as a join flights as f on a.airport_id = f.DestAirportID
group by City
order by DelayArr desc
limit 5 ; 

/*5.Which carrier has the best on-time performance?*/
select  Carrier, 
       COUNT(*) AS Total_Flights,
       SUM(case when ArrDelay <= 0 then 1 else 0 end) AS OnTime_Arrivals,
       ROUND(100.0 * SUM(case when ArrDelay <= 0 then 1 else 0 end) / COUNT(*), 2) AS OnTime_Percentage
from flights
group by Carrier
order by  OnTime_Percentage desc ;

/*6.What are the busiest flight routes? or Most Frequent Routes*/
select  o.name AS Origin, d.name AS Destination, COUNT(*) AS Flight_Count
from flights as  f
join airports as o on f.OriginAirportID = o.airport_id
join airports as d on f.DestAirportID = d.airport_id
group by  o.name, d.name
order by Flight_Count DESC
limit 10;

/*7.Busiest Airports by Total Flights (Departures + Arrivals)*/
SELECT 
    a.name AS Airport_Name,
    a.city AS City,
    a.state AS State,
    COUNT(f1.OriginAirportID) + COUNT(f2.DestAirportID) AS Total_Flights
FROM airports a
LEFT JOIN flights f1 ON a.airport_id = f1.OriginAirportID
LEFT JOIN flights f2 ON a.airport_id = f2.DestAirportID
GROUP BY a.name, a.city, a.state
ORDER BY Total_Flights DESC
LIMIT 10;

 