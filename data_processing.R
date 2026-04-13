# =============================================================================
# Data Processing Script
# Study: Carbon Tax Effects on Subjective Wellbeing
# Design: Longitudinal cross-country panel regression
# Data sources: OECD (country-level) & European Social Survey (individual-level)
# Countries: Belgium, Estonia, Finland, France, Germany, Hungary, Ireland,
#            Netherlands, Norway, Poland, Portugal, Slovenia, Spain, Sweden,
#            Switzerland, United Kingdom (n = 16)
# ESS Rounds: 4–11 (approx. 2008–2023)
# =============================================================================


# =============================================================================
# 1. DEPENDENT VARIABLE
# =============================================================================

# stflife  [ESS]
#   Life satisfaction (subjective wellbeing)
#   Scale: 0 (extremely dissatisfied) – 10 (extremely satisfied)
#   Source: European Social Survey, variable "stflife"
#   https://ess-search.nsd.no/


# =============================================================================
# 2. KEY INDEPENDENT VARIABLE
# =============================================================================

# ECR  [OECD]
#   Effective Carbon Rate (EUR per tonne CO2)
#   Captures the total price signal on carbon emissions from energy use,
#   combining carbon taxes, fuel excise taxes, and emissions trading prices.
#   Source: OECD Effective Carbon Rates database
#   https://www.oecd.org/tax/tax-policy/effective-carbon-rates.htm
#   Note: Annual values; use the rate for the same year as the ESS survey round.


# =============================================================================
# 3. COUNTRY-LEVEL (MACRO) CONTROL VARIABLES  [OECD]
# =============================================================================
# These time-varying country controls are merged onto the individual-level ESS
# data by country and survey year before estimating the panel model.
# Source for all four: OECD Data Portal (https://data.oecd.org/)

# --- 3.1 GDP per Capita (log-transformed) ---
# Variable name (after merge): log_gdp_pc
#   Gross Domestic Product divided by total population, expressed in constant
#   USD (PPP-adjusted) to allow cross-country comparison.
#   Log transformation is applied to reduce right-skew and allows the
#   coefficient to be interpreted as an elasticity.
#   OECD query: "GDP per capita" / "GDP per head"
#   OECD indicator: SNA_TABLE1 / "GDP per head of population"
#   URL: https://data.oecd.org/gdp/gross-domestic-product-gdp.htm
#   Coding: log_gdp_pc = log(gdp_per_capita_usd_constant)

# --- 3.2 Inflation Rate (CPI, annual %) ---
# Variable name (after merge): inflation_cpi
#   Annual percentage change in the Consumer Price Index.
#   Controls for macroeconomic instability and real purchasing-power changes
#   that may affect wellbeing independently of the carbon tax.
#   OECD query: "inflation rate" / "CPI" / "consumer price index"
#   OECD indicator: "Inflation (CPI)"
#   URL: https://data.oecd.org/price/inflation-cpi.htm
#   Coding: annual % change; positive values = price increases

# --- 3.3 National Unemployment Rate ---
# Variable name (after merge): unemp_rate
#   Harmonised unemployment rate as a percentage of the total labour force.
#   Captures aggregate labour-market conditions that independently influence
#   individual wellbeing and may be correlated with carbon-tax implementation.
#   OECD query: "unemployment rate" / "harmonised unemployment"
#   OECD indicator: "Unemployment rate" (harmonised)
#   URL: https://data.oecd.org/unemp/unemployment-rate.htm
#   Coding: % of labour force; annual average

# --- 3.4 Environmental Quality: PM2.5 Population-Weighted Exposure ---
# Variable name (after merge): pm25_exposure
#   Mean annual population-weighted exposure to fine particulate matter
#   (PM2.5, μg/m³). Included because carbon/fuel taxes may affect air
#   quality, and ambient air pollution independently affects health and
#   wellbeing. For years 2022–2023 where OECD data are unavailable, use
#   World Bank / IHME estimates.
#   OECD query: "PM2.5" / "air pollution exposure" / "particulate matter"
#   OECD indicator: "Exposure to PM2.5"
#   URL: https://data.oecd.org/env/air-pollution-exposure.htm
#   World Bank fallback: https://data.worldbank.org/indicator/EN.ATM.PM25.MC.M3
#   Coding: μg/m³; higher = worse air quality


# =============================================================================
# 4. INDIVIDUAL-LEVEL (ESS) VARIABLES
# =============================================================================
# Download via ESS Data Portal: https://ess-search.nsd.no/
# Select Rounds 4–11, all 16 countries, and the variables below.

