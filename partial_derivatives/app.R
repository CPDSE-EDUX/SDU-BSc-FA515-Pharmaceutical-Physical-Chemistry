# ─────────────────────────────────────────────────────────────────────────────
# Partial Derivatives — A Visual Introduction
# Shiny app for RStudio
#
# Dependencies:  shiny   plotly
# Install once:  install.packages(c("shiny", "plotly"))
# Run:           shiny::runApp()   OR click the Run App button in RStudio
# ─────────────────────────────────────────────────────────────────────────────

library(shiny)
library(plotly)

# ─────────────────────────────────────────────────────────────────────────────
# Constants
# ─────────────────────────────────────────────────────────────────────────────
n_mol   <- 1.0
R_const <- 8.314         # J mol⁻¹ K⁻¹
G0_ref  <- -228600.0     # J/mol  (water vapour, 298 K standard state)
S0_ref  <-    188.8      # J mol⁻¹ K⁻¹
T_ref   <-    298.0      # K
P_ref   <-    100.0      # kPa

# ─────────────────────────────────────────────────────────────────────────────
# Model functions
# ─────────────────────────────────────────────────────────────────────────────
f1    <- function(x, y) x^2 + y^2
P_gas <- function(T, V)  n_mol * R_const * T / (V * 1e-3) / 1000
G_fn  <- function(T, P) (G0_ref - n_mol * S0_ref * (T - T_ref) +
                           n_mol * R_const * T * log(P / P_ref)) / 1000

# ─────────────────────────────────────────────────────────────────────────────
# 3-D surface builders
# ─────────────────────────────────────────────────────────────────────────────
make_surf_f1 <- function(x0 = NULL, y0 = NULL) {
  x <- seq(-2, 2, length.out = 50)
  y <- seq(-2, 2, length.out = 50)
  # outer(x,y,f) gives rows=x, cols=y; plotly needs rows=y, cols=x → t()
  z <- t(outer(x, y, f1))
  p <- plot_ly(x = x, y = y, z = z) |>
    add_surface(
      colorscale = list(c(0, "#0d9488"), c(1, "#99f6e4")),
      opacity    = 0.90,
      colorbar   = list(title = "f(x,y)", len = 0.5)
    ) |>
    layout(
      title  = list(text = "f(x, y) = x\u00b2 + y\u00b2", font = list(size = 15)),
      scene  = list(
        xaxis  = list(title = "x"),
        yaxis  = list(title = "y"),
        zaxis  = list(title = "f(x, y)"),
        camera = list(eye = list(x = 1.6, y = -1.8, z = 1.2))
      ),
      margin = list(t = 55, r = 0, b = 0, l = 0)
    )
  if (!is.null(x0) && !is.null(y0)) {
    zmin <- min(z); zmax <- max(z)
    xg <- seq(-2, 2, length.out = 100)
    yg <- seq(-2, 2, length.out = 100)
    hw <- 0.8
    p <- p |>
      # x-slice plane: hold y = y0 (orange)
      add_trace(
        type = "mesh3d", showscale = FALSE, hoverinfo = "skip",
        x = c(-2, 2, 2, -2), y = c(y0, y0, y0, y0),
        z = c(zmin, zmin, zmax, zmax),
        i = c(0, 0), j = c(1, 2), k = c(2, 3),
        color = "#f97316", opacity = 0.20
      ) |>
      add_trace(
        type = "scatter3d", mode = "lines", hoverinfo = "skip",
        x = xg, y = rep(y0, 100), z = f1(xg, y0),
        line = list(color = "#f97316", width = 4)
      ) |>
      add_trace(
        type = "scatter3d", mode = "lines", hoverinfo = "skip",
        x = c(x0 - hw, x0 + hw), y = c(y0, y0),
        z = c(f1(x0, y0) - 2*x0*hw, f1(x0, y0) + 2*x0*hw),
        line = list(color = "#1e293b", width = 3, dash = "dash")
      ) |>
      # y-slice plane: hold x = x0 (blue)
      add_trace(
        type = "mesh3d", showscale = FALSE, hoverinfo = "skip",
        x = c(x0, x0, x0, x0), y = c(-2, 2, 2, -2),
        z = c(zmin, zmin, zmax, zmax),
        i = c(0, 0), j = c(1, 2), k = c(2, 3),
        color = "#3b82f6", opacity = 0.20
      ) |>
      add_trace(
        type = "scatter3d", mode = "lines", hoverinfo = "skip",
        x = rep(x0, 100), y = yg, z = f1(x0, yg),
        line = list(color = "#3b82f6", width = 4)
      ) |>
      add_trace(
        type = "scatter3d", mode = "lines", hoverinfo = "skip",
        x = c(x0, x0), y = c(y0 - hw, y0 + hw),
        z = c(f1(x0, y0) - 2*y0*hw, f1(x0, y0) + 2*y0*hw),
        line = list(color = "#1e293b", width = 3, dash = "dash")
      ) |>
      add_trace(
        type = "scatter3d", mode = "markers", hoverinfo = "skip",
        x = x0, y = y0, z = f1(x0, y0),
        marker = list(color = "#1e293b", size = 6,
                      line = list(color = "white", width = 1.5))
      )
  }
  p
}

