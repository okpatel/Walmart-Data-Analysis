# Walmart-Sales-Data-Analysis-SQL

## About
This project aims to explore the Walmart Sales data to understand top performing branches and products, sales trends of different products, and customer behavior. The goal is to study how sales strategies can be improved and optimized. The dataset was obtained from the Kaggle Walmart Sales Forecasting Competition.

"In this recruiting competition, job-seekers are provided with historical sales data for 45 Walmart stores located in different regions. Each store contains many departments, and participants must project the sales for each department in each store. To add to the challenge, selected holiday markdown events are included in the dataset. These markdowns are known to affect sales, but it is challenging to predict which departments are affected and the extent of the impact." – [Kaggle](https://www.kaggle.com/c/walmart-sales-forecasting)

## Purpose of the Project
The major aim of this project is to gain insight into the sales data of Walmart and understand the different factors that affect the sales of the various branches.

## About the Data
The dataset was obtained from the Kaggle Walmart Sales Forecasting Competition. This dataset contains sales transactions from three different branches of Walmart, respectively located in Mandalay, Yangon, and Naypyitaw. The data contains 17 columns and 1000 rows:

| Column | Description | Data Type |
|--------|-------------|-----------|
| invoice_id | Invoice of the sales made | VARCHAR(30) |
| branch | Branch at which sales were made | VARCHAR(5) |
| city | The location of the branch | VARCHAR(30) |
| customer_type | The type of customer | VARCHAR(30) |
| gender | Gender of the customer making the purchase | VARCHAR(10) |
| product_line | Product line of the product sold | VARCHAR(100) |
| unit_price | The price of each product | DECIMAL(10, 2) |
| quantity | The amount of the product sold | INT |
| VAT | The amount of tax on the purchase | FLOAT(6, 4) |
| total | The total cost of the purchase | DECIMAL(10, 2) |
| sale_date | The date on which the purchase was made | DATE |
| sale_time | The time at which the purchase was made | TIMESTAMP |
| payment_method | The payment method used | VARCHAR(15) |
| COGS | Cost of Goods Sold | DECIMAL(10, 2) |
| gross_margin_pct | Gross margin percentage | FLOAT(11, 9) |
| gross_income | Gross income | DECIMAL(10, 2) |
| rating | Rating given to the purchase | FLOAT(2, 1) |

## Analysis List

### Product Analysis
- Conduct analysis on the data to understand the different product lines, the product lines performing best, and the product lines that need to be improved.

### Sales Analysis
- This analysis aims to answer the question of the sales trends of products. The result of this can help us measure the effectiveness of each sales strategy and what modifications are needed to gain more sales.

### Customer Analysis
- This analysis aims to uncover the different customer segments, purchase trends, and the profitability of each customer segment.

## Approach Used

### Data Wrangling:
1. **Initial Inspection**: Inspection of data to detect NULL and missing values. Data replacement methods are used to replace missing or NULL values.
2. **Build a Database**: Create table and insert the data.
3. **NULL Value Handling**: We ensure that there are no NULL values in our database by setting `NOT NULL` for each field, which automatically filters out NULL values.

### Feature Engineering:
1. **New Columns**: 
   - `time_of_day`: Added to give insight into sales in the Morning, Afternoon, and Evening.
   - `day_name`: Extracted days of the week on which transactions took place (Mon, Tue, Wed, Thu, Fri).
   - `month_name`: Extracted months of the year on which the transactions took place (Jan, Feb, Mar).

### Exploratory Data Analysis (EDA):
- This analysis aims to answer the listed questions and objectives of this project.

## Business Questions Answered:

### Generic Questions:
- How many unique cities does the data have?
- In which city is each branch?

### Product Questions:
- How many unique product lines does the data have?
- What is the most common payment method?
- What is the most selling product line?
- What is the total revenue by month?
- What month had the largest COGS?
- What product line had the largest revenue?
- What is the city with the largest revenue?
- What product line had the largest VAT?
- Fetch each product line and add a column to those product lines showing "Good", "Bad". "Good" if it’s greater than average sales.
- Which branch sold more products than the average product sold?
- What is the most common product line by gender?
- What is the average rating of each product line?

### Sales Questions:
- Number of sales made in each time of the day per weekday.
- Which of the customer types brings the most revenue?
- Which city has the largest VAT (Value Added Tax)?
- Which customer type pays the most in VAT?

### Customer Questions:
- How many unique customer types does the data have?
- How many unique payment methods does the data have?
- What is the most common customer type?
- Which customer type buys the most?
- What is the gender of most of the customers?
- What is the gender distribution per branch?
- Which time of the day do customers give the most ratings?
- Which time of the day do customers give the most ratings per branch?
- Which day of the week has the best average ratings?
- Which day of the week has the best average ratings per branch?

## Revenue and Profit Calculations:
- **COGS**: `unit_price * quantity`
- **VAT**: `5% * COGS`
- **Total Sales (gross_sales)**: `VAT + COGS`
- **Gross Profit (gross_income)**: `total_sales - COGS`
- **Gross Margin**: `gross_profit / total_revenue`

**Example Calculation:**
- `unit_price = 45.79`
- `quantity = 7`
- `COGS = 45.79 * 7 = 320.53`
- `VAT = 5% * COGS = 5% * 320.53 = 16.03`
- `total = VAT + COGS = 16.03 + 320.53 = 336.56`
- `gross_margin_pct = gross_income / total_sales = 16.03 / 336.56 = 4.76%`

## Conclusion:
- The analysis provided insights into the sales data, identifying key factors such as top-performing branches, customer segments, and product lines.
- The project utilized SQL to extract meaningful information that can help Walmart improve its sales strategies and optimize performance across various branches.
