# Install and load the package
install.packages("readxl")
library(readxl)
library(ggplot2)
library(dplyr)
library(patchwork)
library(scales)
library(tidyverse)
#=================================
#Import and Review the Dataset
#=================================
telco <- read.csv("C:/Users/mihre/Desktop/Rpractice/telco.csv")


# Preview the dataset
head(telco)

# Check dimensions
dim(telco)
 
# View column names
colnames(telco)

# Quick summary of data types and missing values
str(telco)
summary(telco)
#====================================
#Verify Data Quality
#====================================

# Count missing values per column
colSums(is.na(telco))

# Check for duplicate rows
sum(duplicated(telco))


#===================================Demography Graph==================
# Ensure Churn.Label is a factor
telco$Churn.Label <- as.factor(telco$Churn.Label)

# Function for categorical bar chart by churn
plot_cat_churn <- function(var){
  ggplot(telco, aes(x = .data[[var]], fill = Churn.Label)) +
    geom_bar(position = "fill") +  # show proportions
    scale_y_continuous(labels = percent_format()) +
    labs(title = var, x = NULL, y = "Churn Proportion", fill = "Churn Status") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Categorical plots
p1 <- plot_cat_churn("Gender")
p2 <- plot_cat_churn("Senior.Citizen")
p3 <- plot_cat_churn("Married")
p4 <- plot_cat_churn("Dependents")

# Histogram for Age by churn (overlay density)
p5 <- ggplot(telco, aes(x = Age, fill = Churn.Label)) +
  geom_histogram(alpha = 0.6, position = "identity", binwidth = 5, color = "white") +
  labs(title = "Age Distribution by Churn", x = "Age", y = "Count", fill = "Churn Status") +
  theme_minimal()

# Combine all plots
(p1 | p2) / (p3 | p4) / p5


#==================================
#Create Variables
#==================================
#1. Tenure Group
telco$TenureGroup <- cut(
  telco$Tenure.in.Months,
  breaks = c(0, 12, 24, 48, Inf),
  labels = c("0–12 months", "13–24 months", "25–48 months", "49+ months"),
  right = FALSE
)

table(telco$TenureGroup)

#2. Service Count
service_cols <- c("Phone.Service", "Online.Security", "Online.Backup",
                  "Device.Protection.Plan", "Streaming.TV", "Streaming.Movies",
                  "Streaming.Music", "Unlimited.Data")

telco$ServiceCount <- rowSums(telco[service_cols] == "Yes", na.rm = TRUE)
summary(telco$ServiceCount)

#===============

# Bar chart of Service Count
ggplot(telco, aes(x = as.factor(ServiceCount))) +  # convert to factor for discrete x-axis
  geom_bar(fill = "darkgreen") +
  labs(title = "Number of Customers by Service Count",
       x = "Number of Services Subscribed",
       y = "Number of Customers") +
  theme_minimal()



#Verify the New Variables
# Preview the relevant columns
head(telco[, c("Customer.ID", "Tenure.in.Months", "TenureGroup", "ServiceCount")])

# Optional: visualize distribution
ggplot(telco, aes(x = TenureGroup)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Customer Count by Tenure Group", x = "Tenure Group", y = "Count")


#Graph based on type of subscription
# Select only service columns
service_cols <- c("Phone.Service", "Online.Security", "Online.Backup",
                  "Device.Protection.Plan", "Premium.Tech.Support",
                  "Streaming.TV", "Streaming.Movies", "Streaming.Music",
                  "Unlimited.Data")

# Convert to long format for plotting
service_long <- telco %>%
  select(all_of(service_cols)) %>%
  pivot_longer(cols = everything(), names_to = "Service", values_to = "Subscribed") %>%
  filter(Subscribed == "Yes")   # only count subscriptions

# Count customers per service
service_count <- service_long %>%
  group_by(Service) %>%
  summarise(Count = n())

# Plot
ggplot(service_count, aes(x = reorder(Service, -Count), y = Count, fill = Service)) +
  geom_bar(stat = "identity") +
  labs(title = "Number of Customers by Service Type",
       x = "Service Type",
       y = "Number of Customers") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none")

#==================================================
#Bar charts: Churn proportions by contract, internet type, and payment method
#==================================================
# Ensure Churn.Label is a factor
telco$Churn.Label <- as.factor(telco$Churn.Label)

# Function to plot churn proportions for a categorical variable
plot_churn_bar <- function(var){
  ggplot(telco, aes(x = .data[[var]], fill = Churn.Label)) +
    geom_bar(position = "fill") +  # shows proportions
    scale_y_continuous(labels = scales::percent_format()) +
    labs(title = paste("Churn Proportion by", var),
         x = var,
         y = "Proportion",
         fill = "Churn Status") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Plot for Contract
plot_churn_bar("Contract")

# Plot for Internet.Type
plot_churn_bar("Internet.Type")

# Plot for Payment.Method
plot_churn_bar("Payment.Method")

#========================================
#Boxplots: Compare numeric variables by churn status
#==========================================
# Numeric variables to compare
num_vars <- c("Tenure.in.Months", "CLTV", "Satisfaction.Score")

# Function to plot boxplots
plot_churn_box <- function(var){
  ggplot(telco, aes(x = Churn.Label, y = .data[[var]], fill = Churn.Label)) +
    geom_boxplot() +
    labs(title = paste(var, "by Churn Status"),
         x = "Churn Status",
         y = var) +
    theme_minimal() +
    theme(legend.position = "none")
}

# Boxplot for Tenure
plot_churn_box("Tenure.in.Months")

# Boxplot for CLTV
plot_churn_box("CLTV")

# Boxplot for Satisfaction Score
plot_churn_box("Satisfaction.Score")

#=============
#Testing
#==========
# -----------------------------
# 1️ Chi-square tests for categorical predictors
# -----------------------------

# Contract Type vs Churn
contract_table <- table(telco$Contract, telco$Churn.Label)
chisq_contract <- chisq.test(contract_table)
print(chisq_contract)

# Payment Method vs Churn
payment_table <- table(telco$Payment.Method, telco$Churn.Label)
chisq_payment <- chisq.test(payment_table)
print(chisq_payment)

# -----------------------------
# 2 t-tests for numeric predictors
# -----------------------------

# Tenure vs Churn
t_test_tenure <- t.test(Tenure.in.Months ~ Churn.Label, data = telco)
print(t_test_tenure)

# Satisfaction Score vs Churn
t_test_satisfaction <- t.test(Satisfaction.Score ~ Churn.Label, data = telco)
print(t_test_satisfaction)

# Optional: CLTV vs Churn
t_test_cltv <- t.test(CLTV ~ Churn.Label, data = telco)
print(t_test_cltv)

# -----------------------------
# 3 Optional: ANOVA (if comparing numeric by >2 groups)
# Example: Tenure by Contract Type
anova_tenure <- aov(Tenure.in.Months ~ Contract, data = telco)
summary(anova_tenure)


# -------------------------
# Chi-square tests
# -------------------------
chi_senior <- chisq.test(table(telco$Senior.Citizen, telco$Churn.Label))
chi_depend <- chisq.test(table(telco$Dependents, telco$Churn.Label))
chi_married <- chisq.test(table(telco$Married, telco$Churn.Label))
chi_gender <- chisq.test(table(telco$Gender, telco$Churn.Label))

# -------------------------
# Summary table
# -------------------------
chi_summary <- data.frame(
  Variable = c("Senior Citizen", "Dependents", "Married", "Gender"),
  X_Squared = c(chi_senior$statistic,
                chi_depend$statistic,
                chi_married$statistic,
                chi_gender$statistic),
  P_Value = c(chi_senior$p.value,
              chi_depend$p.value,
              chi_married$p.value,
              chi_gender$p.value)
)

# Format P_Value nicely for annotation
chi_summary$P_Label <- ifelse(chi_summary$P_Value < 0.001, "<0.001", signif(chi_summary$P_Value, 3))

# Color for bars: red/orange
chi_summary$Color <- "#F8766D"

# -------------------------
# Poster-ready plot
# -------------------------
ggplot(chi_summary, aes(x = reorder(Variable, X_Squared), y = X_Squared, fill = Color)) +
  geom_col() +
  geom_text(aes(label = paste0("X²=", round(X_Squared,1), "\nP=", P_Label)),
            hjust = -0.1, size = 6, color = "black", fontface = "bold") +  # large, bold, visible
  scale_fill_identity() +
  labs(title = "Chi-Square Statistics for Demographic Predictors",
       x = "Variable",
       y = "Chi-Square (X²)") +
  theme_minimal(base_size = 16) +  # larger base font
  theme(
    axis.title = element_text(face = "bold", size = 18),
    axis.text = element_text(face = "bold", size = 14),
    plot.title = element_text(face = "bold", size = 20)
  ) +
  coord_flip() +
  ylim(0, max(chi_summary$X_Squared) * 1.2)



# t-test for CLTV
t_test_cltv <- t.test(CLTV ~ Churn.Label, data = telco)

# Define churn colors
churn_colors <- c("No" = "#619CFF", "Yes" = "#F8766D")

# Compute mean CLTV for each group
cltv_means <- telco %>%
  group_by(Churn.Label) %>%
  summarise(mean_CLTV = mean(CLTV), .groups = "drop")

# Poster-ready CLTV boxplot with mean and t-test annotation
ggplot(telco, aes(x = Churn.Label, y = CLTV, fill = Churn.Label)) +
  geom_boxplot(alpha = 0.7, outlier.shape = 21, outlier.fill = "black") +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 4, color = "black", fill = "yellow") +
  geom_text(data = cltv_means, aes(x = Churn.Label, y = mean_CLTV + 200, 
                                   label = round(mean_CLTV, 0)),
            color = "black", fontface = "bold", size = 5) +
  # Add t-test statistic and p-value on top
  annotate("text", x = 1.5, y = max(telco$CLTV)*1.05, 
           label = paste0("t = ", round(t_test_cltv$statistic, 2),
                          ", p ", ifelse(t_test_cltv$p.value < 0.001, "<0.001", round(t_test_cltv$p.value, 3))),
           size = 6, fontface = "bold", color = "black") +
  scale_fill_manual(values = churn_colors) +
  labs(title = "Customer Lifetime Value (CLTV) by Churn Status",
       x = "Churn Status",
       y = "CLTV ($)") +
  theme_minimal(base_size = 16) +
  theme(
    axis.title = element_text(face = "bold", size = 18),
    axis.text = element_text(face = "bold", size = 14),
    plot.title = element_text(face = "bold", size = 20, hjust = 0.5),
    legend.position = "none"
  )

# -------------------------
# 2. Service Count by Churn (stacked bar)
# -------------------------
# Ensure Churn.Label is factor
telco$Churn.Label <- as.factor(telco$Churn.Label)

# Define churn colors
churn_colors <- c("No" = "#619CFF", "Yes" = "#F8766D")

# Optional: t-test for ServiceCount (numeric)
t_test_service <- t.test(ServiceCount ~ Churn.Label, data = telco)

# Plot: Churn proportion by ServiceCount
ggplot(telco, aes(x = as.factor(ServiceCount), fill = Churn.Label)) +
  geom_bar(position = "fill") +   # show proportion
  scale_y_continuous(labels = scales::percent_format()) +
  scale_fill_manual(values = churn_colors) +
  labs(title = "Churn Proportion by Number of Services Subscribed",
       x = "Number of Services Subscribed",
       y = "Proportion",
       fill = "Churn Status") +
  # Add t-test annotation on top
  annotate("text", x = max(telco$ServiceCount)/2, y = 1.05, 
           label = paste0("t = ", round(t_test_service$statistic, 2),
                          ", p ", ifelse(t_test_service$p.value < 0.001, "<0.001", round(t_test_service$p.value, 3))),
           size = 5, fontface = "bold", color = "black") +
  theme_minimal(base_size = 16) +
  theme(
    axis.title = element_text(face = "bold", size = 16),
    axis.text = element_text(face = "bold", size = 14),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    legend.title = element_text(face = "bold", size = 14),
    legend.text = element_text(size = 12)
  )


