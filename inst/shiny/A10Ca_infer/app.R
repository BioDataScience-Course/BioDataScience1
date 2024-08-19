# Input solution for the challenge and get ranking
# ================================================
# Note: the shared folder is created like this using SSH onto the server
# cd /data1
# sudo mkdir A12_challenge
# sudo chown rstudio-connect: A12_challenge

# We also need flipdown from:
#remotes::install_github("feddelegrand7/flipdownr")

library(data.io)
library(RSQLite)
library(flipdownr)

# Indicate title and deadline here
title <- "Challenge tests d'hypothèses"
# Note: define real deadline in environment variables in RStudio Connect
deadline <- Sys.getenv("CHALLENGE_DEADLINE",
  unset = "2024-05-09 00:00:00")

# Read data from the SQLite database
dir <- "/data1/A12_challenge"
if (!file.exists(dir))
  dir <- "~/Desktop/A12_challenge" # Alternate dir for local tests
database <- file.path(dir, "infer.sqlite")
table <- "infer"

# Is the countdown over?
is_done <- function()
  as.POSIXct(deadline) < Sys.time()

# If the time difference between current date and countdown
# is more than 100 days, we consider the next challenge has not started yet
not_started_yet <- function()
  difftime(Sys.time(), as.POSIXct(deadline), units = "days") > 100

# The function that calculates score and returns also a message
score_infer <- function(x) {
  if (!is.numeric(x) | length(x) != 10)
    return(structure(NA,
      message = "Le fichier doit contenir un vecteur numérique de longueur 10. Corrigez et resoumettez !"))
  x[x < 0] <- 0
  x[x > 1] <- 1
  #if (any(x < 0) | any(x > 1))
  #  return(structure(NA,
  #    message = paste("Le r\u00e9sultat doit contenir des valeurs entre 0 et 1 uniquement. Corrigez et resoumettez !")))
  score <- as.numeric(sum(x)) # Score is the sum of all the 10 individual scores for the different items
  structure(score,
    message = paste0("Votre proposition est accept\u00e9e. Son score est de ",
      round(score, 1), "."))
}

# Manage results into the SQLite database
empty_data <- function()
  data.frame(project = character(0), model = character(0),
    date = as.POSIXct(character(0)), score = numeric(0))

save_data <- function(data) {
  # Connect to the database
  db <- dbConnect(SQLite(), database)
  # Make sure table exists in the database
  try(dbWriteTable(db, table, empty_data()), silent = TRUE)
  # Construct the update query by looping over the data fields
  query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s')",
    table,
    paste(names(data), collapse = ", "),
    paste(data, collapse = "', '")
  )
  # Submit the update query and disconnect
  dbSendStatement(db, query)
  dbDisconnect(db)
}

load_data <- function() {
  # Connect to the database
  db <- dbConnect(SQLite(), database)
  # Construct the fetching query
  query <- sprintf("SELECT * FROM %s", table)
  # Submit the fetch query and disconnect
  data <- try(dbGetQuery(db, query), silent = TRUE)
  dbDisconnect(db)
  if (inherits(data, "try-error")) {
    empty_data()
  } else {
    data
  }
}

ui <- fluidPage(
  titlePanel(title),

  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Votre proposition (fichier RDS)", accept = ".rds"),
      textOutput("message"),
      hr(),
      actionButton("refresh", "Actualiser le classement")
    ),
    mainPanel(
      h3("Temps restant pour le challenge :"),
      flipdown(downto = deadline, id = "csfrench", theme = "dark",
        headings = c("jours", "heures", "minutes", "secondes")),
      hr(),
      h3("Classement :"),
      tableOutput("ranking")
    )
  )
)

server <- function(input, output) {
  output$message <- renderText({
    file <- input$file
    ext <- tools::file_ext(file$datapath)
    req(file)
    validate(need(ext == "rds", "Vous devez indiquer un fichier RDS"))
    # Check that there is still time remaining
    if (is_done()) {
      if (not_started_yet()) {
        "Ce challenge n'a pas encore commenc\u00e9, attendez le d\u00e9part !"
      } else {
        "Ce challenge est fini, vous ne pouvez plus soumettre de proposition !"
      }
    } else {
      # Check that filename is correct (repos__model.rds)
      if (!grepl("^.+__.+\\.rds", file$name)) {
        "Le nom de votre fichier est incorrect : il faut <repos>__<iteration>.rds. Corrigez et resoumettez."
      } else {
        #solution <- data.io::read$rds(file$datapath)$value
        solution <- data.io::read$rds(file$datapath)
        # Check if a model of the same name already exists
        name <- file$name
        project <- sub("(^.+)__.+$", "\\1", name)
        model <- sub(("^.+__(.+)\\.rds$"), "\\1", name)
        ranking <- load_data()
        if (NROW(ranking[ranking$project == project & ranking$model == model, ])) {
          "Cette it\u00e9ration existe dans le classement, recompilez le document avant de soumettre une nouvelle variante."
        } else {
          attr(score_infer(solution), "message")
        }
      }
    }
  })

  output$ranking <- renderTable({
    input$refresh # Trigger this code when the refresh button is clicked
    file <- input$file
    if (!is.null(file$datapath) && grepl("^.+__.+\\.rds", file$name) &&
        !is_done()) {
      #solution <- data.io::read$rds(file$datapath)$value
      solution <- data.io::read$rds(file$datapath)
      message("data read")
      score <- score_infer(solution)
      message("score is ", score)
      name <- file$name
      message("name is ", name)
      project <- sub("(^.+)__.+$", "\\1", name)
      model <- sub(("^.+__(.+)\\.rds$"), "\\1", name)
      if (project == name) {
        message("Wrong name!")
        score <- NA
      }
    } else {
      score <- NA
    }
    ranking <- load_data()
    message("Data loaded")
    # Record an entry in the mongoDB database
    # But we need the login of *all* members of the team, and we don't have them
    # right now => leave this to a post-process task instead!
    if (!is.na(score)) {
      # Check if it is not submitted yet
      if (!NROW(ranking[ranking$project == project & ranking$model == model, ])) {
        save_data(list(
          project = project, model = model, date = Sys.time(),
          score = as.numeric(score)
        ))
        # Reload the full dataset
        ranking <- load_data()
      }
    }
    # Rework the ranking table
    if (NROW(ranking)) {
      ranking <- ranking[order(-ranking$score, as.numeric(ranking$date)), ]
      ranking$date <- as.POSIXct(ranking$date, origin = "1960-01-01")
      ranking$date <- format(ranking$date, "%Y-%m-%d %H:%M:%S")
    }
    message("Date reworked")
    # Add a column with medals for the three first results
    n <- NROW(ranking)
    if (n == 0) {
      medals <- character(0)
    } else {
      medals <- c("\U1F947", "\U1F948", "\U1F949")
      if (n < 4) {
        medals <- medals[1:n]
      } else {
        medals <- c(medals, rep("", n - 3))
      }
    }
    ranking <- data.frame(rank = medals, ranking)
    message("Ranking done")
    names(ranking) <- c("", "Projet", "It\u00e9ration", "Date", "Score")
    ranking
  })
}

shinyApp(ui, server)
