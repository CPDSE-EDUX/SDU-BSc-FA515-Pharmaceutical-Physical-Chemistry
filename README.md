# FA515: Pharmaceutical Physical Chemistry

Data science material for **FA515 Pharmaceutical Physical Chemistry** (BSc Pharmacy, University of Southern Denmark). The material shows students how to treat and visualise physical chemistry data in R and write about it in Quarto.

FA515 covers thermodynamic functions, phase diagrams and phase transitions, ideal and non-ideal solutions, acid-base equilibria, ionic solutions, surface tension, and reaction kinetics. Course description: [FA515 at SDU](https://odin.sdu.dk/sitecore/index.php?a=fagbesk&id=209672&listid=1751&lang=en).

This repository holds the R and Quarto material only. The full course material, including the lab manual and the course schedule, lives in ItsLearning. Solutions are not published here.

The material is written in English.

## Data Science Learning Outcomes

The learning outcome from the official course description that this material supports. The student demonstrates the ability to:

- Perform data treatment and visualization in R.

## Structure

```
├── intro/                  Getting started with R
├── quarto_guide/           Getting started with Quarto
├── kinetics_assignment/    Reaction kinetics, stability and shelf life
├── vapour_pressure/        Vapour pressure and the Clausius-Clapeyron equation
├── partial_derivatives/    Interactive app on partial derivatives (not currently used in the course)
├── CITATION.cff
├── LICENSE                 CC BY 4.0 (teaching content)
└── LICENSE-code            MIT (code)
```

Each folder is self-contained: the guide and the files it needs sit together, so students can download a single folder and work from it. Each folder has its own README describing its contents.

## Setup

You need:

- [R](https://cran.r-project.org/) (version 4.3 or newer)
- [RStudio](https://posit.co/download/rstudio-desktop/) (includes Quarto)

Install the R packages used in the course:

```r
install.packages(c("tidyverse", "readxl", "writexl", "plotly", "shiny"))
```

Rendering Quarto documents to PDF also needs TinyTeX, see `quarto_guide/`.

## Versions

The `main` branch holds the material for the current year. When a course run ends, it is archived in a branch named after the year (for example `2026`).

## Citation and license

If you reuse or adapt the material, please cite it using [CITATION.cff](CITATION.cff) (GitHub shows a "Cite this repository" button).

Teaching content is licensed under [CC BY 4.0](LICENSE) and code under [MIT](LICENSE-code).

Part of the [CPDSE](https://github.com/CPDSE-EDUX) teaching material from the Center for Pharmaceutical Data Science Education.
