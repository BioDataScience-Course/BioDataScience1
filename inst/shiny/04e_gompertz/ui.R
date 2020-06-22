library(shiny)

titlePanel_h4 <- function(title, windowTitle = title) {
  tagList(tags$head(tags$title(windowTitle)), h4(title))
}

# Define UI for application that draws a histogram
shinyUI(
  navbarPage(
    title = titlePanel_h4("Modèle de Gompertz"),
    tabPanel(
      "Un peu de théorie",
      sidebarLayout(
        sidebarPanel(
          withMathJax(),
          h4("Le Contexte"),
          p("Gompertz a observé de manière empirique que le taux de survie
             décroît souvent de manière proportionnelle au logarithme du
             nombre d’animaux qui survivent. Ce modèle décrit est utilisé pour
             décrire des courbes de survie et des données de croissance."),
          h4("L'équation mathématique :"),
          p("$$Asym \\times e^{- b_{2} \\times b_{3}^x}$$"),
          h4("Eléments importants :"),
          p("- une asymptotes horizontales"),
          p("- un point d'inflection asymétrique"),
          hr(),
          h4("La fonction dans R : "),
          p("$$SSgompertz(x, Asym, b2, b3)$$"),
          h5("Arguments de la fonction : "),
          p("x : est un vecteur de nombre représentant le temps."),
          p("Asym : est la valeur de y représenté par un asymptote
              horizontale."),
          p("b2 : TODO."),
          p("b3 : TODO."),
          width = 5
        ),
        mainPanel(
          p("Le graphique ci-dessous représente le modèle de Gompertz avec
             Asym = 0.95, b2 = 5, b3 = 0.5"),
          plotOutput("gomp_theo"),
          width = 7
        )
      )
    ),
    tabPanel(
      title = "A toi de jouer !",
      sidebarLayout(
        sidebarPanel(
          withMathJax(),
          p("Le modèle de Gompertz est employé pour décrire des courbes de
              survie et des données de croissance avec un asymptote
              horizontale et un point d'inflection asymétrique."),
          p("L'équation mathématique de la fonction est la
              suivante: $$y = Asym \\times e^{- b_{2} \\times b_{3}^x}$$"),
          numericInput(inputId = "asym_ui", label = "Valeur de Asym (asymptote horizontale)",
                   value = 0.50, min = 0.250, max = 10.00, step = 0.25),
          p("Valeur par défaut : 0.50"),
          numericInput(inputId = "b2_ui", label = "Valeur de b2",
                       value = 1.00, min = 0.25, max = 10.00, step = 0.25),
          p("Valeur par défaut : 1"),
          numericInput(inputId = "b3_ui", label = "Valeur de b3",
                   value = 1.00, min = 0.25, max = 10.00, step = 0.25),
          p("Valeur par défaut : 1")
        ),
        mainPanel(
          h4("Ajustez le meilleur modèle de Gompertz"),
          p("Vous devez ajuster votre modèle en faisant varier les
              paramètres du modèle."),
          plotOutput("gomp_plot"),
          hr(),
          withMathJax(),
          uiOutput("gomp_model"),
          hr(),
          uiOutput("gomp_resid"),
          hr()
        )
      )
    )
  )
)
