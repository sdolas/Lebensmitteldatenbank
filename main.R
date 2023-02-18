librarian::shelf("rvest", "RSelenium", "dplyr", "stringr")

format_strToNum <- function(df, col=2) {
  tmp <- df[, col] |>  unlist() |> as.character()
  swapped_strings <- gsub("\\.", "", tmp) 
  swapped_strings <- gsub(",", ".", swapped_strings)
  df[, col] <- gsub(".*?(\\d+[,.]\\d+).*", "\\1", swapped_strings) |>  as.numeric()
  return(df)
}

merge_rownames <- function(A, rnames){
  B <- data.frame(X1=rnames, X2=0)
  df <- merge(A, B, by = "X1", all = T)
  df <- df[!is.na(df[,3]),c(1,2)]
  df[,1] <- rnames
  df[is.na(df$X2.x),2] = 0
  names(df) <- c("X1", "X2")
  return(df)
}


# lade die url-liste
urls <- read.csv("urls.csv")

# lade die alten Tabellen
makros <- read.csv2("Tabellen/makros.csv", check.names = F)
vitamine <- read.csv2("Tabellen/vitamine.csv", check.names = F)
mineralstoffe <- read.csv2("Tabellen/mineralstoffe.csv", check.names = F)
spurenelemente <- read.csv2("Tabellen/spurenelemente.csv", check.names = F)
kohlenhydrate <- read.csv2("Tabellen/kohlenhydrate.csv", check.names = F)
aminos <- read.csv2("Tabellen/aminos.csv", check.names = F)
ballaststoffe <- read.csv2("Tabellen/ballaststoffe.csv", check.names = F)
fette <- read.csv2("Tabellen/fette.csv", check.names = F, encoding = "ASCII")
names(fette) <- gsub("<U\\+03C9>", replacement = "omega", names(fette))


# Initializes the progress bar
pb <- winProgressBar(title="Windows progress bar",
                     label="Percentage completed",
                     min = 0,                # Minimum value of the progress bar
                     max = length(urls$URL), # Maximum value of the progress bar
                     initial = 0,              # Progress bar style (also available style = 1 and style = 2)
                     width = 300L)             # Character used to create the bar

