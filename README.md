# Customer Churn Analysis: Statistical Testing & EDA

This project explores customer attrition within a fictional California-based telecom provider. Using **R**, I performed Exploratory Data Analysis (EDA) and inferential statistical testing to identify why customers leave and which segments require the most urgent retention efforts.

## 📊 Dataset Overview
The analysis is based on a dataset of **7,043 customers** with variables covering:
* **Demographics:** Age, Senior Citizen status, Marital status, and Dependents.
* **Services:** Internet type, Phone service, Streaming, Security, Contract type, and Payment methods.
* **Performance Metrics:** Satisfaction Score, Churn Score, and Customer Lifetime Value (CLTV).

## 🚀 Key Insights & Statistical Results

### 1. The "High-Risk" Profile ($p < 0.001$)
Statistical testing confirmed that specific behaviors and demographics are highly predictive of churn:
* **Contract & Payment:** Customers on **Month-to-month contracts** and those using **electronic check payments** exhibit the highest churn rates ($p < 0.001$).
* **Demographics:** Churn is significantly higher among **senior citizens**, **unmarried customers**, and those **without dependents** (Chi-square $p < 0.001$).
* **Health Metrics:** Churned customers consistently show **shorter tenure** and **lower satisfaction scores** ($p < 0.001$), with a slightly lower average CLTV.

### 2. Service "Stickiness"
* **Service Count:** Analysis of the [Service Count](https://github.com/MihretTe/Customer-churn-analysis/blob/main/Churn%20Prop%20by%20%23%20of%20services%20subscribed.png) shows that customers with fewer integrated services are more likely to churn.
* **Contract Impact:** Month-to-month users represent the largest churn segment, suggesting that long-term contracts are a major driver of retention.

---

## 🛠️ Methodology & Data Preparation
The analysis followed a rigorous data science workflow using [Method.R](https://github.com/MihretTe/Customer-churn-analysis/blob/main/Method.R):

1.  **Data Preparation:** Imported Excel data, handled missing values, and performed feature engineering to create **Tenure Groups** (0–12, 13–24, 25+ months) and a **Service Count** variable.
2.  **Exploratory Analysis:** Used `ggplot2` to generate bar charts (categorical churn), boxplots (numeric distributions), and scatterplots (CLTV vs. Churn Score).
3.  **Statistical Testing:** * **Chi-square tests** for categorical predictors.
    * **t-tests / ANOVA** for numeric differences (Tenure, CLTV, Satisfaction).

---

## 📂 Repository Structure

| File/Folder | Description |
| :--- | :--- |
| **[Method.R](https://github.com/MihretTe/Customer-churn-analysis/blob/main/Method.R)** | The core R script containing data cleaning, EDA, and statistical tests. |
| **[Final Project With Rcode.zip](https://github.com/MihretTe/Customer-churn-analysis/blob/main/Final%20Project%20With%20Rcode.zip)** | Contains the original dataset and bundled analysis environment. |
| **[Tesfaye's.Presentation.pptx](https://github.com/MihretTe/Customer-churn-analysis/blob/main/Tesfaye's.Presentation.pptx)** | Business-oriented summary of findings, risks, and recommendations. |
| **Visualizations (.png)** | Key plots generated during EDA, including CLTV, Satisfaction scores, and Chi-square results. |

---

## 💡 Conclusion & Recommendations
* **Prioritize Onboarding:** Focus retention strategies on the first 12 months of tenure, as this is the highest-risk period.
* **Contract Incentives:** Transition month-to-month customers to annual plans through targeted promotional offers.
* **Proactive Outreach:** Flag customers with low satisfaction scores for immediate intervention by customer success teams.

## ⚠️ Limitations & Future Work
* **Limitations:** The dataset is limited to one region and lacks interaction data (complaints, customer service logs).
* **Future Work:** I plan to implement machine learning models, specifically **Logistic Regression** and **Random Forest**, to predict individual churn probability.

---

## 🏃 How to Run
1.  Clone this repository.
2.  Install required R packages: `install.packages(c("ggplot2", "dplyr", "tidyr", "stats"))`.
3.  Run [Method.R](https://github.com/MihretTe/Customer-churn-analysis/blob/main/Method.R) to generate the statistical outputs and visualizations.
