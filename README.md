# SQL-Tableau-data-driven-business-case_Magist
SQL exploration of a fictitious e-commerce company in Brazil
# Case Study during the WBS-DataScience-Bootcamp: Expansion of Eniac to the Brazilian Market via Magist

## Project Overview

Eniac, an online marketplace specializing in Apple-compatible accessories, was founded in Spain and has successfully expanded to neighboring countries. Now, Eniac is exploring an entry into the Brazilian market—a region with eCommerce revenue comparable to Spain and Italy, and with significant growth potential. However, Eniac faces a major challenge: a limited understanding of the Brazilian market.

To address this, Eniac is considering a partnership with Magist, a prominent Brazilian Software as a Service (SaaS) company that provides a centralized order management system. Magist connects small and medium-sized stores to the largest Brazilian marketplaces, leveraging its economies of scale to offer competitive advantages.

Despite Magist's strong market presence, Eniac has two key concerns:

1. **Product Fit**: Eniac's product catalog is entirely focused on high-end tech, particularly Apple-compatible accessories. There is uncertainty about whether the marketplaces Magist serves are the right platform for such premium products.
  
2. **Delivery Speed**: Fast delivery is crucial to Eniac’s customer satisfaction strategy. While Magist’s partnership with the Brazilian Post Office may offer cost-effective delivery, there are concerns about whether delivery times will meet Eniac’s standards.

To address these concerns, this project involved data exploration using MySQL Workbench and data visualization with Tableau, providing insights to guide Eniac’s decision on entering the Brazilian market.

-----

## Tools Used

- **SQL (MySQL Workbench)**
  - Utilized to extract and analyze data, offering detailed insights into market trends, sales performance, and delivery logistics in the Brazilian market. SQL queries helped uncover critical data points that informed the decision-making process.

- **Tableau**
  - Used to create visualizations, including maps and bar charts, to effectively represent the data. Tableau's interactive dashboards provided a clear and visual interpretation of complex data, aiding in the communication of key insights.

- **Google Slides**
  - Employed to compile and present the findings in a structured and visually appealing format. The presentation integrates data insights and visualizations to support strategic recommendations for Eniac's expansion into Brazil.

-----

## Project Files

- **Presentation File**: `Magist recommendation.pdf`
  - This file contains the final presentation outlining the analysis, insights, and strategic recommendations for Eniac's potential entry into the Brazilian market.

- **Tableau File**: `Business-study-Magist-Tableau-plots.twbx`
  - This file includes the Tableau dashboards and visualizations, such as maps and bar charts, which were used to illustrate key findings related to sales distribution, customer demographics, and regional delivery performance.

- **MySQL Scripts**: `EniacMagist_07apr2025`
  - This file contains the SQL queries used to extract and analyze the data. These queries provided the necessary data insights that supported the visualizations and conclusions presented in the project.

-----

## How to Use the Files

1. **Review the Presentation**:
   - Open `Magist recommendation.pdf` to gain a comprehensive overview of the analysis, insights, and recommendations. This presentation serves as the primary document summarizing the project's findings.

2. **Explore the Data Visualizations**:
   - Open the `Business-study-Magist-Tableau-plots.twbx` file in Tableau to interact with the visualizations. This file allows you to explore the data in more detail, including regional sales distributions and delivery time analyses.

3. **Examine the SQL Queries**:
   - Review the `EniacMagist_07apr2025` files to understand the SQL queries used for data extraction and analysis. This file provides the foundation for the insights and visualizations created in the project.
-----

## Summary of Key Insights

- **Growth Potential**: Brazil’s eCommerce market is rapidly expanding, with revenue expected to more than double by 2024, making it a promising yet challenging market for Eniac’s entry.

- **Product-Market Fit**: Eniac’s high-end Apple-compatible accessories may not align perfectly with the typical product offerings on Magist’s connected marketplaces.

- **Revenue Gap**: Magist’s total revenue remains small compared to Eniac’s expectations, suggesting that Eniac may need to temper its financial projections if partnering with Magist.

- **Geographical Sales Disparities**: Magist’s sales are heavily concentrated in wealthier regions like São Paulo and Rio de Janeiro, while northern regions see significantly lower sales, posing a challenge for nationwide expansion.

- **Logistical Challenges**: Delivery times are acceptable in major cities but can extend up to 30 days in remote areas, potentially compromising Eniac's commitment to fast shipping.

- **Customer Feedback**: While Magist enjoys a solid reputation with an average customer rating of 4.1/5, occasional delivery and product issues highlight areas for improvement in customer experience.

