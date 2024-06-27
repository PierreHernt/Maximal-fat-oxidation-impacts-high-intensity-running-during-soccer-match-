# Maximal Fat Oxidation and High-Intensity Running Performance in Elite Soccer Players

## Introduction

This study examines the possible associations between maximal fat oxidation (MFO) and match running performance in elite soccer players. It also aims to assess the importance of MFO in match performance compared to other physical qualities traditionally targeted by physical trainers (e.g., VO2max, strength, power).

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Data](#data)
- [Code](#code)
- [Results](#results)
- [Contributing](#contributing)
- [License](#license)

## Installation

### Prerequisites

- R version 3.6 or higher
- RStudio
- Required R packages: `ggplot2`, `dplyr`, `rpart`, `boot`

### Instructions

Clone the repository and install the necessary dependencies:

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
Rscript install_packages.R
```

## Usage

Rscript Variables\ Importances.R

## Data
The dataset used in this study is available in the file data_standardized.csv. This file contains physiological and performance data of elite soccer players collected over a competitive season.

### Data Structure
- Identifiant : Player identifier
- VO2max: Maximum oxygen consumption (ml/min/kg)
- MFO: Maximum fat oxidation (g/min)
- F0H: Theoretical horizontal maximal force (N/kg)
- PmaxH: Theoretical horizontal maximal power (W/kg)
- total_distance: Total distance covered (m)
- high_intensity_distance: High-intensity distance covered (m)

## Code

### Variables Importances
The Variables Importances.R script uses regression trees to assess the importance of physiological variables on GPS-measured running performance.

### Simple Tree
The Arbre simple.R script generates a simplified regression tree based on the most discriminative variable for GPS-measured running performance.

## Results

### Importance of Variables for Total Distance
Results indicate that VO2max is the most important variable for estimating the total distance covered during matches. Players with a VO2max greater than 55.6 ml/min/kg cover more distance on average than those below this threshold.

### Importance of Variables for Sprint Performance
F0H and PmaxH are the most important variables for estimating sprint performance. Players with a PmaxH greater than 19 W/kg tend to have higher sprint performance.

### Importance of Variables for High-Intensity Running
MFO is the most important variable for estimating high-intensity running distance (> 15 km/h). Players with an MFO greater than 0.73 g/min cover more high-intensity distance on average than those below this threshold.
