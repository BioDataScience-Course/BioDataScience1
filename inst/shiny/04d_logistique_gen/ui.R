library(shiny)

titlePanel_h4 <- function(title, windowTitle = title) {
  tagList(tags$head(tags$title(windowTitle)), h4(title))
}

# Define UI for application that draws a histogram
shinyUI(
  navbarPage(
    title = titlePanel_h4("Modèle logistique généralisé"),
    tabPanel(
      "Un peu de théorie",
      sidebarLayout(
        sidebarPanel(
          withMathJax(),
          h4("Le Contexte"),
          p("Le modèle logistique généralisé est une version généralisée du
              modèle logistique qui admet 4 paramètres. Il est possible avec ce
              modèle de faire varier les deux asymptotes."),
          h4("L'équation mathématique :"),
          p("$$\\frac{A + (B-A)}{1 + e^{\\frac{xmid - input}{scal}}}$$"),
          h4("Eléments importants :"),
          p("- une croissance exponentielle"),
          p("- deux asymptotes horizontales variables"),
          hr(),
          h4("La fonction dans R : "),
          p("$$SSfpl(input, A, B, xmid, scal)$$"),
          h5("Arguments de la fonction : "),
          p("input: est un vecteur de nombre représentant le temps."),
          p("A : est la valeur minimale de y représenté par un asymptote
              horizontale."),
          p("B : est la valeur maximale de y représenté par un asymptote
              horizontale."),
          p("xmid : est la valeur de input pour y = (B+A)/2"),
          p("scal: exprime la vitesse de croissance. une valeur faible de scal
              indique une vitesse lente et un faible valeur de scal indique une
               vitesse élevé"),
          width = 5
        ),
        mainPanel(
          p("Le graphique ci-dessous représente une courbe logistique généralisé avec
             A = 0.15, B = 0.95, xmid = 5, scal = 1"),
          plotOutput("logis_gen_theo"),
          width = 7
        )
      )
    ),
    tabPanel(
      title = "A toi de jouer !",
      sidebarLayout(
        sidebarPanel(
          withMathJax(),
          p("La courbe logistique généralisée permet de modéliser des
             croissances exponentielles avec la présence de deux asymptotes
            horizontales variables"),
          p("L'équation mathématique de la fonction est la
              suivante: $$y = \\frac{A + (B-A) }{1 + e^{\\frac{xmid - input}{scal}}}$$"),
          numericInput(inputId = "a_ui", label = "Valeur de A (asymptote horizontale basse)",
                   value = 0.50, min = 0.250, max = 10.00, step = 0.25),
          p("Valeur par défaut : 0.50"),
          numericInput(inputId = "b_ui", label = "Valeur de B (asymptote horizontale haute)",
                       value = 1.00, min = 0.25, max = 10.00, step = 0.25),
          p("Valeur par défaut : 1"),
          numericInput(inputId = "xmid_ui", label = "Valeur de xmid",
                   value = 1.00, min = 0.25, max = 10.00, step = 0.25),
          p("Valeur par défaut : 1"),
          numericInput(inputId = "scal_ui", label = "Valeur de scal",
                       value = 1.00, min = 0.25, max = 10.00, step = 0.25),
          p("Valeur par défaut : 1")
        ),
        mainPanel(
          h4("Ajustez le meilleur modèle logistique"),
          p("Vous devez ajuster votre modèle en faisant varier les
              paramètres du modèle."),
          plotOutput("logis_gen_plot"),
          hr(),
          withMathJax(),
          uiOutput("logis_gen_model"),
          hr(),
          uiOutput("logis_gen_resid"),
          hr()
        )
      )
    )
  )
)