i <- 0
for(url in urls$URL){

  # progress bar
  i <- i + 1
  pctg <- paste(round(i/length(urls$URL) *100, 0), "% completed")
  setWinProgressBar(pb, i, label = pctg)
  
  # teste ob error-URL
  if (httr::http_error(url)){next}
  
  # wenn die Anzahl der Tabellen sich von allen anderen unterscheidet, ignoriere 
  # da format nicht einheitlich
  if (length(read_html(url) |> html_nodes("table")) != 12 ){next}
  
  # Name und Kategorie des Lebensmittels laden
  name <- html_nodes(read_html(url), "h2")[1] |> html_text()
  kategorie <- html_nodes(read_html(url), "a")[16] |> html_text()
  
  # skip, wenn name in Tabelle
  if (name %in% makros$name){next}
  
  # Tabellen von der Seite laden
  tables <- read_html(url) |> html_nodes("table") 
  
  ### Makronährwerte in g
  t2 <- html_table(tables[[2]])[,c(1,2)] |> 
    filter(!(grepl("Tagesbedarf", X1)) & 
             !(grepl("Broteinheiten", X1)) & 
             X1 != "") |> format_strToNum()
  t2 <- rbind(c("name",name), c("Kategorie", kategorie), t2)
  t2 <- t2$X2 |> t() |> data.frame() |> `colnames<-`(names(makros))
  t2[,-c(1, 2)] <- apply(t2[,-c(1, 2)], 2, as.numeric)
  
  
  ### Vitamine in mikrogramm
  t5 <- html_table(tables[[5]])[,c(1,2)] |> 
    filter(!(grepl("Tagesbedarf", X1)) & X1 != "") |> 
    format_strToNum() |> merge_rownames(names(vitamine)[-1])
  t5 <- rbind(c("name",name), t5)
  t5 <- t5$X2 |> t() |> data.frame() |> `colnames<-`(names(vitamine)) 
  t5[,-1] <- apply(t5[,-1], 2, as.numeric)
  
  ### Sechste Tabelle: Mineralstoffe in mg
  t6 <- html_table(tables[[6]])[,c(1,2)] |> 
    filter(!(grepl("Tagesbedarf", X1)) & 
             X1 != "") |> format_strToNum() |> merge_rownames(names(mineralstoffe)[-1])
  t6 <- rbind(c("name",name), t6)
  t6 <- t6$X2 |> t() |> data.frame() |> `colnames<-`(names(mineralstoffe)) 
  t6[,-1] <- apply(t6[,-1], 2, as.numeric)
  
  ### Spurenelemente in mikrogramm
  t7 <- html_table(tables[[7]])[,c(1,2)] |> 
    filter(!(grepl("Tagesbedarf", X1)) & 
             !(grepl("Richtwert", X1)) & 
             X1 != "") |> format_strToNum() |> merge_rownames(names(spurenelemente)[-1])
  t7 <- rbind(c("name",name), t7)
  t7 <- t7$X2 |> t() |> data.frame() |> `colnames<-`(names(spurenelemente)) 
  t7[,-1] <- apply(t7[,-1], 2, as.numeric)
  
  ### Kohlenhydrate
  t8 <- html_table(tables[[8]])[,c(1,2)] |> 
    filter(!(grepl("Broteinheiten", X1)) & 
             !(grepl("Tagesbedarf", X1)) & 
             !(grepl("Richtwert", X1)) & 
             X1 != "") |> format_strToNum() |> merge_rownames(names(kohlenhydrate)[-1])
  t8 <- rbind(c("name",name), t8)
  t8 <- t8$X2 |> t() |> data.frame() |> `colnames<-`(names(kohlenhydrate)) 
  t8[,-1] <- apply(t8[,-1], 2, as.numeric)
  
  ### Aminosäuren in mg
  t9 <- html_table(tables[[9]])[,c(1,2)] |> 
    filter(!(grepl("Tagesbedarf", X1)) & 
             !(grepl("Richtwert", X1)) & 
             X1 != "") |> format_strToNum() |> merge_rownames(names(aminos)[-1])
  t9 <- rbind(c("name",name), t9)
  t9 <- t9$X2 |> t() |> data.frame() |> `colnames<-`(names(aminos)) 
  t9[,-1] <- apply(t9[,-1], 2, as.numeric)
  
  ### Ballaststoffe in mg
  t10 <- html_table(tables[[10]])[,c(1,2)] |> 
    filter(!(grepl("Tagesbedarf", X1)) & 
             !(grepl("Richtwert", X1)) & 
             X1 != "") |> format_strToNum() |> merge_rownames(names(ballaststoffe)[-1])
  t10 <- rbind(c("name",name), t10)
  t10 <- t10$X2 |> t() |> data.frame() |> `colnames<-`(names(ballaststoffe)) 
  t10[,-1] <- apply(t10[,-1], 2, as.numeric)
  
  ### Alle Fettsäuren in mg
  t12 <- html_table(tables[[12]])[,c(1,2)] |> 
    filter(!(grepl("Tagesbedarf", X1)) & 
             !(grepl("Richtwert", X1)) & 
             X1 != "") |> format_strToNum() |> merge_rownames(names(fette)[-1])
  t12 <- rbind(c("name",name), t12)
  t12 <- t12$X2 |> t() |> data.frame() |> `colnames<-`(names(fette)) 
  t12[,-1] <- apply(t12[,-1], 2, as.numeric)
  
  # verbinde alte und neue df
  makros <- rbind(makros, t2) |> unique()
  vitamine <- rbind(vitamine, t5) |> unique()
  mineralstoffe <- rbind(mineralstoffe, t6) |> unique()
  spurenelemente <- rbind(spurenelemente, t7) |> unique()
  kohlenhydrate <- rbind(kohlenhydrate, t8) |> unique()
  aminos <- rbind(aminos, t9) |> unique()
  ballaststoffe <- rbind(ballaststoffe, t10) |> unique()
  fette <- rbind(fette, t12) |> unique()

}
close(pb) # Close the connection


# speichere die Tabellen
write.csv2(makros, "Tabellen/makros.csv", fileEncoding = "latin1", row.names = F)
write.csv2(vitamine, "Tabellen/vitamine.csv", fileEncoding = "latin1", row.names = F)
write.csv2(mineralstoffe, "Tabellen/mineralstoffe.csv", fileEncoding = "latin1", row.names = F)
write.csv2(spurenelemente, "Tabellen/spurenelemente.csv", fileEncoding = "latin1", row.names = F)
write.csv2(kohlenhydrate, "Tabellen/kohlenhydrate.csv", fileEncoding = "latin1", row.names = F)
write.csv2(aminos, "Tabellen/aminos.csv", fileEncoding = "latin1", row.names = F)
write.csv2(ballaststoffe, "Tabellen/ballaststoffe.csv", fileEncoding = "latin1", row.names = F)
write.csv2(fette, "Tabellen/fette.csv", fileEncoding = "latin1", row.names = F)

