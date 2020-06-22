library(shiny)

titlePanel_h4 <- function(title, windowTitle = title) {
  tagList(tags$head(tags$title(windowTitle)), h4(title))
}

# Define UI for application that draws a histogram
shinyUI(
  navbarPage(
    title = titlePanel_h4("Courbe logistique"),
    tabPanel(
      "Un peu de théorie",
      sidebarLayout(
        sidebarPanel(
          withMathJax(),
          h4("Le Contexte"),
          p("Le modèle exponentiel qui décrit une croissance infinie sans
              aucunes contraintes n’est pas une hypothèse réaliste. En pratique,
              la croissance est limitée par les ressources disponibles.
              Verhulst (1838) propose un modèle qui tient compte d'une limite
              théorique des ressources disponibles."),
          h4("L'équation mathématique :"),
          p("$$\\frac{Asym}{1 + e^{\\frac{xmid - input}{scal}}}$$"),
          h4("Eléments importants :"),
          p("- une croissance exponentielle"),
          p("- deux asymptotes horizontales en 0 et en Asym"),
          hr(),
          h4("La fonction dans R : "),
          p("$$SSlogis(input, Asym, xmid, scal)$$"),
          h5("Arguments de la fonction : "),
          p("input: est un vecteur de nombre représentant le temps."),
          p("Asym : est la valeur maximale de y représenté par un asymptote
              horizontale."),
          p("xmid : est la valeur de input pour y = Asym/2"),
          p("scal: exprime la vitesse de croissance. une valeur faible de scal
              indique une vitesse lente et un faible valeur de scal indique une
               vitesse élevé"),
          width = 5
        ),
        mainPanel(
          p("Le graphique ci-dessous représente une courbe logistique avec
             Asym = 0.95, xmid = 5, scal = 0.95"),
          plotOutput("logis_theo"),
          width = 7
        )
      )
    ),
    tabPanel(
      title = "A toi de jouer !",
      sidebarLayout(
        sidebarPanel(
          withMathJax(),
          p("La courbe logistique permet de modéliser des croissances
             exponentielles avec la présence de deux asymptotes horizontales"),
          p("L'équation mathématique de la fonction est la
              suivante: $$y = \\frac{Asym}{1 + e^{\\frac{xmid - input}{scal}}}$$"),
          numericInput(inputId = "asym_ui", label = "Valeur de Asym (asymptote horizontale)",
                   value = 1.00, min = 0.50, max = 10.00, step = 0.5),
          p("Valeur par défaut : 1"),
          numericInput(inputId = "xmid_ui", label = "Valeur de xmid",
                   value = 1.00, min = 0.25, max = 10.00, step = 0.25),
          p("Valeur par défaut : 1"),
          numericInput(inputId = "k_ui", label = "Valeur de scal",
                       value = 1.00, min = 0.25, max = 10.00, step = 0.25),
          p("Valeur par défaut : 1")
        ),
        mainPanel(
          h4("Ajustez le meilleur modèle logistique"),
          p("Vous devez ajuster votre modèle en faisant varier les
              paramètres du modèle."),
          plotOutput("logis_plot"),
          hr(),
          withMathJax(),
          uiOutput("logis_model"),
          hr(),
          uiOutput("logis_resid"),
          hr()
        )
      )
    )
  )
)
