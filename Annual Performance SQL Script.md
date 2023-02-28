# Annual Performance Report of After School Programs

## Purpose

This sample data is used to analyze the impact of after school programs as funded by federal monies using SQL. It is required to report this information to the appropriate government agencies. 

## Skills - SQL

Select, Case, Alias, Aggregation, Join, Nested Select Join

## Script

Number of students participated in each hour range by grade.

```
Select 
	Grade,
	SUM(CASE WHEN TotalHours < 15 THEN 1 ELSE 0 END) AS [Less Than 15 Hours],
	SUM(CASE WHEN TotalHours BETWEEN 15 AND 44 THEN 1 ELSE 0 END) as [15-44 Hours],
	SUM(CASE WHEN TotalHours BETWEEN 45 AND 89 THEN 1 ELSE 0 END) as [45-89 Hours],
	SUM(CASE WHEN TotalHours BETWEEN 90 AND 179 THEN 1 ELSE 0 END) as [90-179 Hours],
	SUM(CASE WHEN TotalHours BETWEEN 180 AND 269 THEN 1 ELSE 0 END) as [180-269 Hours],
	SUM(CASE WHEN TotalHours > 269 THEN 1 ELSE 0 END) as [270 Hours or More],
	COUNT(ID) AS Total
From AnnualPerformanceReport..StudentHours
Group by Grade
Order by Grade ASC  
 ```
 ![image](https://user-images.githubusercontent.com/88345207/194784051-7ecf7bf9-1662-4353-b50c-bb5c93b3d97a.png)


Number of students in each hour range by school site.

```
Select 
	School,
	SUM(CASE WHEN TotalHours < 15 THEN 1 ELSE 0 END) AS [Less Than 15 Hours],
	SUM(CASE WHEN TotalHours BETWEEN 15 AND 44 THEN 1 ELSE 0 END) as [15-44 Hours],
	SUM(CASE WHEN TotalHours BETWEEN 45 AND 89 THEN 1 ELSE 0 END) as [45-89 Hours],
	SUM(CASE WHEN TotalHours BETWEEN 90 AND 179 THEN 1 ELSE 0 END) as [90-179 Hours],
	SUM(CASE WHEN TotalHours BETWEEN 180 AND 269 THEN 1 ELSE 0 END) as [180-269  Hours],
	SUM(CASE WHEN TotalHours > 269 THEN 1 ELSE 0 END) as [270 Hours or More],
	COUNT(ID) AS Total
From AnnualPerformanceReport..StudentHours
Group by School
Order by School ASC
 ```
![image](https://user-images.githubusercontent.com/88345207/194784064-925e131b-eded-447d-8e04-be8d42a5db7a.png)


GPA data for students in grades 7-8 – Number of students in grades 7-8

```
Select 
	Grade,
	SUM(CASE WHEN TotalHours < 15 THEN 1 ELSE 0 END) AS [Less Than 15 Hours],
	SUM(CASE WHEN TotalHours BETWEEN 15 AND 44 THEN 1 ELSE 0 END) as [15-44 Hours],
	SUM(CASE WHEN TotalHours BETWEEN 45 AND 89 THEN 1 ELSE 0 END) as [45-89 Hours],
	SUM(CASE WHEN TotalHours BETWEEN 90 AND 179 THEN 1 ELSE 0 END) as [90-179 Hours],
	SUM(CASE WHEN TotalHours BETWEEN 180 AND 269 THEN 1 ELSE 0 END) as [180-269 Hours],
	SUM(CASE WHEN TotalHours > 269 THEN 1 ELSE 0 END) as [270 Hours or More],
	COUNT(ID) AS Total
From AnnualPerformanceReport..StudentHours
Where Grade IN ('7','8')
Group by Grade
Order by Grade ASC 
```
![image](https://user-images.githubusercontent.com/88345207/194784070-3e2e5759-b3fe-42b9-83cd-142c66a38e21.png)


GPA data for students in grades 7-8 – Number of 7th & 8th graders who had a prior-year GPA of less than a 3.0

```
Select 
	Hrs.Grade,
	SUM(CASE WHEN Hrs.TotalHours < 15 THEN 1 ELSE 0 END) AS [Less Than 15 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 15 AND 44 THEN 1 ELSE 0 END) as [15-44 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 45 AND 89 THEN 1 ELSE 0 END) as [45-89 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 90 AND 179 THEN 1 ELSE 0 END) as [90-179 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 180 AND 269 THEN 1 ELSE 0 END) as [180-269 Hours],
	SUM(CASE WHEN Hrs.TotalHours > 269 THEN 1 ELSE 0 END) as [270 Hours or More],
	COUNT(Hrs.ID) AS Total
From AnnualPerformanceReport..StudentHours as Hrs
	Inner Join AnnualPerformanceReport..GPA as GPA 
		On Hrs.ID=GPA.ID
Where GPA.finalGPA2021 < 3.0 
	and Hrs.Grade IN ('7','8')
Group by Hrs.Grade
Order by Hrs.Grade
```
![image](https://user-images.githubusercontent.com/88345207/194784111-a226f354-22ef-443b-b703-c9d182241155.png)

 
GPA data for students in grades 7-8 – Of the students above, how many demonstrated an improved GPA

```
Select 
	Hrs.Grade,
	SUM(CASE WHEN Hrs.TotalHours < 15 THEN 1 ELSE 0 END) AS [Less Than 15 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 15 AND 44 THEN 1 ELSE 0 END) as [15-44 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 45 AND 89 THEN 1 ELSE 0 END) as [45-89 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 90 AND 179 THEN 1 ELSE 0 END) as [90-179 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 180 AND 269 THEN 1 ELSE 0 END) as [180-269 Hours],
	SUM(CASE WHEN Hrs.TotalHours > 269 THEN 1 ELSE 0 END) as [270 Hours or More],
	COUNT(Hrs.ID) AS Total
From AnnualPerformanceReport..StudentHours as Hrs
	Inner Join AnnualPerformanceReport..GPA as GPA 
		On Hrs.ID=GPA.ID
	Inner Join (Select ID, (finalGPA2022 - finalGPA2021) as [GPA Difference]
				From AnnualPerformanceReport..GPA) as GPADif
					On GPA.ID=GPADif.ID
Where GPA.finalGPA2021 < 3.0 
	and Hrs.Grade IN ('7','8') 
	and GPADif.[GPA Difference] > 0
Group by Hrs.Grade
Order by Hrs.Grade
```
![image](https://user-images.githubusercontent.com/88345207/194784855-8f55c4de-f5cd-4d2e-a5cb-d936af86291b.png)


In-school suspension data – Number of students in grades 1-8

```
Select 
	Grade, 
	COUNT(ID) as [Number of Students]
From AnnualPerformanceReport..StudentHours
Where Grade not in ('KG')
Group by Grade
Order by Grade ASC
```
![image](https://user-images.githubusercontent.com/88345207/194784875-57ee5fe2-590e-47d8-bc03-8bdcf095d37d.png)


 
In-school suspension data – Number of students with in-school suspensions during the previous school year

```
Select 
	Hrs.Grade,
	SUM(CASE WHEN Hrs.TotalHours < 15 THEN 1 ELSE 0 END) AS [Less Than 15 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 15 AND 44 THEN 1 ELSE 0 END) as [15-44 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 45 AND 89 THEN 1 ELSE 0 END) as [45-89 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 90 AND 179 THEN 1 ELSE 0 END) as [90-179 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 180 AND 269 THEN 1 ELSE 0 END) as [180-269 Hours],
	SUM(CASE WHEN Hrs.TotalHours > 269 THEN 1 ELSE 0 END) as [270 Hours or More],
	COUNT(Hrs.ID) AS Total
From AnnualPerformanceReport..StudentHours as Hrs
	Inner Join AnnualPerformanceReport..Suspensions as Sus 
		On Hrs.ID=Sus.ID
Where Sus.InSchoolSuspensions2021 > 0 
	and Hrs.Grade not in ('KG')
Group by Hrs.Grade
```
![image](https://user-images.githubusercontent.com/88345207/194784902-d27b58d8-5731-4f15-abef-1f668fbb6d51.png)


In-school suspension data – Number of previous students with a decrease in in-school suspensions

```
Select Hrs.Grade,
	SUM(CASE WHEN Hrs.TotalHours < 15 THEN 1 ELSE 0 END) AS [Less Than 15 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 15 AND 44 THEN 1 ELSE 0 END) as [15-44 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 45 AND 89 THEN 1 ELSE 0 END) as [45-89 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 90 AND 179 THEN 1 ELSE 0 END) as [90-179 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 180 AND 269 THEN 1 ELSE 0 END) as [180-269 Hours],
	SUM(CASE WHEN Hrs.TotalHours > 269 THEN 1 ELSE 0 END) as [270 Hours or More],
	COUNT(Hrs.ID) AS Total
From AnnualPerformanceReport..StudentHours as Hrs
	Inner Join AnnualPerformanceReport..Suspensions as Sus 
		On Hrs.ID=Sus.ID
	Inner Join (Select ID, (InSchoolSuspensions2022 - InSchoolSuspensions2021) as [Suspension Difference]
				From AnnualPerformanceReport..Suspensions) as SusDif
					On Sus.ID=SusDif.ID
Where Sus.InSchoolSuspensions2021 > 0 
		and Hrs.Grade not in ('KG')
		and SusDif.[Suspension Difference] < 0
Group by Hrs.Grade
```
![image](https://user-images.githubusercontent.com/88345207/194784915-d437bcc8-b898-44cb-8bc5-fc6a7f531a8a.png)


Teacher survey – Number of students in grades 1-5

```
Select 
	Grade, 
	COUNT(ID) as [Number of Students]
From AnnualPerformanceReport..StudentHours
Where Grade in ('1','2','3','4','5')
Group by Grade
Order by Grade ASC
```
![image](https://user-images.githubusercontent.com/88345207/194784942-dfbce68c-a5ca-4391-b036-2a5025837dc3.png)


Teacher Survey – Class Participation Responses (Uncomment Survey.School to see school level data.)

```
Select 
	--Survey.School,
	Survey.ClassParticipation,
	SUM(CASE WHEN Hrs.TotalHours < 15 THEN 1 ELSE 0 END) AS [Less Than 15 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 15 AND 44 THEN 1 ELSE 0 END) as [15-44 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 45 AND 89 THEN 1 ELSE 0 END) as [45-89 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 90 AND 179 THEN 1 ELSE 0 END) as [90-179 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 180 AND 269 THEN 1 ELSE 0 END) as [180-269 Hours],
	SUM(CASE WHEN Hrs.TotalHours > 269 THEN 1 ELSE 0 END) as [270 Hours or More],
	COUNT(Hrs.ID) AS Total
From AnnualPerformanceReport..StudentHours as Hrs
	Inner Join AnnualPerformanceReport..Survey as Survey 
		On Hrs.ID= Survey.ID
Where Hrs.Grade in ('1','2','3','4','5') 
	and Survey.ClassParticipation in ('Decreased', 'Remained the same', 'Did not need to improve', 'Improved')
Group by 
	--Survey.School,
	Survey.ClassParticipation 
```
![image](https://user-images.githubusercontent.com/88345207/194784957-3fa83814-7387-4798-826b-9c55387ec53e.png)


Teacher Survey – Peer Relationships Responses (Uncomment Survey.School to see school level data.)

```
Select 
	--Survey.School, 
	Survey.PeerRelationships,
	SUM(CASE WHEN Hrs.TotalHours < 15 THEN 1 ELSE 0 END) AS [Less Than 15 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 15 AND 44 THEN 1 ELSE 0 END) as [15-44 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 45 AND 89 THEN 1 ELSE 0 END) as [45-89 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 90 AND 179 THEN 1 ELSE 0 END) as [90-179 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 180 AND 269 THEN 1 ELSE 0 END) as [180-269 Hours],
	SUM(CASE WHEN Hrs.TotalHours > 269 THEN 1 ELSE 0 END) as [270 Hours or More],
	COUNT(Hrs.ID) AS Total
From AnnualPerformanceReport..StudentHours as Hrs
	Inner Join AnnualPerformanceReport..Survey as Survey 
		On Hrs.ID= Survey.ID
Where Hrs.Grade in ('1','2','3','4','5') and 
	Survey.PeerRelationships in ('Decreased', 'Remained the same', 'Did not need to improve', 'Improved')
Group by 
	--Survey.School,
	Survey.PeerRelationships
```
 ![image](https://user-images.githubusercontent.com/88345207/194783770-6041c628-c53a-4b6e-8615-8fbfc20ed40d.png)


Teacher Survey – Class Behavior Responses (Uncomment Survey.School to see school level data.)

```
Select 
	--Survey.School, 
	Survey.ClassroomBehavior,
	SUM(CASE WHEN Hrs.TotalHours < 15 THEN 1 ELSE 0 END) AS [Less Than 15 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 15 AND 44 THEN 1 ELSE 0 END) as [15-44 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 45 AND 89 THEN 1 ELSE 0 END) as [45-89 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 90 AND 179 THEN 1 ELSE 0 END) as [90-179 Hours],
	SUM(CASE WHEN Hrs.TotalHours BETWEEN 180 AND 269 THEN 1 ELSE 0 END) as [180-269 Hours],
	SUM(CASE WHEN Hrs.TotalHours > 269 THEN 1 ELSE 0 END) as [270 Hours or More],
	COUNT(Hrs.ID) AS Total
From AnnualPerformanceReport..StudentHours as Hrs
	Inner Join AnnualPerformanceReport..Survey as Survey 
		On Hrs.ID= Survey.ID
Where Hrs.Grade in ('1','2','3','4','5') and 
	Survey.ClassroomBehavior in ('Decreased', 'Remained the same', 'Did not need to improve', 'Improved')
Group by 
		--Survey.School,
		Survey.ClassroomBehavior
```    

![image](https://user-images.githubusercontent.com/88345207/194783756-502b2bc7-d3c8-47db-a7e4-6d20f821ab7e.png)

