------ Business Problems & Solutions

1. How many records are in each table?
2. How many unique customers are there in total?
3. What is the overall churn rate?
4. What are the distinct values and their counts for categorical columns in Customer_Demo?
5. What are the distinct values and their counts for ServiceUsage in Online_Activity?
6. What are the distinct values and their counts for InteractionType and ResolutionStatus in Customer_Service?
7. What are the distinct ProductCategory values and their counts in Trans_History?
8. What is the date range for LastLoginDate, InteractionDate, and TransactionDate?
9. What is the churn rate by Gender?
10. What is the churn rate by MaritalStatus?
11. What is the churn rate by IncomeLevel?
12. What is the churn rate by Age group? 
13. What is the average LoginFrequency for churned vs. non-churned customers?
14. What is the churn rate by ServiceUsage?
15. How does LastLoginDate recency (days since last login, relative to a reference date like '2023-12-31') differ for churned vs. non-churned customers?
16. What is the average total AmountSpent and average number of transactions for churned vs. non-churned customers (from Trans_History, which is 2022 data)?
17: What is the churn rate for customers based on their most frequently purchased ProductCategory in 2022?
18: How does the average time since the last transaction (recency from Trans_History data, relative to '2022-12-31') differ for churned vs. non-churned customers?
19: What is the average number of customer service interactions for churned vs. non-churned customers (from Customer_Service data, which is 2022)?
20: What is the churn rate by InteractionType (considering customers who had at least one interaction)?
21: What is the churn rate based on whether customers had any Unresolved service interactions?
22: For customers who had complaints, what is the churn rate based on whether their latest complaint was resolved or unresolved?
23: Identify high-value customers (e.g., top 25% by total AmountSpent in 2022) and their churn rate.
24: What is the profile (Age group, Gender, IncomeLevel) of customers who churned despite high login frequency (e.g., LoginFrequency > 30) in 2023?
25: Among customers who had unresolved complaints in 2022, what was their average AmountSpent in 2022, and what was their subsequent LoginFrequency in 2023 and churn status?
26: What is the average transaction value per customer for churned vs. non-churned customers in 2022?
27: For each ProductCategory, what is the total revenue generated, the number of unique customers purchasing from it, and the average amount spent per transaction in that category (2022 data)?
28: What is the churn rate for customers whose average transaction value in 2022 was in the bottom 25%, middle 50%, and top 25%?
29: Identify customers who made purchases in multiple (e.g., 3 or more) distinct product categories in 2022. What is their churn rate?
30: What is the average number of days between customer service interactions for customers who had multiple interactions in 2022? How does this differ for churned vs. non-churned customers?
31: For customers who had complaints in 2022, what percentage of their complaints were resolved? How does this relate to churn?
32: Identify customers who had interactions of different types (e.g., an Inquiry followed by a Complaint). What is their churn rate?
33: How many customers made their last transaction in 2022 in Q1, Q2, Q3, or Q4? What is the churn rate for each of these groups?
34: Compare the average LoginFrequency in 2023 35: What is the average number of days between a customer's last transaction in 2022 and their last login in 2023, for churned vs. non-churned customers?
36: Create a customer segment based on 2022 spending (High/Medium/Low) and 2023 Login Frequency (High/Medium/Low). What's the churn rate for each segment?
37: Who are the customers (list CustomerIDs) who churned, had a high login frequency (>30 in 2023), but also had an unresolved complaint in 2022? What are their demographics?
38: What is the most common ServiceUsage (2023) for customers who spent the most on Electronics in 2022 and eventually churned?