# ==============================================================================
# OECD Higher Education & Economic Growth - K-Means Clustering Analysis
# Countries: United Kingdom, Switzerland, Norway, Sweden, Ireland
# ==============================================================================

# 1. Load Required Libraries
# Uncomment the line below if you need to install packages first:
# install.packages(c("tidyverse", "caret", "ggcorrplot", "car", "cluster", "factoextra"))

library(tidyverse)
library(caret)
library(ggcorrplot)
library(car)
library(cluster)
library(factoextra)

# 2. Load Dataset
# Replace with your actual dataset file name (e.g., CSV or Excel)
data <- read.csv("oecd_education_data.csv")

# 3. Missing Value Imputation (Mean Imputation)
data$Income[is.na(data$Income)] <- mean(data$Income, na.rm = TRUE)
data$Expenditure[is.na(data$Expenditure)] <- mean(data$Expenditure, na.rm = TRUE)
data$Enrollment[is.na(data$Enrollment)] <- mean(data$Enrollment, na.rm = TRUE)
data$LaborForce[is.na(data$LaborForce)] <- mean(data$LaborForce, na.rm = TRUE)

print(data)
summary(data)

# 4. Normality Checks & Exploratory Data Analysis
# Histograms
hist(data$Income, main = "Gelir Histogram", col = "lightblue")
hist(data$Expenditure, main = "Gider Histogram", col = "red")
hist(data$Enrollment, main = "Kayıt Histogram", col = "blue")
hist(data$LaborForce, main = "İşgücü Histogram", col = "green")

# Q-Q Plots
qqnorm(data$Income)
qqline(data$Income, col = "red")

qqnorm(data$Expenditure)
qqline(data$Expenditure, col = "red")

qqnorm(data$Enrollment)
qqline(data$Enrollment, col = "red")

qqnorm(data$LaborForce)
qqline(data$LaborForce, col = "red")

# Shapiro-Wilk Normality Tests
shapiro.test(data$Income)
shapiro.test(data$Expenditure)
shapiro.test(data$Enrollment)
shapiro.test(data$LaborForce)

# Boxplots
boxplot(data$Income, main = "Income Boxplot", col = "gray", outline = FALSE)
boxplot(data$Expenditure, main = "Expenditure Boxplot", col = "gray", outline = FALSE)
boxplot(data$Enrollment, main = "Enrollment Boxplot", col = "gray", outline = FALSE)
boxplot(data$LaborForce, main = "LaborForce Boxplot", col = "gray", outline = FALSE)

# 5. Outlier Detection & Handling (IQR Method)
# IQR - Income
Q1 <- quantile(data$Income, 0.25)
Q3 <- quantile(data$Income, 0.75)
IQR <- Q3 - Q1

alt_sinir <- Q1 - 1.5 * IQR
ust_sinir <- Q3 + 1.5 * IQR

aykiri_degerler_iqr <- data[data$Income < alt_sinir | data$Income > ust_sinir, ]
ortalama_iqr <- mean(data$Income[data$Income >= alt_sinir & data$Income <= ust_sinir], na.rm = TRUE)

data$Income[data$Income < alt_sinir | data$Income > ust_sinir] <- ortalama_iqr
sum(data$Income < alt_sinir | data$Income > ust_sinir)

# IQR - Expenditure
Q1 <- quantile(data$Expenditure, 0.25)
Q3 <- quantile(data$Expenditure, 0.75)
IQR <- Q3 - Q1

alt_sinir <- Q1 - 1.5 * IQR
ust_sinir <- Q3 + 1.5 * IQR
print(alt_sinir)
print(ust_sinir)

aykiri_degerler_iqr <- data[data$Expenditure < alt_sinir | data$Expenditure > ust_sinir, ]
print(aykiri_degerler_iqr)

ortalama_iqr <- mean(data$Expenditure[data$Expenditure >= alt_sinir & data$Expenditure <= ust_sinir], na.rm = TRUE)