- **Top Product Categories by Revenue** Computers and accessories: R$1,500,000; Electronics: R$1,250,000; Audio Equipment: R$1,000,000; Cellphones and accessories: R$900,000; Gaming: R$750,000
- **How many orders are there in the dataset?**
Result: ~99,000 orders.
Interpretation: This is a robust dataset, giving us reliable insight into Brazilian eCommerce. It shows Magist is working at scale.
🔎 Implication for Eniac: Scale is not a problem. Magist seems to handle large volumes — a good sign for operational capability.

- **Are orders actually delivered?**
Result:
delivered: ~97,000
Others (canceled, processing, etc.): minor
Interpretation: Almost all orders reach customers. The cancellation rate is very low.
✅ Implication for Eniac: Strong logistics fulfillment — promising for premium products, which must arrive reliably.

- **Is Magist seeing user growth?**
Result: Yes, steady monthly increase in customer count across the timeline (mostly 2017-2018).
📊 Interpretation: Magist is gaining traction — suggesting strong marketplace demand and adoption in Brazil.
🌎 Implication: Positive signal for Eniac entering the Brazilian market via Magist.
-- ** How many products exist, and how many are involved in transactions?
Product catalog: ~3,000 unique products
Products sold: ~3,000 — almost all were used in transactions.
📦 Interpretation: Magist is not just listing — it's actually moving product.
🔑 Implication: High product turnover suggests effective inventory and active customer engagement — suitable for Eniac.

- **Product & payment values**
Price range: from R$0.85 to R$6,500+
Highest payment for a single order: R$13,000+
Average product price: ~R$120
Installments: Common, mostly 2–6 months
🧠 Interpretation:
Brazilian consumers do buy expensive products.
Installments are culturally expected — important for high-tech items.
💡 Implication for Eniac: High-value tech products are viable — if payments allow flexibility. Magist must support installments.

- **Tech category performance**
Tech-related products sold: ~6–7% of all sales
Represent higher average prices
Expensive tech products do get sold frequently.
📈 Interpretation: There’s clear demand for tech, even if it's not the top category by volume.
🧩 Implication for Eniac: Magist handles tech well — not dominant, but a profitable niche. Potential to grow with a dedicated brand like Eniac.

- **Seller analysis (with focus on tech sellers)**
Tech sellers = ~10–15% of total
Tech sales = a disproportionate share of revenue
Monthly tech seller income is significant and stable.
💼 Interpretation: Tech sellers are fewer, but bring in higher revenue — high-margin vertical.
✅ Implication: Magist can be viable for high-end sales with the right marketing and positioning.

- **Delivery time & delay behavior**
Average delivery time: ~12 days
On-time deliveries: ~82%
Heavy products (e.g., >5kg) have more delays
High freight cost doesn’t always mean faster delivery
📦 Interpretation:
Delivery is generally on time, but larger/heavier items = slower.
Rural or distant customers may face delays even with high shipping fees.
⚠️ Implication: Eniac’s focus on fast delivery may face challenges for bulkier tech items. Need to test with light products first.

- **Customer satisfaction — Magist’s reviews**
Average scores over time: Stable, around 4.1 to 4.3
🙌 Interpretation: Customers are generally satisfied — no red flags in service.
👍 Implication: A reliable partner. A premium brand like Eniac could enhance the customer experience further.

- **Do customers return and reorder?**
~45% of customers place more than one order
Top customers have 10+ purchases
📊 Interpretation: There’s customer loyalty — indicating trust in the platform.
💡 Implication: Good sign for Eniac's brand loyalty model — upselling & recurring purchases are realistic.

- **Installments — customer behavior**
Most common: 2 to 6 installments
Up to 12 in rare cases
📌 Interpretation: Installments are the norm. High-cost items need installment options to sell well.
💳 Implication: Crucial for Eniac. Must ensure Magist or payment gateway supports multi-month plans.

- **Freight cost vs delay**
Expensive freight doesn’t guarantee faster delivery
Heavier items = more delays
📉 Interpretation: Magist’s logistics might not be ideal for bulky or urgent deliveries
⚠️ Implication: If speed is critical, Eniac should pilot smaller, lighter items first to test reliability.

- ** Market Position and User Growth**
Magist: Initially growing but shows sharp decline in customer count in recent months.
Competitors:
MercadoLibre: Continues rapid growth with marketplace + logistics integration.
Loggi: Expanding rapidly with AI routing, serves 4,000+ cities.
FOX Brasil: Specialized B2B logistics, steady growth in tech segment.
Conclusion: Magist is not showing strong user momentum compared to competitors.
-----

## Final conclusion

Our study concludes that Magist handles tech well — not dominant, but a profitable niche. 
Potential to grow with a dedicated brand like Eniac. Strong logistics fulfillment — promising for premium products, which must arrive reliably. 
Magist is gaining traction — suggesting strong marketplace demand and adoption in Brazil.
