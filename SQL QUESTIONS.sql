SHOW DATABASES;
#1 Create a database called house_price_regression.
CREATE DATABASE house_price_regression;
SHOW CREATE DATABASE house_price_regression;
USE house_price_regression;
#2 Create a table house_price_data with the same columns as given in the csv file. 
create table house_price_data(
   id VARCHAR(20),
   date	VARCHAR(20),
   bedrooms	INTEGER,
   bathrooms DECIMAL(10 , 2 ) NULL,
   sqft_living	INTEGER,
   sqft_lot	INTEGER,
   floors DECIMAL(10 , 2 ) NULL,
   waterfront INTEGER,
   view	INTEGER,
   conditio INTEGER,	
   grade INTEGER,	
   sqft_above INTEGER,	
   sqft_basement	INTEGER,
   yr_built	INTEGER,
   yr_renovated	INTEGER,
   zipcode	INTEGER,
   lat	DECIMAL(10 , 4 ) NULL,
   longi	DECIMAL(10 , 4 ) NULL,
   sqft_living15 INTEGER,		
   sqft_lot15	INTEGER,	
   price INTEGER,	
   PRIMARY KEY (id)
);
#3 Import the data from the csv file into the table :done

#4 Select all the data from table house_price_data to check if the data was imported correctly
select * from house_price_data
limit 5;
ALTER TABLE house_price_data RENAME COLUMN `conditio`TO `condition`;



#5 Use the alter table command to drop the column date from the database
ALTER TABLE house_price_data
  DROP COLUMN date;
  
select * from house_price_data
limit 5; 

#6 Use sql query to find how many rows of data you have.

SELECT COUNT(*)
FROM house_price_data;

#7 What are the unique values in the column bedrooms?
SELECT DISTINCT bedrooms
FROM house_price_data;

# What are the unique values in the column bathrooms?
SELECT DISTINCT bathrooms
FROM house_price_data;

# What are the unique values in the column floors?
SELECT DISTINCT floors
FROM house_price_data;

# What are the unique values in the column condition?
SELECT DISTINCT `condition`
FROM house_price_data;

# What are the unique values in the column grade?
SELECT DISTINCT grade
FROM house_price_data;

#8 Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.

SELECT id
FROM house_price_data
	ORDER BY price DESC
	LIMIT 10;

#9 What is the average price of all the properties in your data?
SELECT avg(price)
from house_price_data;

#10 In this exercise we will use simple group by to check the properties of some of the categorical variables in our data

# What is the average price of the houses grouped by bedrooms? 
SELECT bedrooms, avg(price) as "Average Price"
from house_price_data
	group by bedrooms;

# What is the average sqft_living of the houses grouped by bedrooms? 

SELECT bedrooms, avg(sqft_living) as "Average Sqft"
from house_price_data
	group by bedrooms;

# What is the average price of the houses with a waterfront and without a waterfront? 
SELECT waterfront, avg(price) as "Average Price"
from house_price_data
	group by waterfront;
    
# Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by 
#one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
SELECT `condition`, avg(grade)
FROM house_price_data
	GROUP BY `condition`
	ORDER BY `condition` asc;
# answer: table grade has a positive correlation  up until condition 4 where it shows a decrease of avg grade in comparison to the increase in condition

#11 One of the customers is only interested in the following houses:

####Number of bedrooms either 3 or 4
####Bathrooms more than 3
####One Floor
####No waterfront
####Condition should be 3 at least
####Grade should be 5 at least
####Price less than 300000

SELECT id,bedrooms, bathrooms, floors, waterfront, `condition`, grade, price
FROM house_price_data
WHERE 	(bedrooms = 3 || bedrooms = 4) AND
		bathrooms > 3 AND
        floors = 1 AND
        waterfront = 0 AND
        `condition` >= 3 AND
        grade >= 5 AND
        price < 300000;
        
#12 Your manager wants to find out the list of properties whose prices are twice more than the average 
#of all the properties in the database. Write a query to show them the list of such properties.

SELECT avg(PRICE)*2
FROM house_price_data
LIMIT 5;

Select * from house_price_data
where price >(
SELECT avg(PRICE)*2
FROM house_price_data);

#13 Since this is something that the senior management is regularly interested in, create a view of the same query.

CREATE VIEW twice_as_average_house AS
Select * from house_price_data
where price >(
SELECT avg(PRICE)*2
FROM house_price_data);

select * from twice_as_average_house;

#14 Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?

CREATE VIEW avg_bed AS
SELECT 
    bedrooms, AVG(price) AS average
FROM
    house_price_data
WHERE
    bedrooms = 3 OR bedrooms = 4
GROUP BY bedrooms
ORDER BY bedrooms Desc;

SELECT bedrooms,average
from avg_bed;

#15 averages per bedrooms, now will calculate the difference

#CREATE VIEW dif AS
SELECT 
bedrooms,
average,
(LEAD(average,1,average) OVER(ORDER BY bedrooms desc)) as row_up 
FROM avg_bed;
select average - row_up from dif
limit 1;

# the difference in average prices between 4 and 3 bedrooms is 169.267,0101

#What are the different locations where properties are available in your database? (distinct zip codes)

SELECT DISTINCT zipcode
FROM house_price_data;

#16 Show the list of all the properties that were renovated.
SELECT *
FROM house_price_data
WHERE yr_renovated > 0;

#17 Provide the details of the property that is the 11th most expensive property in your database.

WITH CTE AS (SELECT *
	FROM house_price_data
	ORDER BY price DESC
	LIMIT 11
    )
SELECT *
from CTE
ORDER BY price asc
LIMIT 1;



