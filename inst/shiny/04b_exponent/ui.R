library(shiny)

titlePanel_h4 <- function(title, windowTitle = title) {
  tagList(tags$head(tags$title(windowTitle)), h4(title))
}

# Define UI for application that draws a histogram
shinyUI(
  navbarPage(
    title = titlePanel_h4("Courbe exponentielle"),
    tabPanel(
      "Un peu de théorie",
      sidebarLayout(
        sidebarPanel(
          withMathJax(),
          h4("Le Contexte"),
          p("En 1798, Thomas Malthus a décrit un modèle de croissance avec une
              des caractéristiques les plus fondamentales de la croissance :
              son caractère exponentiel (positive ou négative)."),
          h4("L'équation mathématique :"),
          p("$$y(t) = y_0 \\ e^{k \\ t}$$"),
          h4("Eléments importants :"),
          p("- une croissance exponentielle"),
          hr(),
          h4("La fonction dans R : "),
          p("$$exponent(x, y0, k)$$"),
          p("Note: la fonction exponent() n'est pas implémenté dans R.
              Vous devez l'écrire vous même $$exponent <- function(x, y0, k)$$
              $$y0 * exp(k * x)$$"),
          h5("Arguments de la fonction : "),
          p("x: vecteur de nombre représentant le temps"),
          p("y0 : la taille initiale de la population au temps t0"),
          p("k : est le taux de croissance"),
          width = 5
        ),
        mainPanel(
          p("Le graphique ci-dessous représente un modèle de croissance
              exponentiel avec y0 = 1.5 et k = 0.9 "),
          plotOutput("expo_theo"),
          width = 7
        )
      )
    ),
    tabPanel(
      title = "A toi de jouer !",
      sidebarLayout(
        sidebarPanel(
          withMathJax(),
          p("La courbe exponentielle permet de modéliser des croissances
             exponentielles. ce modèle n’est plus guère utilisé
             actuellement, mais son importance historique ne doit pas
              être négligée"),
          p("L'équation mathématique de la fonction est la
              suivante: $$y(t) = y_0 \\ e^{k \\ t}$$"),
          numericInput(inputId = "y0_ui", label = "Valeur de y0",
                   value = 1.00, min = 0.50, max = 10.00, step = 0.5),
          p("Valeur par défaut : 1 "),
          numericInput(inputId = "k_ui", label = "Valeur de k",
                   value = 1.00, min = 0.50, max = 5.00, step = 0.25),
          p("Valeur par défaut : 1 ")
        ),
        mainPanel(
          h4("Ajustez le meilleur modèle exponentiel"),
          p("Vous devez ajuster votre modèle en faisant varier les
              paramètres du modèle."),
          plotOutput("exo_plot"),
          hr(),
          withMathJax(),
          uiOutput("expo_model"),
          hr(),
          uiOutput("expo_resid"),
          hr()
        )
      )
    )
  )
)
