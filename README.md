# FA515: Pharmaceutical Physical Chemistry — R & Data Science Materials

Teaching materials for **FA515: Pharmaceutical Physical Chemistry** (5 ECTS, Bachelor level, Autumn semester) at the University of Southern Denmark (SDU), developed as part of [CPDSE](https://cpdse.dk)'s work integrating data science and R programming into the pharmacy curriculum.

FA515 covers thermodynamic functions, phase diagrams and phase transitions, ideal and non-ideal solutions, acid-base equilibria, ionic solutions, surface tension, and reaction kinetics. This repository contains the R/Quarto activities that introduce students to data science through these topics. Code always serves the chemistry, not the other way around.

Course description: [FA515 at SDU](https://odin.sdu.dk/sitecore/index.php?a=fagbesk&id=209672&listid=1751&lang=en)

## Activities

### `intro/` — Introduction to R
A first hands-on introduction to R for students with no prior programming experience: the basics needed before using R in the physical chemistry activities below.

### `kinetics_assigment/` — Reaction Kinetics
Data analysis activity on reaction kinetics, stability, and shelf-life estimation. Includes the assignment brief, the R/Quarto guide, and example stability data (concentration vs. time at different conditions).

### `vapour_pressure/` — Vapour Pressure
Data analysis activity on vapour pressure of pure liquids and mixtures. Includes the assignment brief, the R/Quarto guide, and example data. **Work in progress** — content here may still change ahead of use in the course.

### `partial_derivatives/` — Partial Derivatives (interactive app)
A Shiny app (`app.R`) for exploring partial derivatives of multivariable functions interactively. Shared here as the R source rather than a deployed/hosted app, so it can be read, adapted, and run locally (`shiny::runApp()`) by anyone. Not currently in active use in the course.

## Structure

```
intro/
kinetics_assigment/
vapour_pressure/
partial_derivatives/
```

*(Each activity folder bundles its own guide, example data, and assignment brief where applicable.)*

## License

To be added once the repository is populated — the materials will be openly licensed for reuse in teaching (with attribution). Solution keys and internal planning documents are not published here regardless.
