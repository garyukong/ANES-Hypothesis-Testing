# Analysis of Voting Difficulties in the 2020 Election

## Introduction

This project investigates the voting difficulties experienced by Democratic and Republican voters in the 2020 election, utilizing data from the American National Election Studies (ANES). By analyzing this dataset, the project aims to understand the extent of voting challenges across political affiliations, contributing to discussions on electoral integrity and accessibility.

## Goals

- To identify if there was a significant difference in voting difficulties experienced by Democratic versus Republican voters in the 2020 election.
- To analyze factors contributing to any observed disparities in voting experiences.
- To provide insights that may help improve electoral processes and voter accessibility in future elections.

## Dataset

The analysis is based on the 2020 Time Series Study from the American National Election Studies (ANES). This dataset includes a wide range of voter responses from the period surrounding the 2020 presidential election.

### Source:
- [American National Election Studies 2020 Time Series Study](https://electionstudies.org)

## Methodology

1. **Data Preprocessing**: Cleaning and structuring the ANES 2020 data to focus on relevant variables for analyzing voting difficulties.
2. **Operationalization**: Defining "voting difficulty" based on survey responses and classifying voters as Democratic or Republican, including those who lean towards either party.
3. **Statistical Analysis**: Employing hypothesis testing to determine if there's a statistically significant difference in voting difficulties between the two voter groups.

## Results

The analysis revealed differences in voting experiences between Democratic and Republican voters, with specific emphasis on the impact of external factors like voting methods and geographical locations.

## Usage

To replicate this analysis:
1. Access and download the ANES 2020 data.
2. Follow the methodology outlined in the `notebooks/` directory, which includes RMD files for data analysis.

## Future Work

Further research could explore more granular aspects of voting difficulties, such as the impact of specific state-level policies on voter experiences. Additionally, longitudinal studies could assess changes in voting accessibility over multiple election cycles.

## Contributors
- Gary Kong
- Yeshwanth Somu
- Maiya Caldwell
- Clara Zhu

## Project Organization

    ├── LICENSE
    ├── README.md          
    ├── data
    │   ├── external       <- Original ANES 2020 data used for analysis.
    │   ├── interim        <- Intermediate data transformations.
    │   └── processed      <- The final, canonical datasets for modeling.
    ├── notebooks          <- RMD notebooks for detailed analysis. 
    └── reports            <- Generated analysis as PDF and other formats.