make_surf_gas <- function(T0 = NULL, V0 = NULL) {
  T_ax <- seq(200, 500, length.out = 50)
  V_ax <- seq(0.5, 5.0, length.out = 50)
  Pg   <- outer(T_ax, V_ax, P_gas)   # [i,j] = P(T_ax[i], V_ax[j])
  p <- plot_ly(x = T_ax, y = V_ax, z = t(Pg)) |>
    add_surface(
      colorscale   = "RdBu",
      reversescale = TRUE,
      colorbar     = list(title = "P (kPa)", len = 0.5)
    ) |>
    layout(
      title  = list(text = "P(T, V) = nRT/V", font = list(size = 15)),
      scene  = list(
        xaxis  = list(title = "T (K)"),
        yaxis  = list(title = "V (L)"),
        zaxis  = list(title = "P (kPa)"),
        camera = list(eye = list(x = 1.6, y = -1.8, z = 1.2))
      ),
      margin = list(t = 55, r = 0, b = 0, l = 0)
    )
  if (!is.null(T0) && !is.null(V0)) {
    zmin  <- min(Pg); zmax <- max(Pg)
    Tg    <- seq(200, 500, length.out = 100)
    Vg    <- seq(0.5, 5.0, length.out = 100)
    P0    <- P_gas(T0, V0)
    dPdT  <- n_mol * R_const / (V0 * 1e-3) / 1000
    dPdV  <- -(n_mol * R_const * T0) / (V0 * 1e-3)^2 / 1e6
    hwT   <- 60; hwV <- 0.8
    p <- p |>
      # T-slice plane: hold V = V0 (orange)
      add_trace(
        type = "mesh3d", showscale = FALSE, hoverinfo = "skip",
        x = c(200, 500, 500, 200), y = c(V0, V0, V0, V0),
        z = c(zmin, zmin, zmax, zmax),
        i = c(0, 0), j = c(1, 2), k = c(2, 3),
        color = "#f97316", opacity = 0.20
      ) |>
      add_trace(
        type = "scatter3d", mode = "lines", hoverinfo = "skip",
        x = Tg, y = rep(V0, 100), z = P_gas(Tg, V0),
        line = list(color = "#f97316", width = 4)
      ) |>
      add_trace(
        type = "scatter3d", mode = "lines", hoverinfo = "skip",
        x = c(T0 - hwT, T0 + hwT), y = c(V0, V0),
        z = c(P0 - dPdT*hwT, P0 + dPdT*hwT),
        line = list(color = "#1e293b", width = 3, dash = "dash")
      ) |>
      # V-slice plane: hold T = T0 (blue)
      add_trace(
        type = "mesh3d", showscale = FALSE, hoverinfo = "skip",
        x = c(T0, T0, T0, T0), y = c(0.5, 5.0, 5.0, 0.5),
        z = c(zmin, zmin, zmax, zmax),
        i = c(0, 0), j = c(1, 2), k = c(2, 3),
        color = "#3b82f6", opacity = 0.20
      ) |>
      add_trace(
        type = "scatter3d", mode = "lines", hoverinfo = "skip",
        x = rep(T0, 100), y = Vg, z = P_gas(T0, Vg),
        line = list(color = "#3b82f6", width = 4)
      ) |>
      add_trace(
        type = "scatter3d", mode = "lines", hoverinfo = "skip",
        x = c(T0, T0), y = c(V0 - hwV, V0 + hwV),
        z = c(P0 - dPdV*hwV, P0 + dPdV*hwV),
        line = list(color = "#1e293b", width = 3, dash = "dash")
      ) |>
      add_trace(
        type = "scatter3d", mode = "markers", hoverinfo = "skip",
        x = T0, y = V0, z = P0,
        marker = list(color = "#1e293b", size = 6,
                      line = list(color = "white", width = 1.5))
      )
  }
  p
}

