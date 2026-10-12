# Partial derivatives (interactive app)

A Shiny app for exploring partial derivatives of multivariable functions visually. It moves from a simple surface, to slices through that surface, to the ideal gas law P(T, V) and the Gibbs energy G(T, P).

The app is shared as R source rather than a hosted app, so it can be read, adapted and run locally. It is not currently in active use in the course.

To run it, install the packages once and start the app from this folder (or click **Run App** in RStudio):

```r
install.packages(c("shiny", "plotly"))
shiny::runApp()
```

## Files

| File | Description |
|------|-------------|
| `app.R` | The Shiny app |