# --- 4.0 Household Income (interaction variable) ---
# ESS variable: hinctnt
#   Household's total net income from all sources, placed into deciles based
#   on the income distribution within each country and ESS round.
#   This variable serves as the key interaction term with the carbon tax (ECR)
#   to test whether the wellbeing effect of carbon pricing differs by income
#   group — i.e., whether carbon taxes are regressive or progressive in their
#   impact on subjective wellbeing.
#   Source: ESS, Demographics & Background → Household Income
#   Coding:
#     1  = 1st decile (lowest income)
#     2  = 2nd decile
#     ...
#     10 = 10th decile (highest income)
#     77 = Refusal  → recode to NA
#     88 = Don't know → recode to NA
#   Treatment: include as continuous (1–10) or as factor; interact with ECR.
#   Theoretical rationale: documented in detail in the literature review.

# --- 4.1 Age ---
# ESS variable: agea
#   Respondent's age in completed years at time of interview.
#   Age is a robust predictor of subjective wellbeing (U-shaped relationship)
#   and correlates with energy consumption patterns and carbon-tax exposure.
#   Source: ESS, Demographics & Background → Age
#   Coding: continuous (years); valid range approx. 14–100
#   Treatment: include as continuous; consider agea^2 for the U-shape

# --- 4.2 Gender ---
# ESS variable: gndr
#   Respondent's gender.
#   Gender is a standard demographic control in wellbeing research.
#   Source: ESS, Demographics & Background → Gender
#   Coding: 1 = Male, 2 = Female
#   Treatment: recode to binary dummy (female = 1 if gndr == 2, else 0)

# --- 4.3 Years of Education ---
# ESS variable: eduyrs
#   Number of years of full-time education completed.
#   Education affects income, climate awareness, and sensitivity to
#   environmental policies, and is a standard control in welfare economics
#   (Alesina et al., 2004; Welsch, 2006).
#   Source: ESS, Education → Years of full-time education completed
#   Coding: continuous (years); valid range 0–50
#   Note: Provide theoretical justification in Section 3.2.2 if retained.

# --- 4.4 Household Size ---
# ESS variable: hhmmb
#   Number of people living regularly in the household.
#   Larger households consume more total energy (heating, transport), so they
#   face higher absolute carbon-tax costs, potentially dampening wellbeing.
#   Source: ESS, Demographics & Background → Household Composition
#   Coding: continuous (count of household members); valid range 1–(varies)

# --- 4.5 Living Area (Urban/Rural) ---
# ESS variable: domicil
#   Type of area where the respondent lives.
#   Rural residents typically depend more on private vehicles and home heating
#   fuel, making them more exposed to carbon/fuel tax increases than urban
#   residents with better public-transport access.
#   Source: ESS, Demographics & Background → Area Type / Urbanisation
#   Coding:
#     1 = A big city
#     2 = Suburbs or outskirts of big city
#     3 = Town or small city
#     4 = Country village
#     5 = Farm or home in the countryside
#   Treatment: include as ordered factor or create rural dummy
#              (rural = 1 if domicil >= 4, else 0)

# --- 4.6 Marital Status ---
# ESS variable: marsts
#   Respondent's current legal marital or civil union status.
#   Marital status is associated with household income pooling, social support
#   networks, and shared energy costs—all of which interact with the financial
#   impact of a carbon tax on wellbeing.
#   Source: ESS, Demographics & Background → Marital Status
#   Coding:
#     1 = Legally married
#     2 = In a legally registered civil union
#     3 = Legally separated
#     4 = Legally divorced
#     5 = Widowed
#     6 = Never married and never in a legally registered civil union
#   Treatment: consider binary (partnered = 1 if marsts %in% c(1,2), else 0)
#   Note: Provide explicit justification for inclusion in Section 3.2.2.

# --- 4.7 Self-Reported Health ---
# ESS variable: health
#   Subjective assessment of respondent's general health.
#   Health is a consistently strong predictor of subjective wellbeing across
#   income groups. Poor health may also increase fuel dependence (e.g.,
#   limited transport alternatives), heightening carbon-tax exposure.
#   Source: ESS, Health → Self-Reported Health
#   Coding:
#     1 = Very good
#     2 = Good
#     3 = Fair
#     4 = Bad
#     5 = Very bad
#   Treatment: include as ordered factor (higher = worse health) or recode
#              so higher = better health (recode: health_good = 6 - health)
#   Note: Clarify the theoretical link to carbon-tax effects in Section 3.2.2.