make_surf_gibbs <- function(T0 = NULL, P0v = NULL) {
  T_ax2 <- seq(280, 380, length.out = 50)
  P_ax2 <- seq( 50, 200, length.out = 50)
  Gg    <- outer(T_ax2, P_ax2, G_fn)
  p <- plot_ly(x = T_ax2, y = P_ax2, z = t(Gg)) |>
    add_surface(
      colorscale = "Viridis",
      colorbar   = list(title = "G (kJ/mol)", len = 0.5)
    ) |>
    layout(
      title  = list(text = "G(T, P) \u2014 Gibbs free energy", font = list(size = 15)),
      scene  = list(
        xaxis  = list(title = "T (K)"),
        yaxis  = list(title = "P (kPa)"),
        zaxis  = list(title = "G (kJ/mol)"),
        camera = list(eye = list(x = 1.6, y = -1.8, z = 1.2))
      ),
      margin = list(t = 55, r = 0, b = 0, l = 0)
    )
  if (!is.null(T0) && !is.null(P0v)) {
    zmin <- min(Gg); zmax <- max(Gg)
    Tg   <- seq(280, 380, length.out = 100)
    Pg2  <- seq( 50, 200, length.out = 100)
    G0   <- G_fn(T0, P0v)
    dGdT <- (-n_mol * S0_ref + n_mol * R_const * log(P0v / P_ref)) / 1000
    dGdP <- n_mol * R_const * T0 / P0v / 1000
    hwT  <- 25; hwP <- 30
    p <- p |>
      # T-slice plane: hold P = P0v (orange)
      add_trace(
        type = "mesh3d", showscale = FALSE, hoverinfo = "skip",
        x = c(280, 380, 380, 280), y = c(P0v, P0v, P0v, P0v),
        z = c(zmin, zmin, zmax, zmax),
        i = c(0, 0), j = c(1, 2), k = c(2, 3),
        color = "#f97316", opacity = 0.20
      ) |>
      add_trace(
        type = "scatter3d", mode = "lines", hoverinfo = "skip",
        x = Tg, y = rep(P0v, 100), z = G_fn(Tg, P0v),
        line = list(color = "#f97316", width = 4)
      ) |>
      add_trace(
        type = "scatter3d", mode = "lines", hoverinfo = "skip",
        x = c(T0 - hwT, T0 + hwT), y = c(P0v, P0v),
        z = c(G0 - dGdT*hwT, G0 + dGdT*hwT),
        line = list(color = "#1e293b", width = 3, dash = "dash")
      ) |>
      # P-slice plane: hold T = T0 (blue)
      add_trace(
        type = "mesh3d", showscale = FALSE, hoverinfo = "skip",
        x = c(T0, T0, T0, T0), y = c(50, 200, 200, 50),
        z = c(zmin, zmin, zmax, zmax),
        i = c(0, 0), j = c(1, 2), k = c(2, 3),
        color = "#3b82f6", opacity = 0.20
      ) |>
      add_trace(
        type = "scatter3d", mode = "lines", hoverinfo = "skip",
        x = rep(T0, 100), y = Pg2, z = G_fn(T0, Pg2),
        line = list(color = "#3b82f6", width = 4)
      ) |>
      add_trace(
        type = "scatter3d", mode = "lines", hoverinfo = "skip",
        x = c(T0, T0), y = c(P0v - hwP, P0v + hwP),
        z = c(G0 - dGdP*hwP, G0 + dGdP*hwP),
        line = list(color = "#1e293b", width = 3, dash = "dash")
      ) |>
      add_trace(
        type = "scatter3d", mode = "markers", hoverinfo = "skip",
        x = T0, y = P0v, z = G0,
        marker = list(color = "#1e293b", size = 6,
                      line = list(color = "white", width = 1.5))
      )
  }
  p
}

