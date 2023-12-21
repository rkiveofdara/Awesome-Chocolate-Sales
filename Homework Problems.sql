# INTERMEDIATE PROBLEMS
# 👉 You need to combine various concepts covered in the video to solve these

# 1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
select * from sales
where amount > 2000 AND boxes < 100
order by amount;


# 2. How many shipments (sales) each of the sales persons had in the month of January 2022?
select s.SPID, s.SaleDate, p.Salesperson, s.Amount
from sales s
join people p on p.SPID = s.SPID
WHERE month(SaleDate) = 1 AND year(SaleDate) = 2022
order by day(SaleDate);
# Another alternative syntax
select p.Salesperson, count(*)
from sales s
join people p on s.spid = p.spid
where SaleDate between ‘2022-1-1’ and ‘2022-1-31’
group by p.Salesperson;



# 3. Which product sells more boxes? Milk Bars or Eclairs? 
select s.PID, pr.Product, SUM(s.Boxes) as 'Total Boxes'
from sales s
join products pr on pr.PID = S.PID
WHERE pr.product in ('Milk Bars', 'Eclairs')
group by pr.product 
order by pr.product;
### Answer: Eclairs > Milk Bars 


# 4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?
select s.PID, s.SaleDate, pr.Product, SUM(s.Boxes) as 'Total Boxes'
from sales s
join products pr on pr.PID = S.PID
WHERE pr.product in ('Milk Bars', 'Eclairs') 
and s.SaleDate between '2022-2-1' and '2022-2-7'
group by pr.product;
### Answer: Eclairs > Milk Bars 


# 5. Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?
# this syntax below is just to see Wednesday sales, cant see the other day
select * from sales
where customers <= 100 
and boxes <= 100 
and day(SaleDate) = 2;

# Another syntax
# this syntax below can see  not just wednesday
select * ,
		CASE WHEN day(SaleDate) = 3 THEN 'Wednesday'
		ELSE ''
		END AS 'Wednesday Shipment'
from sales
where customers <= 100  and boxes <= 100  ;

# Another syntax
# this syntax below can see all days DAYOFWEEK !!!
SELECT *,
       CASE WHEN DAYOFWEEK(SaleDate) = 1 THEN 'Sunday'
            WHEN DAYOFWEEK(SaleDate) = 2 THEN 'Monday'
            WHEN DAYOFWEEK(SaleDate) = 3 THEN 'Tuesday'
            WHEN DAYOFWEEK(SaleDate) = 4 THEN 'Wednesday'
            WHEN DAYOFWEEK(SaleDate) = 5 THEN 'Thursday'
            WHEN DAYOFWEEK(SaleDate) = 6 THEN 'Friday'
            WHEN DAYOFWEEK(SaleDate) = 7 THEN 'Saturday'
            ELSE ''
       END AS 'Day Shipment'
FROM sales
WHERE customers <= 100 AND boxes <= 100;



# HARD PROBLEMS
# 👉 These require concepts not covered in the video

# 1. What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
select distinct p.Salesperson
from people p
join sales s on s.spid = p.spid
where s.SaleDate between '2022-1-1' and '2022-1-7';

select distinct p.Salesperson
from sales s
join people p on p.spid = s.SPID
where s.SaleDate between '2022-01-01' and '2022-01-07';


# 2. Which salespersons did not make any shipments in the first 7 days of January 2022?
select p.salesperson
from people p
where p.spid not in
(select distinct s.spid from sales s where s.SaleDate between '2022-01-01' and '2022-01-07');


# 3. How many times we shipped more than 1,000 boxes in each month?
select year(SaleDate) as 'Year', month(SaleDate) as 'Month', count(*) as 'Times we shipped 1k'
from sales
where boxes > 1000
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);


# 4. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?
set @product_name = 'After Nines';
set @country_name = 'New Zealand';

select year(saledate) as 'Year', month(saledate) as 'Month',
if(sum(boxes)>1, 'Yes','No') 'Status'
from sales s
join products pr on pr.PID = s.PID
join geo g on g.GeoID=s.GeoID
where pr.Product = @product_name and g.Geo = @country_name
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);


# 5. India or Australia? Who buys more chocolate boxes on a monthly basis?
select year(saledate) as 'Year', month(saledate) as 'Month',
SUM(CASE WHEN g.geo = 'India' THEN boxes ELSE 0 END) as 'India Boxes',
SUM(CASE WHEN g.geo = 'Australia' THEN boxes ELSE 0 END) as 'Australia Boxes'
from sales as s
JOIN geo as g on g.geoid = s.geoid
group by year(SaleDate), month(saledate)
order by year(SaleDate), month(saledate);