data$Expenditure[data$Expenditure < alt_sinir | data$Expenditure > ust_sinir] <- ortalama_iqr
sum(data$Expenditure < alt_sinir | data$Expenditure > ust_sinir)

# IQR - Enrollment
Q1 <- quantile(data$Enrollment, 0.25)
Q3 <- quantile(data$Enrollment, 0.75)
IQR <- Q3 - Q1

alt_sinir <- Q1 - 1.5 * IQR
ust_sinir <- Q3 + 1.5 * IQR
print(alt_sinir)
print(ust_sinir)

aykiri_degerler_iqr <- data[data$Enrollment < alt_sinir | data$Enrollment > ust_sinir, ]
print(aykiri_degerler_iqr)

# IQR - LaborForce
Q1 <- quantile(data$LaborForce, 0.25)
Q3 <- quantile(data$LaborForce, 0.75)
IQR <- Q3 - Q1

alt_sinir <- Q1 - 1.5 * IQR
ust_sinir <- Q3 + 1.5 * IQR
print(alt_sinir)
print(ust_sinir)

aykiri_degerler_iqr <- data[data$LaborForce < alt_sinir | data$LaborForce > ust_sinir, ]
print(aykiri_degerler_iqr)

ortalama_iqr <- mean(data$LaborForce[data$LaborForce >= alt_sinir & data$LaborForce <= ust_sinir], na.rm = TRUE)

data$LaborForce[data$LaborForce < alt_sinir | data$LaborForce > ust_sinir] <- ortalama_iqr
sum(data$LaborForce < alt_sinir | data$LaborForce > ust_sinir)

# 6. Z-Score Standardization
z_score_standardizasyon <- function(x) {
  mu <- mean(x)
  sigma <- sd(x)
  return((x - mu) / sigma)
}

sayisal_sutunlar <- c("Income", "Expenditure", "Enrollment", "LaborForce")
data_standardize <- data
data_standardize[sayisal_sutunlar] <- lapply(data[sayisal_sutunlar], z_score_standardizasyon)

print("Orijinal Veri (İlk 5 Satır):")
print(head(data))

print("Standardizasyon Sonrası Veri (İlk 5 Satır):")
print(head(data_standardize))

# 7. Correlation Matrix
sayisal_data <- data_standardize[, c("Income", "Expenditure", "Enrollment", "LaborForce")]
kor_matris <- cor(sayisal_data)
print(kor_matris)

ggcorrplot(kor_matris, method = "circle", lab = TRUE)

# 8. Multicollinearity Check (VIF)
model <- lm(LaborForce ~ Income + Expenditure + Enrollment, data = data_standardize)
vif_values <- vif(model)

print("VIF Değerleri:")
print(vif_values)

high_vif <- vif_values[vif_values > 5]
print("Yüksek VIF Değerleri:")
print(high_vif)

# 9. K-Means Clustering & Elbow Method
set.seed(123)
kmeans_result <- kmeans(data_standardize[, 3:6], centers = 2, nstart = 25)
print(kmeans_result)

wss <- numeric(10)
for (k in 1:10) {
  kmeans_temp <- kmeans(data_standardize[, 3:6], centers = k, nstart = 25)
  wss[k] <- kmeans_temp$tot.withinss
}

plot(1:10, wss, type = "b", pch = 19, col = "red",
     xlab = "K Değeri", ylab = "WSS (Within Sum of Squares)",
     main = "Elbow Yöntemi")

# Visualize Clusters
fviz_cluster(kmeans_result, data = data_standardize[, 3:6],
             geom = "point", ellipse.type = "euclid",
             main = "K-means Kümeleme Sonuçları")

# 10. Silhouette Analysis
sil_score <- silhouette(kmeans_result$cluster, dist(data_standardize[, 3:6]))
plot(sil_score, col = 1:3)

data_standardize$cluster <- kmeans_result$cluster
head(data_standardize)
table(data_standardize$cluster)