# ─────────────────────────────────────────────────────────────────────────────
# Generic single-slice helper
#   xgrid  — vector of x values for the full curve
#   ycurve — vector of y values (the slice)
#   xpt    — x-coordinate of the evaluation point
#   ypt    — y-coordinate (exact function value at xpt)
#   slope  — partial derivative at (xpt, ypt)
#   win    — half-width of the tangent line segment
#   col    — curve colour (orange = x-direction, blue = y-direction)
# ─────────────────────────────────────────────────────────────────────────────
one_slice <- function(xgrid, ycurve, xpt, ypt, slope, win,
                      xlabel, ylabel, title_text, col) {
  xn <- xgrid[abs(xgrid - xpt) < win]
  plot_ly() |>
    add_trace(
      x = xgrid, y = ycurve,
      type = "scatter", mode = "lines",
      line = list(color = col, width = 2.5),
      showlegend = FALSE,
      hovertemplate = paste0(xlabel, " = %{x:.2f}<br>",
                              ylabel, " = %{y:.3f}<extra></extra>")
    ) |>
    add_trace(
      x = xn, y = ypt + slope * (xn - xpt),
      type = "scatter", mode = "lines",
      line = list(color = "#1e293b", width = 2, dash = "dash"),
      showlegend = FALSE,
      hoverinfo = "skip"
    ) |>
    add_trace(
      x = c(xpt), y = c(ypt),
      type = "scatter", mode = "markers",
      marker = list(color = "#1e293b", size = 9,
                    line = list(color = "white", width = 1.5)),
      showlegend = FALSE,
      hoverinfo = "skip"
    ) |>
    layout(
      title       = list(text = title_text,
                         font = list(size = 12.5, color = col)),
      xaxis       = list(title = xlabel, zeroline = FALSE),
      yaxis       = list(title = ylabel, zeroline = FALSE),
      margin      = list(t = 60, r = 15, b = 55, l = 60),
      plot_bgcolor  = "rgba(248, 250, 252, 1)",
      paper_bgcolor = "white"
    )
}

# ─────────────────────────────────────────────────────────────────────────────
# Per-act slice sets  (return a list with $px and $py)
# ─────────────────────────────────────────────────────────────────────────────

