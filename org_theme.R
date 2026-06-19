# ==============================================================================
# org_theme.R
# Organization bslib theme for R Markdown / Quarto HTML output
# ==============================================================================
#
# Usage in an .Rmd YAML header:
#
#   output:
#     html_document:
#       theme: !expr source("org_theme.R")$value
#
# (source()'s $value is the value of the last top-level expression
#  evaluated in the file, i.e. the org_theme object itself — see the
#  final assignment near the bottom of this script.)
#
# Or in a setup chunk, then reference `org_theme` directly for charts:
#
#   source("org_theme.R")
#   ggplot(...) + scale_fill_manual(values = org_pal(4))
#
# Requires: bslib (>= 0.5.0)
# ==============================================================================

library(bslib)

# ------------------------------------------------------------------------
# 1. Brand palette (named vector — single source of truth)
# ------------------------------------------------------------------------
org_palette <- c(
  burnt_orange       = "#ed6e3b",
  terracotta         = "#bd572f",
  marigold           = "#f99d46",

  white              = "#FFFFFF",
  light_grey         = "#ebebeb",
  slate_grey         = "#969698",
  charcoal           = "#57595a",
  black              = "#000000",

  plum_purple        = "#623a70",
  blueberry          = "#3f6192",
  leafy_green        = "#718b4a",
  earthy_gold        = "#aa7e3c",

  dark_plum_purple   = "#30193b",
  dark_blueberry     = "#273447",
  dark_leafy_green   = "#405028",
  dark_earthy_gold   = "#725528",

  light_plum_purple  = "#cc9ede",
  light_blueberry    = "#9bbae5",
  light_leafy_green  = "#a1d487",
  light_earthy_gold  = "#c0a37c"
)

# ------------------------------------------------------------------------
# 2. Categorical palette for charts (ggplot, plotly, DT, etc.)
#    Base hues first, then their dark/light variants for extended series.
# ------------------------------------------------------------------------
org_palette_categorical <- unname(org_palette[c(
  "plum_purple", "blueberry", "leafy_green", "earthy_gold",
  "burnt_orange", "terracotta", "marigold", "slate_grey"
)])

org_palette_extended <- unname(org_palette[c(
  "plum_purple",       "dark_plum_purple",  "light_plum_purple",
  "blueberry",         "dark_blueberry",    "light_blueberry",
  "leafy_green",       "dark_leafy_green",  "light_leafy_green",
  "earthy_gold",       "dark_earthy_gold",  "light_earthy_gold"
)])

# Sequential palette example (single hue, light -> dark), handy for heatmaps
org_palette_sequential_blueberry <- c(
  org_palette[["light_blueberry"]],
  org_palette[["blueberry"]],
  org_palette[["dark_blueberry"]]
)

# Convenience helper, e.g. org_pal(5) -> first 5 categorical colors,
# recycled with extended set if more are needed
org_pal <- function(n) {
  pal <- c(org_palette_categorical, org_palette_extended)
  if (n > length(pal)) {
    warning("Requested more colors than defined in the palette; colors will repeat.")
  }
  rep(pal, length.out = n)
}

# ------------------------------------------------------------------------
# 3. bslib theme
# ------------------------------------------------------------------------
# Mapping rationale:
#   primary   - Burnt Orange   (core brand color, links/buttons/headers)
#   secondary - Charcoal       (neutral UI accents)
#   success   - Leafy Green
#   info      - Blueberry
#   warning   - Marigold
#   danger    - Terracotta
#   light     - Light Grey     (panel backgrounds, code blocks)
#   dark      - Charcoal
#   bg/fg     - White on Black/Charcoal text (light theme)

org_theme <- bs_theme(
  version      = 5,
  bg           = "#FFFFFF",
  fg           = org_palette[["black"]],

  primary      = org_palette[["burnt_orange"]],
  secondary    = org_palette[["charcoal"]],
  success      = org_palette[["leafy_green"]],
  info         = org_palette[["blueberry"]],
  warning      = org_palette[["marigold"]],
  danger       = org_palette[["terracotta"]],
  light        = org_palette[["light_grey"]],
  dark         = org_palette[["charcoal"]],

  base_font    = "fonts/aptos-light.ttf",
  heading_font = "fonts/aptos-regular.ttf",
  code_font    = font_google("Source Code Pro"),

  "border-radius"        = "0.375rem",
  "btn-border-radius"    = "0.375rem",
  "navbar-bg"             = org_palette[["charcoal"]]
)

# ------------------------------------------------------------------------
# 4. Extra CSS tweaks not exposed as Sass variables
#    (headings, code blocks, links, tables, TOC, blockquotes)
# ------------------------------------------------------------------------
org_theme <- bs_add_rules(org_theme, "
  h1, h2, h3 {
    font-weight: 600;
  }
  h1 { color: #30193b; border-bottom: 3px solid #ed6e3b; padding-bottom: 0.3rem; }
  h2 { color: #57595a; }

  a { color: #bd572f; }
  a:hover { color: #ed6e3b; }

  pre, code { background-color: #ebebeb; }

  blockquote {
    border-left: 4px solid #f99d46;
    color: #57595a;
    background-color: #ebebeb;
    padding: 0.5rem 1rem;
  }

  table.table thead th {
    background-color: #57595a;
    color: #FFFFFF;
  }

  #TOC {
    border-right: 1px solid #ebebeb;
  }

  .nav-pills .nav-link.active {
    background-color: #ed6e3b !important;
  }
")

# ------------------------------------------------------------------------
# 5. Quick visual preview (run interactively, not during knit)
# ------------------------------------------------------------------------
# bslib::bs_theme_preview(org_theme)
