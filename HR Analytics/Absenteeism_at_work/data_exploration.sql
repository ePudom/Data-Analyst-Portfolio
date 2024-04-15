--HR Request to Data Analysis team
--provide a list of healthy individuals and low absenteeism for healthy bonus program
--Calculate wage increase or annual compensation for non-smokers
--Create a dashboard for hr to understand absenteesim at work based on approved wireframe

select *
from absenteeism_at_work a;

select * from compensation;

select * from reasons;

select * 
from absenteeism_at_work a
left join compensation c
on a.ID = c.ID
left join reasons r
on a.Reason_for_absence = r.Number;

--get the healthiest employees
select *
from absenteeism_at_work
where Social_drinker = 0
and Social_smoker = 0
and Body_mass_index < 25
and absenteeism_time_in_hours > (
	select avg(absenteeism_time_in_hours) 
	from absenteeism_at_work
);

--compensation for non smokers
select count(*)
from absenteeism_at_work
where Social_smoker = 0;

--Total no of nonsmokers = 686
--Compensation budget/yr = $983,221
--Compensation per employee = 
--	Compensention budget / (Total work hours * Total no of non-smokers)
--Compensation per employee = 983,221/((8*5*52) * 686)
--	= $0.689/hr $1,433.12/yr

select a.ID, r.Reason, a.Month_of_absence,
case
	when a.Month_of_absence in (12,1,2) then 'Winter'
	when a.Month_of_absence in (3,4,5) then 'Spring'
	when a.Month_of_absence in (6,7,8) then 'Summer'
	when a.Month_of_absence in (9,10,11) then 'Fall'
	else 'Unknown'
end as seasons_names,
a.Body_mass_index,
case
	when a.Body_mass_index < 18.5 then 'Underweight'
	when a.Body_mass_index between 18.5 and 25  then 'Healthy'
	when a.Body_mass_index between 25 and 30 then 'Overweight'
	when a.Body_mass_index > 30 then 'Obese'
	else 'Unknown'
end as bmi_category, 
a.Day_of_the_week, a.Age, a.Absenteeism_time_in_hours,
a.Disciplinary_failure, a.Distance_from_Residence_to_Work,
a.Education, a.Transportation_expense, a.Work_load_Average_day,
a.Son, a.Social_drinker, a.Social_smoker, a.Pet
from absenteeism_at_work a
left join compensation c
on a.ID = c.ID
left join reasons r
on a.Reason_for_absence = r.Number;

select distinct
Month_of_absence
from absenteeism_at_work

select * from absenteeism_at_work 
where Month_of_absence = 0;

select min(age), max(age)
from absenteeism_at_work