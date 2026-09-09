# Vapour Pressure

**Status: work in progress.**

A solvent's volatility — how readily it evaporates — is governed by its vapour pressure and how that pressure depends on temperature. This matters throughout pharmaceutical development: choosing a solvent for recrystallisation or extraction, or removing residual solvent from a formulation during drying.

In this activity, students work with vapour pressure measured across a range of temperatures for three common solvents — acetone, ethyl acetate, and methanol — either from a provided dataset or from their own bench measurements. The R guide walks through turning that data into a Clausius–Clapeyron plot (a linearized form of the underlying non-linear relationship, the same "linearize, then fit a straight line" approach used earlier in the course for temperature-dependent reaction rate constants), reading the enthalpy and entropy of vaporization ($\Delta_{vap}H$, $\Delta_{vap}S$) off the fitted line, and from there calculating each solvent's standard and normal boiling point. Students then use Trouton's rule to compare the three solvents and reason about which one behaves atypically, and why.

## Background: the wet-lab exercise

The same Clausius–Clapeyron analysis is also applied in SDU's physical lab exercise for the course (Øvelse A3, "Damptryk af en lavtkogende væske" — vapour pressure of a low-boiling liquid), where students measure the vapour pressure of diethyl ether and methylene chloride (dichloromethane) at 8–10 temperatures using a piezoelectric pressure transducer in a thermostatted vacuum setup, then determine $\Delta_{vap}H$, the normal boiling point, and $\Delta_{vap}S$ for each liquid and check the results against Trouton's rule. The framing there is aerosol propellants: a spray can works by keeping a liquid in equilibrium with its vapour rather than using compressed gas, so a liquid's boiling point and vapour pressure determine whether it's usable as one — the exercise's discussion questions look at asthma-inhaler propellants (HFC-134a) and how storage temperature and altitude affect their behaviour.

## In this folder

- `FA515_Assignment5_VapourPressure_2026.docx` — the student-facing assignment brief
- `guide/vapour_pressure_R_guide.qmd` / `.html` — the R walkthrough (data import, linearization, fitting, extracting thermodynamic quantities)
- `vapour_pressure_acetone_ethylacetate_methanol.csv` — the provided vapour pressure vs. temperature dataset for all three solvents
- `A3_vapour_pressure_example_data.xlsx` — an example of how to structure your own measured data (e.g. from a practical) so it imports cleanly
- `vapour_pressure_analysis_example.R` — a worked R script covering the same analysis
