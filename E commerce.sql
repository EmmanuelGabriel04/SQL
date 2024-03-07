Select *
From [Online Retail]

--looking at  value count
Select Item_Description, count(*) Order_Counts
from [Online Retail]
group by Item_Description
order by 2 desc;

Select CustomerID, count(*) Customer_Counts
from [Online Retail]
where CustomerID is not null
group by CustomerID
order by 2 desc;
--note: there are lot of customers whose id were missing

Select Country, count(*) Country_Counts
from [Online Retail]
where country is not null
group by country
order by 2 desc;

--looking at revenue trends by country for each year

SELECT 
    a.Country, 
    SUM(a.Quantity * a.UnitPrice) AS Total_2010, 
    (SELECT SUM(Quantity * UnitPrice)
     FROM [Online Retail] b
     WHERE b.Country = a.Country
       AND b.InvoiceDate LIKE '%2011%') AS Total_2011
FROM [Online Retail] AS a
WHERE a.InvoiceDate LIKE '%2010%'
GROUP BY a.Country
order by 2 desc;

--looking at revenue trends by item for each year

SELECT 
    a.Item_Description, 
    SUM(a.Quantity * a.UnitPrice) AS Total_2010, 
    (SELECT SUM(Quantity * UnitPrice)
     FROM [Online Retail] b
     WHERE b.Item_Description = a.Item_Description
       AND b.InvoiceDate LIKE '%2011%') AS Total_2011
FROM [Online Retail] AS a
WHERE a.InvoiceDate LIKE '%2010%'
GROUP BY a.Item_Description
order by 2 desc;

