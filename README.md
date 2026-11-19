# OECD Higher Education & Economic Growth — K-Means Clustering

An empirical statistical and clustering analysis examining the relationship between higher education indicators and economic growth across five selected OECD countries: **United Kingdom, Switzerland, Norway, Sweden, and Ireland**.

## Dataset
- **Source:** World Data Bank
- **Variables:**
  - `Income`: Adjusted Net National Income (annual % growth)
  - `Expenditure`: Government Expenditure on Tertiary Education
  - `Enrollment`: Gross Enrollment Ratio in Tertiary Education (%)
  - `LaborForce`: Labor Force with Advanced Education

## Technologies & Libraries
- **Language:** R
- **Libraries:** `tidyverse`, `caret`, `ggcorrplot`, `car`, `cluster`, `factoextra`

## Methodology
1. **Data Preprocessing:** Handled missing values using mean imputation and treated outliers via the IQR method.
2. **Exploratory & Normality Analysis:** Evaluated variable distributions using Histograms, Q-Q Plots, Boxplots, and Shapiro-Wilk tests.
3. **Standardization & Diagnostics:** Applied Z-Score standardization, computed the correlation matrix, and checked multicollinearity using Variance Inflation Factor (VIF).
4. **K-Means Clustering:** Determined the optimal number of clusters (K = 2) via the **Elbow Method (WSS)**, visualized clusters using **PCA** (explaining 66.2% of total variance), and validated cluster quality using **Silhouette Analysis**.

## Key Findings
- **Correlation:** Moderate positive correlation between `Expenditure` and `LaborForce` (r = 0.41) and `Expenditure` and `Enrollment` (r = 0.35); very weak correlation between `Income` and `LaborForce` (r = 0.07).
- **Cluster Results (K = 2):**
  - **Cluster 1 (United Kingdom, Switzerland, Ireland):** Higher economic profile (income & expenditure) with a more heterogeneous social/educational structure.
  - **Cluster 2 (Norway, Sweden):** More homogeneous socio-educational structure reflecting the Nordic welfare model.
- **Validation:** Average Silhouette width of **0.30** (Cluster 1: 0.29, Cluster 2: 0.32), indicating overlapping/borderline socio-economic dynamics across developed OECD nations.

## How to Run
1. Clone the repository:
   ```bash
   git clone https://github.com/selingoktaass20/oecd_education_growth_clustering.git
   ```
2. Install the required R packages:
   ```r
   install.packages(c("tidyverse", "caret", "ggcorrplot", "car", "cluster", "factoextra"))
   ```
3. Place the dataset (`oecd_education_data.csv`) in the working directory and run `kmeans_analysis.R` in RStudio.