## Act 2 — f(x, y) = x² + y²
slices_f1 <- function(x0, y0) {
  xg <- seq(-2, 2, length.out = 200)
  yg <- seq(-2, 2, length.out = 200)
  f0 <- f1(x0, y0)
  list(
    px = one_slice(xg, f1(xg, y0), x0, f0, 2 * x0, 0.8,
                   "x",
                   paste0("f(x, y\u2080 = ", y0, ")"),
                   paste0("\u2202f/\u2202x = 2x\u2080 = ", round(2 * x0, 3)),
                   "#f97316"),
    py = one_slice(yg, f1(x0, yg), y0, f0, 2 * y0, 0.8,
                   "y",
                   paste0("f(x\u2080 = ", x0, ", y)"),
                   paste0("\u2202f/\u2202y = 2y\u2080 = ", round(2 * y0, 3)),
                   "#3b82f6")
  )
}

## Act 3 — Ideal gas  P(T, V)
slices_gas <- function(T0, V0) {
  Tg  <- seq(200, 500, length.out = 300)
  Vg  <- seq(0.5, 5.0, length.out = 300)
  P0  <- P_gas(T0, V0)
  dPT <- n_mol * R_const / (V0 * 1e-3) / 1000            # kPa/K
  dPV <- -(n_mol * R_const * T0) / (V0 * 1e-3)^2 / 1e6  # kPa/L
  list(
    px = one_slice(Tg, P_gas(Tg, V0), T0, P0, dPT, 60,
                   "T (K)", "P (kPa)",
                   paste0("(\u2202P/\u2202T)\u1d65 = nR/V = ",
                          round(dPT, 3), " kPa/K"),
                   "#f97316"),
    py = one_slice(Vg, P_gas(T0, Vg), V0, P0, dPV, 0.8,
                   "V (L)", "P (kPa)",
                   paste0("(\u2202P/\u2202V)\u1d68 = \u2212nRT/V\u00b2 = ",
                          round(dPV, 1), " kPa/L"),
                   "#3b82f6")
  )
}

## Act 4 — Gibbs free energy  G(T, P)
slices_gibbs <- function(T0, P0v) {
  Tg  <- seq(280, 380, length.out = 300)
  Pg  <- seq( 50, 200, length.out = 300)
  G0  <- G_fn(T0, P0v)
  dGT <- (-n_mol * S0_ref + n_mol * R_const * log(P0v / P_ref)) / 1000
  dGP <- n_mol * R_const * T0 / P0v / 1000
  list(
    px = one_slice(Tg, G_fn(Tg, P0v), T0, G0, dGT, 25,
                   "T (K)", "G (kJ/mol)",
                   paste0("(\u2202G/\u2202T)\u209a = \u2212S = ",
                          round(dGT, 4), " kJ mol\u207b\u00b9 K\u207b\u00b9"),
                   "#f97316"),
    py = one_slice(Pg, G_fn(T0, Pg), P0v, G0, dGP, 30,
                   "P (kPa)", "G (kJ/mol)",
                   paste0("(\u2202G/\u2202P)\u1d68 = V\u2098 = ",
                          round(dGP, 5), " kJ mol\u207b\u00b9 kPa\u207b\u00b9"),
                   "#3b82f6")
  )
}

