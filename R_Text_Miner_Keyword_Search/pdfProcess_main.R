# R-version: 3.5.3
# author: Ripunjoy Gohain
# mail: ripunjoy.gohain79@gmail.com
# date: 2019-06-29

### Searcgh through all the pdf files in a directory, and prepare a excel file showing the page number, keyword etc.

# CHECK REQUIREMENTS
req_packages <- c("pdftools", "pdfsearch", "tesseract", "rlang", "stringr")
available_status <- req_packages[!(req_packages %in% installed.packages())]
if (length(available_status)) {
  print(c("Installing missing packages: ", available_status))
  install.packages(available_status)
}
# IMPORT LIBRARIES
library(pdftools)
library(pdfsearch)
library(XLConnect)
library(tesseract)
library(stringr)

# DEFINE FUNCTION
# TODO: It currently works only on main directory pdf files, need to extend for sub directories
pdf_keyword_search <- function(folder_path, list_keywords, dpi_value = 600){
  case_ignore_list <- replicate(length(list_keywords), TRUE)
  files_list = list.files(path = folder_path, pattern = ".pdf")
  main_df = data.frame()
  for (i in 1:length(files_list)) {
    this_pdf = files_list[i]
    this_pdf_url = paste(folder_path, this_pdf, sep = "/")
    read_this_pdf <- pdftools::pdf_text(this_pdf_url)
    total_char = nchar(paste(read_this_pdf, collapse = ''))
    if (total_char > 0) {
      # character greater than 0 means it abled to read the pdf
      this_df <- pdfsearch::keyword_search(read_this_pdf, keyword = list_keywords, ignore_case = case_ignore_list)
      if (nrow(this_df) > 0) {
        this_df <- subset(this_df, select = -token_text)
        this_df <- cbind(pdf_name = this_pdf, this_df)
        main_df <- rbind(main_df, this_df)
      }
    } else {
      this_df <- data.frame()
      file_string <- stringr::str_replace(string = this_pdf, pattern = ".pdf", replacement = "")
      total_page <- pdf_info(this_pdf_url)$pages
      pdftools::pdf_convert(this_pdf_url, dpi = dpi_value)
      # total_page <- 1
      # pdftools::pdf_convert(this_pdf_url, dpi = dpi_value, pages = 15)
      for (p in 1:total_page) {
        png_name <- paste(paste(file_string, p, sep = "_"), "png", sep = ".")
        text_pdf <- tesseract::ocr(png_name)
        unlink(png_name)
        this_page_df <- pdfsearch::keyword_search(text_pdf, keyword = list_keywords, ignore_case = case_ignore_list)
        if (nrow(this_page_df) > 0) {
          this_page_df <- subset(this_page_df, select = -token_text)
          this_page_df <- cbind(pdf_name = this_pdf, this_page_df)
          this_page_df$page_num = p
          this_df <- rbind(this_df, this_page_df)
        }
      }
      if (nrow(this_df) > 0) {
        main_df <- rbind(main_df, this_df)
      }
    }
    print(paste0("Done: ", this_pdf))
  }
  main_df <- apply(main_df, 2, as.character)
  return(main_df)
}

# PROCESS DF Function
process_keyword_df <- function(df) {
  total_rows <- nrow(df)
  special_pattern <- "\\?|\\||\\-"
  # Process on the sentence
  for (i in 1:total_rows) {
    print(i)
    this_sentence <- df$line_text[i]
    this_sentence <- iconv(this_sentence, "", "ASCII", "byte")
    this_sentence <- stringr::str_trim(this_sentence, side = c("both"))
    this_sentence <- paste0(gsub("^\\.|\\.+$", "", this_sentence), ".")
    total_words <- sapply(strsplit(this_sentence, " "), length)
    header_line = ""
    point_number = ""
    # START PROCESSING IN THE SENTENCE
    for (l in 1:total_words) {
      this_word <- stringr::word(this_sentence, 1)
      this_word_upper <- toupper(this_word)
      # check for number header
      if (grepl("^[0-9.]+$", this_word)) {
        point_number = this_word
        this_length <- nchar(this_word)
        this_sentence <- substring(this_sentence, first = this_length + 2)
      } else {
        # Check for special character
        if (grepl(special_pattern, this_word)) {
          this_length <- nchar(this_word)
          this_sentence <- substring(this_sentence, first = this_length + 2)
        } else {
          # Check for capitals
          if (this_word == this_word_upper) {
            header_line = paste(header_line, this_word, " ")
            this_length <- nchar(this_word)
            this_sentence <- substring(this_sentence, first = this_length + 2)
          } else {
            this_sentence = this_sentence
            header_line = stringr::str_trim(header_line, side = c("both"))
            point_number = point_number
            break
          }
        }
      }
    }
    df$line_text[i] = this_sentence
    df$header[i] = header_line
    df$point_num[i] = point_number
  }
  df$serial_no <- seq.int(nrow(df))
  names(df)[names(df) == "pdf_name"] <- "file_name"
  names(df)[names(df) == "line_text"] <- "text"
  df <- df[c("serial_no", "file_name", "keyword", "header", "point_num", "page_num", "line_num", "text")]
  return(df)
}



###*** PROCESSING ***###
# if windows system, please define the path like this, no need to END it with a forward slash (The program will take care of it)
path = "D:/PDF_Text_R/sample"

list_key = c("Limitation", "Liabilities", "Indemnity", "Indemnification", "Confidentiality", "Intellectual property", "Termination", "Term start", "Term end", "Term commencement", "Term stop", "Background verification", "Third party liability", "Insurance", "Warranty", "Export control", "Terminate", "Termination")

# CALL THE FUNCTION
output_df <- pdf_keyword_search(folder_path = path, list_keywords = list_key, dpi_value = 600)

output_df <- process_keyword_df(df = output_df)

write.csv(output_df, file = "sample_results.csv", row.names = FALSE)
