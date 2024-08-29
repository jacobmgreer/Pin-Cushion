required <- c("rvest", "tidyverse", "magrittr", "jsonlite", "qdapRegex", 
              "fuzzyjoin", "readr", "tools", "textutils", "purrr", "plyr", "magick")
lapply(required, require, character.only = TRUE)

pins <- NULL
for (i in list.files("formatted_exports")) {

  pins <-
    bind_rows(pins,
      read_html(
        paste0("formatted_exports/", i), encoding="UTF-8") %>%
        html_nodes('dt a') %>%
        map_df(~{
          image <- .x %>% html_attr("image")
          guid <- .x %>% html_attr("guid")
          color <- .x %>% html_attr("color")
          tibble(image, guid, color)
        }) %>%
        mutate(
          board =
            read_html(file.path(paste0("formatted_exports/", i)), encoding="UTF-8") %>%
            html_element('h3') %>%
            html_text,
          board_link =
            read_html(file.path(paste0("formatted_exports/", i)), encoding="UTF-8") %>%
            html_element('h3') %>%
            html_attr("origlink"),
          folder =
            sub("\\:.*", "",
            read_html(file.path(paste0("formatted_exports/", i)), encoding="UTF-8") %>%
              html_element('h3') %>%
              html_text),
          folder_board =
            path_sanitize(
              sub(".*: ", "",
                  read_html(file.path(paste0("formatted_exports/", i)), encoding="UTF-8") %>%
                    html_element('h3') %>%
                    html_text
              )
            ))
    )
}

arr_folders <-
  pins %>%
  dplyr::count(folder)

for (i in arr_folders$folder) {
  if(!file.exists(file.path("output", i))) {
    dir.create(file.path("output", i))
  }
}

arr_boards <-
  pins %>%
  dplyr::count(folder, folder_board)

for (i in 1:nrow(arr_boards)) {
  if (!file.exists(file.path(paste0("output/", arr_boards$folder[i], "/", arr_boards$folder_board[i])))) {
    dir.create(file.path(paste0("output/", arr_boards$folder[i], "/", arr_boards$folder_board[i])))
  }
}


for (pin in 1:nrow(pins)) {
  if(!file.exists(paste0("output/", pins$folder[pin], "/", pins$folder_board[pin], "/", basename(pins$image[pin])))) {
    tryCatch(
      download.file(
        pins$image[pin],
        paste0("output/", pins$folder[pin], "/", pins$folder_board[pin], "/", basename(pins$image[pin])),
        mode = "wb",
        quiet = FALSE),
      error =
        function(e)
          print(paste(pin, 'did not work out'))
    )
  }
}

rm(i, required, pin)
