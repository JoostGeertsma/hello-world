# hello-world
This one is for brainstorming and trying out new ideas
My name is Joost Geertsma and I am a student in economics and business at the Radboud University in Nijmegen.

## Carbon Tax & Subjective Wellbeing — Panel Regression

This repository contains a data processing script for a longitudinal, cross-country panel regression studying the effect of carbon taxation on subjective wellbeing, using OECD macro-level data and European Social Survey (ESS) individual-level data.

### Files

| File | Description |
|------|-------------|
| `data_processing.R` | Full variable definitions, coding, and data preparation skeleton for the panel analysis. Includes all country-level (OECD) and individual-level (ESS) control variables with source references and comments. |

### Variables Overview

**Dependent variable:** `stflife` (ESS – life satisfaction, 0–10)

**Key independent variable:** Effective Carbon Rate / ECR (OECD)

**Country-level controls (OECD):**
- `log_gdp_pc` — GDP per capita (log-transformed)
- `inflation_cpi` — CPI inflation rate (annual %)
- `unemp_rate` — National unemployment rate
- `pm25_exposure` — PM2.5 population-weighted air pollution exposure

**Individual-level controls (ESS):**
- `agea` — Age (years)
- `gndr` — Gender
- `eduyrs` — Years of education
- `hhmmb` — Household size
- `domicil` — Living area (urban/rural)
- `marsts` — Marital status
- `health` — Self-reported health
- `mnactic` — Main activity / employment status

See `data_processing.R` for full variable definitions, response-category coding, and source URLs.
