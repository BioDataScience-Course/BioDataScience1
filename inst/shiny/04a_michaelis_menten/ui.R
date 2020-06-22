library(shiny)

titlePanel_h4 <- function(title, windowTitle = title) {
  tagList(tags$head(tags$title(windowTitle)), h4(title))
}

# Define UI for application that draws a histogram
shinyUI(
  navbarPage(
    title = titlePanel_h4("Modèle de Michaelis-Menten"),
    tabPanel(
      "Un peu de théorie",
      sidebarLayout(
        sidebarPanel(
          withMathJax(),
          h4("Le Contexte"),
          p("La courbe de Michaelis-Menten est bien connue pour modéliser des
            cinétiques chimiques simples, enzymatiques en particulier."),
          h4("L'équation mathématique :"),
          p("$$\\frac{V_{m} * input}{K + input}$$"),
          h4("Eléments importants :"),
          p("- une asymptote horizontale qui correspond à la vitesse
              maximale asymptotique de la réaction"),
          hr(),
          h4("La fonction dans R : "),
          p("$$SSmicmen(input, Vm, K)$$"),
          h5("Arguments de la fonction : "),
          p("Vm : est la vitesse maximale de la réaction"),
          p("K : est la valeur de x pour la Vm/2"),
          width = 5
        ),
        mainPanel(
          p("Le graphique ci-dessous représente un modèle Michaelis-Menten avec
              Vm = 1 et K = 0.4. Le trait horizontal en Vm = 1 représente la
              vitesse maximale possible (asymptote horizontale du modèle)."),
          plotOutput("micmen_theo"),
          width = 7
        )
      )
    ),
    tabPanel(
      title = "A toi de jouer !",
      sidebarLayout(
        sidebarPanel(
          withMathJax(),
          p("La courbe de Michaelis-Menten permet de modéliser des cinétiques
              chimiques simple. Nous pouvons utiliser la fonction
              SSmicmen(input, Vm, K) dans R."),
          p("L'équation mathématique de la fonction est la
              suivante: $$\\frac{V_{m} * input}{K + input}$$"),
          numericInput(inputId = "vm_ui", label = "Valeur de Vm",
                   value = 1.00, min = 0.50, max = 10.00, step = 0.5),
          p("Valeur par défaut : 1 "),
          numericInput(inputId = "k_ui", label = "Valeur de K",
                   value = 1.00, min = 0.50, max = 10.00, step = 0.5),
          p("Valeur par défaut : 1 ")
        ),
        mainPanel(
          h4("Ajustez le meilleur modèle de Michaelis-Menten"),
          p("Vous devez ajuster votre modèle en faisant varier les
              paramètres du modèle."),
          plotOutput("trees_plot"),
          hr(),
          withMathJax(),
          uiOutput("micmen_model"),
          hr(),
          uiOutput("micmen_resid"),
          hr()
        )
      )
    )
  )
)