# ─────────────────────────────────────────────────────────────────────────────
# Shared CSS
# ─────────────────────────────────────────────────────────────────────────────
app_css <- "
  body { font-size: 14.5px; }
  .sidebar-panel-text p  { color: #374151; line-height: 1.6; }
  .sidebar-panel-text em { color: #6b7280; font-size: 0.92em; }
  .well { background: #f8fafc; border: 1px solid #e2e8f0;
          border-radius: 6px; padding: 16px; }
  .irs--shiny .irs-bar { background: #0d9488; border-color: #0d9488; }
  .irs--shiny .irs-handle { background: #0d9488; border-color: #0d9488; }
"

# ─────────────────────────────────────────────────────────────────────────────
# UI
# ─────────────────────────────────────────────────────────────────────────────
ui <- navbarPage(
  title  = "Partial Derivatives",
  id     = "nav",
  header = tagList(
    withMathJax(),
    tags$style(HTML(app_css))
  ),

  # ── Introduction ─────────────────────────────────────────────────────────
  tabPanel("Introduction",
    fluidRow(column(8, offset = 2,
      br(),
      h2("Partial Derivatives \u2014 A Visual Introduction"),
      p(em("With examples from physical chemistry")),
      hr(),
      p("This app builds intuition for ", strong("partial derivatives"),
        " in four acts:"),
      tags$ol(
        tags$li(strong("Act 1 — Surfaces: "),
                "functions of two variables and what they look like"),
        tags$li(strong("Act 2 — Slicing: "),
                "what a partial derivative is, geometrically"),
        tags$li(strong("Act 3 — Ideal gas: "),
                HTML("\\((\\partial P/\\partial T)_V\\) and
                      \\((\\partial P/\\partial V)_T\\)")),
        tags$li(strong("Act 4 — Gibbs energy: "),
                HTML("\\((\\partial G/\\partial T)_P = -S\\) and
                      \\((\\partial G/\\partial P)_T = V_m\\)"))
      ),
      hr(),
      h4("The core idea"),
      p("For a function of two variables \\(f(x, y)\\), the partial
        derivative with respect to \\(x\\) is:"),
      p("$$\\frac{\\partial f}{\\partial x}\\bigg|_{(x_0,\\,y_0)} =
         \\lim_{h \\to 0}\\frac{f(x_0+h,\\,y_0) - f(x_0,\\,y_0)}{h}$$"),
      p("Treat every variable ", em("except"), " the one you're
        differentiating as a constant. That is all \\(\\partial\\) means."),
      p("The thermodynamic subscript notation, e.g.
        \\(\\left(\\tfrac{\\partial P}{\\partial T}\\right)_V\\),
        is just a reminder of which variable is held fixed."),
      hr(),
      h4("How to use"),
      p("Click the tabs above in order. Each act shows a rotatable 3-D surface
        and two 2-D slice viewers. Move the sliders to see how the tangent
        slopes change across the surface.")
    ))
  ),

  # ── Act 1 ─────────────────────────────────────────────────────────────────
  tabPanel("Act 1 \u2014 Surfaces",
    sidebarLayout(
      sidebarPanel(width = 3,
        div(class = "sidebar-panel-text",
          h4("Functions of two variables"),
          p("A function of ", strong("one"), " variable — say \\(f(x)=x^2\\) —
            maps each number to a single output. You draw it as a curve."),
          p("A function of ", strong("two"), " variables maps each pair
            \\((x,y)\\) to a value. The output becomes the ",
            em("height"), " of a surface."),
          hr(),
          p("Below is \\(f(x,y) = x^2 + y^2\\) \u2014 a bowl-shaped paraboloid.
            Drag to rotate."),
          hr(),
          p(em("What to notice: the surface is lowest at (0, 0) and grows
                in all directions. The ", strong("rate"), " of growth depends on
                where you are and which direction you move. That is what partial
                derivatives measure."))
        )
      ),
      mainPanel(width = 9,
        plotlyOutput("surf_f1_act1", height = "540px")
      )
    )
  ),

  # ── Act 2 ─────────────────────────────────────────────────────────────────
  tabPanel("Act 2 \u2014 Slices",
    sidebarLayout(
      sidebarPanel(width = 3,
        div(class = "sidebar-panel-text",
          h4("What is a partial derivative?"),
          p("Fix \\(y = y_0\\) and vary \\(x\\) \u2014 you slice the surface
            with a vertical plane. The slice is an ordinary curve.
            Its slope at \\(x_0\\) is \\(\\partial f/\\partial x\\)."),
          p("For \\(f(x,y) = x^2+y^2\\):"),
          p("$$\\frac{\\partial f}{\\partial x} = 2x,\\quad
              \\frac{\\partial f}{\\partial y} = 2y$$"),
          p("The ", span(style="color:#f97316;font-weight:bold", "orange"),
            " plot shows the x-slice (\\(y\\) fixed)."),
          p("The ", span(style="color:#3b82f6;font-weight:bold", "blue"),
            " plot shows the y-slice (\\(x\\) fixed)."),
          p("The dashed line is the tangent \u2014 its slope is the derivative."),
          hr(),
          sliderInput("x0_f1", HTML("x<sub>0</sub>"),
                      min = -1.8, max = 1.8, value = 0.5, step = 0.1),
          sliderInput("y0_f1", HTML("y<sub>0</sub>"),
                      min = -1.8, max = 1.8, value = 0.5, step = 0.1),
          hr(),
          p(em("Try \\(x_0=0\\): tangent is flat (\\(\\partial f/\\partial x=0\\))
               at the bowl\u2019s bottom.")),
          p(em("Try \\(x_0=y_0\\): both derivatives are equal \u2014 the bowl is symmetric."))
        )
      ),
      mainPanel(width = 9,
        plotlyOutput("surf_f1_act2", height = "360px"),
        hr(),
        fluidRow(
          column(6, plotlyOutput("slice_f1_x", height = "310px")),
          column(6, plotlyOutput("slice_f1_y", height = "310px"))
        )
      )
    )
  ),

  # ── Act 3 ─────────────────────────────────────────────────────────────────
  tabPanel("Act 3 \u2014 Ideal Gas",
    sidebarLayout(
      sidebarPanel(width = 3,
        div(class = "sidebar-panel-text",
          h4("The ideal gas law"),
          p("With \\(n\\) fixed, \\(PV = nRT\\) rearranges to:"),
          p("$$P(T,V) = \\frac{nRT}{V}$$"),
          p("Its partial derivatives:"),
          p("$$\\left(\\frac{\\partial P}{\\partial T}\\right)_V = \\frac{nR}{V}$$"),
          p("$$\\left(\\frac{\\partial P}{\\partial V}\\right)_T =
              -\\frac{nRT}{V^2}$$"),
          hr(),
          sliderInput("T0_gas", HTML("T<sub>0</sub> (K)"),
                      min = 220, max = 480, value = 300, step = 10),
          sliderInput("V0_gas", HTML("V<sub>0</sub> (L)"),
                      min = 0.5, max = 5.0, value = 2.0, step = 0.1),
          hr(),
          p(em("Try \\(V_0=0.7\\) L: the V-slope is very steep at small
               volumes (high pressure sensitivity).")),
          p(em("The T-slice is always straight \u2014
               \\((\\partial P/\\partial T)_V = nR/V\\) is constant
               at fixed \\(V\\)."))
        )
      ),
      mainPanel(width = 9,
        plotlyOutput("surf_gas", height = "360px"),
        hr(),
        fluidRow(
          column(6, plotlyOutput("slice_gas_T", height = "310px")),
          column(6, plotlyOutput("slice_gas_V", height = "310px"))
        )
      )
    )
  ),

  # ── Act 4 ─────────────────────────────────────────────────────────────────
  tabPanel("Act 4 \u2014 Gibbs Energy",
    sidebarLayout(
      sidebarPanel(width = 3,
        div(class = "sidebar-panel-text",
          h4("Gibbs free energy"),
          p("For 1 mol ideal gas (water vapour, reference state):"),
          p("$$G(T,P) = G^\\circ - S^\\circ(T-T^\\circ)
                        + RT\\ln\\!\\left(\\frac{P}{P^\\circ}\\right)$$"),
          p("Two fundamental thermodynamic relations appear as slopes:"),
          p("$$\\left(\\frac{\\partial G}{\\partial T}\\right)_P = -S$$"),
          p("$$\\left(\\frac{\\partial G}{\\partial P}\\right)_T =
              V_m = \\frac{RT}{P}$$"),
          hr(),
          sliderInput("T0_gib", HTML("T<sub>0</sub> (K)"),
                      min = 282, max = 375, value = 298, step = 3),
          sliderInput("P0_gib", HTML("P<sub>0</sub> (kPa)"),
                      min = 55, max = 195, value = 100, step = 5),
          hr(),
          p(em("The T-slope is always negative \u2014 entropy \\(S>0\\)
               so \\(\\partial G/\\partial T = -S < 0\\).")),
          p(em("The P-slope curves gently because
               \\(V_m = RT/P\\) decreases as \\(P\\) rises."))
        )
      ),
      mainPanel(width = 9,
        plotlyOutput("surf_gibbs", height = "360px"),
        hr(),
        fluidRow(
          column(6, plotlyOutput("slice_gib_T", height = "310px")),
          column(6, plotlyOutput("slice_gib_P", height = "310px"))
        )
      )
    )
  ),

  # ── Summary ───────────────────────────────────────────────────────────────
  tabPanel("Summary",
    fluidRow(column(10, offset = 1,
      br(),
      h3("Summary"),
      p("A partial derivative is the slope of a surface in one direction,
        with all other variables held fixed."),
      br(),
      tableOutput("summary_table"),
      hr(),
      p("The \\(\\partial\\) symbol and the subscript are both reminders
        that you are ", em("slicing"), " the surface. Conceptually this is
        nothing more than ordinary differentiation applied to a function
        of one variable — the others are just treated as constants.")
    ))
  )
)

# ─────────────────────────────────────────────────────────────────────────────
# Server
# ─────────────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {

  # Static surface for Act 1 (no sliders)
  output$surf_f1_act1 <- renderPlotly({ make_surf_f1() })
  # Reactive 3D plots for Acts 2–4 (pass slider values to show overlays)
  output$surf_f1_act2 <- renderPlotly({ make_surf_f1(input$x0_f1, input$y0_f1) })
  output$surf_gas     <- renderPlotly({ make_surf_gas(input$T0_gas, input$V0_gas) })
  output$surf_gibbs   <- renderPlotly({ make_surf_gibbs(input$T0_gib, input$P0_gib) })

  # Act 2 — reactive slices (recompute whenever sliders move)
  s2 <- reactive({ slices_f1(input$x0_f1, input$y0_f1) })
  output$slice_f1_x <- renderPlotly({ s2()$px })
  output$slice_f1_y <- renderPlotly({ s2()$py })

  # Act 3
  s3 <- reactive({ slices_gas(input$T0_gas, input$V0_gas) })
  output$slice_gas_T <- renderPlotly({ s3()$px })
  output$slice_gas_V <- renderPlotly({ s3()$py })

  # Act 4
  s4 <- reactive({ slices_gibbs(input$T0_gib, input$P0_gib) })
  output$slice_gib_T <- renderPlotly({ s4()$px })
  output$slice_gib_P <- renderPlotly({ s4()$py })

  # Summary table
  output$summary_table <- renderTable({
    data.frame(
      " " = c("Function", "x/T-slice slope  (orange)",
              "y/V-or-P-slice slope  (blue)"),
      "General  f(x, y)" = c(
        "x\u00b2 + y\u00b2",
        "\u2202f/\u2202x = 2x",
        "\u2202f/\u2202y = 2y"
      ),
      "Ideal gas  P(T, V)" = c(
        "nRT/V",
        "(\u2202P/\u2202T)\u1d65 = nR/V",
        "(\u2202P/\u2202V)\u1d68 = \u2212nRT/V\u00b2"
      ),
      "Gibbs energy  G(T, P)" = c(
        "G\u00b0 \u2212 S\u00b0(T\u2212T\u00b0) + RT ln(P/P\u00b0)",
        "(\u2202G/\u2202T)\u209a = \u2212S",
        "(\u2202G/\u2202P)\u1d68 = V\u2098 = RT/P"
      ),
      check.names = FALSE
    )
  }, striped = TRUE, bordered = TRUE, width = "100%", align = "l")
}

shinyApp(ui, server)