# --- 4.8 Main Activity Status (Employment) ---
# ESS variable: mnactic
#   Respondent's main activity or employment status.
#   Employment status affects household income and financial resilience, and
#   unemployed individuals may be more adversely affected by cost-of-living
#   increases arising from carbon taxation.
#   Source: ESS, Demographics & Background → Work & Employment
#   Coding:
#     1 = In paid work (employee, self-employed, working for family business)
#     2 = In education
#     3 = Unemployed and actively looking for a job
#     4 = Unemployed, not actively looking for a job
#     5 = Permanently sick or disabled
#     6 = Retired
#     7 = Community or military service
#     8 = Doing housework, looking after children or other persons
#     9 = Other
#   Treatment (recommended):
#     paid_work  = 1 if mnactic == 1, else 0
#     unemployed = 1 if mnactic %in% c(3, 4), else 0
#     (treat other categories, e.g. retired/student, as the reference group)


# =============================================================================
# 5. EXAMPLE: LOADING AND PREPARING THE DATA  (illustrative skeleton)
# =============================================================================

# -- Load required packages --
# library(haven)       # read Stata .dta files (ESS download format)
# library(dplyr)       # data manipulation
# library(tidyr)       # reshaping
# library(fixest)      # high-dimensional fixed effects (panel regression)

# -- Read ESS data (downloaded from https://ess-search.nsd.no/) --
# ess_raw <- haven::read_dta("data/ESS_rounds4_11.dta")

# -- Select and recode individual-level variables --
# ess <- ess_raw %>%
#   select(idno, cntry, essround, inwyr,          # identifiers
#          stflife,                               # dependent variable
#          hinctnt,                               # independent variable (income)
#          agea, gndr, eduyrs, hhmmb,             # demographic controls
#          domicil, marsts, health, mnactic) %>%  # additional controls
#   mutate(
#     # Dependent variable: replace refused/don't know with NA
#     stflife   = na_if(stflife, 77) %>% na_if(88) %>% na_if(99),
#
#     # Gender dummy (1 = female)
#     female    = if_else(gndr == 2, 1L, 0L),
#
#     # Rural dummy (1 = country village or farm/countryside)
#     rural     = if_else(domicil >= 4, 1L, 0L, missing = NA_integer_),
#
#     # Paid work dummy
#     paid_work  = if_else(mnactic == 1, 1L, 0L, missing = NA_integer_),
#
#     # Unemployed dummy (actively + not actively looking)
#     unemployed = if_else(mnactic %in% c(3, 4), 1L, 0L, missing = NA_integer_),
#
#     # Health: recode so higher = better
#     health_good = 6L - as.integer(health),
#
#     # Partnered dummy
#     partnered  = if_else(marsts %in% c(1, 2), 1L, 0L, missing = NA_integer_)
#   )

# -- Read OECD country-level data (downloaded from https://data.oecd.org/) --
# oecd_raw <- read.csv("data/OECD_country_controls.csv")

# -- Prepare country-level panel --
# oecd <- oecd_raw %>%
#   rename(cntry = LOCATION, year = TIME,
#          gdp_pc = Value_GDP,
#          inflation_cpi = Value_CPI,
#          unemp_rate = Value_UNEMP,
#          pm25_exposure = Value_PM25) %>%
#   mutate(log_gdp_pc = log(gdp_pc))

# -- Merge individual and country-level data --
# panel <- ess %>%
#   left_join(oecd, by = c("cntry", "inwyr" = "year"))

# -- Merge carbon tax (ECR) data --
# ecr <- read.csv("data/OECD_ECR.csv") %>%
#   rename(cntry = LOCATION, year = TIME, ecr = Value_ECR)
# panel <- panel %>%
#   left_join(ecr, by = c("cntry", "inwyr" = "year"))


# =============================================================================
# 6. EXAMPLE PANEL REGRESSION  (illustrative skeleton)
# =============================================================================

# model <- fixest::feols(
#   stflife ~ ecr                         # key independent variable
#           + ecr:hinctnt                 # interaction: carbon tax × income
#           # Country-level controls:
#           + log_gdp_pc                  # GDP per capita (log)
#           + inflation_cpi               # CPI inflation rate
#           + unemp_rate                  # national unemployment rate
#           + pm25_exposure               # PM2.5 air pollution
#           # Individual-level controls:
#           + agea + I(agea^2)            # age (quadratic)
#           + female                      # gender (1 = female)
#           + eduyrs                      # years of education
#           + hhmmb                       # household size
#           + rural                       # rural dummy
#           + partnered                   # partnered dummy
#           + health_good                 # self-reported health (higher = better)
#           + paid_work + unemployed      # employment status dummies
#           # Fixed effects:
#           | cntry + essround,           # country FE + round (time) FE
#   data = panel,
#   cluster = ~cntry                      # cluster SEs at country level
# )
# summary(model)
