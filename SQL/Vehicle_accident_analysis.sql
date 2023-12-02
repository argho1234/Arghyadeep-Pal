use sql_portfolio;
select * from accident;
-- Question 1: How many accidents have occurred in urban areas versus rural areas?

select count(distinct(AccidentIndex)) as accident_occured, Area from accident  group by Area; 

-- We can see that accident occured more in urban areas.

--Question 2: Which day of the week has the highest number of accidents?

select count(AccidentIndex) as accident_occured, Day from accident group by Day order by accident_occured desc;
-- We can see that most no of accidents occured on friday and least on the weekends.

-- Q3) What is the average age of vehicles involved in accidents based on their type?

select * from vehicle;
SELECT AVG(AgeVehicle) as avg_age,count(distinct(VehicleID)) as no_of_vehicles_involved_in_accident, VehicleType from vehicle where AgeVehicle is not null and VehicleType !='Data missing or out of range' group by VehicleType order by avg_age desc;
-- Removed  null and missing data.
-- Added count of vehicles.

--Question 4: Can we identify any trends in accidents based on the age of vehicles involved?

select count(AccidentIndex) as no_of_accidents, avg(AgeVehicle) as avg_age,count(VehicleID) as count_of_vehicles, vehicle_cond
from
(
select AccidentIndex,AgeVehicle,VehicleID,
case
when AgeVehicle between 1 and 5 then 'new_vehicle'
when AgeVehicle between 6 and 10 then 'medium_age_vehicle'
when AgeVehicle between 11 and 15 then 'old_vehicle'
else 'Needs_Replacing'
end as vehicle_cond
from vehicle
) as t1 group by vehicle_cond order by no_of_accidents desc;

--used a derived table for the case statement.

-- --Question 5: Are there any specific weather conditions that contribute to severe accidents?

select WeatherConditions, count(*) as no_of_accident from accident where Severity in ('Serious','Fatal') group by WeatherConditions order by no_of_accident desc;



-- Question 6: Do accidents often involve impacts on the left-hand side of vehicles?

select count(*) as no_of_accidents, LeftHand from vehicle where LeftHand  !='Data missing or out of range'  group by LeftHand order by no_of_accidents desc;

--Question 7: Are there any relationships between journey purposes and the severity of accidents?

select count(*) as no_of_accidents,Severity,JourneyPurpose from accident 
as acc join vehicle as vehi on acc.AccidentIndex=vehi.AccidentIndex where 
Severity in('Serious','Fatal') group by JourneyPurpose,Severity having JourneyPurpose!='Not known' order by JourneyPurpose;

--Question 8: Calculate the average age of vehicles involved in accidents , considering Day light and point of impact:

select * from vehicle,accident;

select avg(AgeVehicle) as avg_age, PointImpact, LightConditions from vehicle as v join accident as a on v.AccidentIndex=a.AccidentIndex 
group by PointImpact, LightConditions having PointImpact !='Data missing or out of range' order by PointImpact;

------------------------------------ END  -------------------------------------------------




