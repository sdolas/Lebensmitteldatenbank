librarian::shelf("rvest", "RSelenium", "dplyr", "stringr")

format_strToNum <- function(df, col=2){
  tmp <- df[,col] |> unlist() |> as.character()
  swapped_strings <- gsub("\\.", "", tmp) 
  swapped_strings <- gsub(",", ".", swapped_strings)
  df[,col] <- gsub(".*?(\\d+[,.]\\d+).*", "\\1", swapped_strings) |> as.numeric()
  return(df)
}

  

# lade die url-liste
urls <- read.csv("urls.csv")

# lade die alten Tabellen
makros <- read.csv2("Tabellen/makros.csv", check.names = F, row.names = 1)
vitamine <- read.csv2("Tabellen/vitamine.csv", check.names = F, row.names = 1)
mineralstoffe <- read.csv2("Tabellen/mineralstoffe.csv", check.names = F, row.names = 1)
spurenelemente <- read.csv2("Tabellen/spurenelemente.csv", check.names = F, row.names = 1)
kohlenhydrate <- read.csv2("Tabellen/kohlenhydrate.csv", check.names = F, row.names = 1)
aminos <- read.csv2("Tabellen/aminos.csv", check.names = F, row.names = 1)
ballaststoffe <- read.csv2("Tabellen/ballaststoffe.csv", check.names = F, row.names = 1)
fette <- read.csv2("Tabellen/fette.csv", check.names = F, row.names = 1, encoding = "ASCII")
names(fette) <- gsub("<U\\+03C9>", replacement = "omega", names(fette))

for(url in urls$URL){
  
  # Name des Lebensmittels laden
  name <- html_nodes(read_html(url), "h2")[1] |> html_text()
  
  # Tabellen laden
  tables <- read_html(url) |> html_nodes("table") 
  
  ### Makronährwerte in 
  t2 <- html_table(tables[[2]])[,c(1,2)] |> 
    filter(!(grepl("Tagesbedarf", X1)) & 
             !(grepl("Broteinheiten", X1)) & 
             X1 != "") |> format_strToNum()
  t2 <- t2$X2 |> t() |> data.frame(row.names=name) |> `colnames<-`(names(makros)) 
  
  
  ### Vitamine in mikrogramm
  t5 <- html_table(tables[[5]])[,c(1,2)] |> 
    filter(!(grepl("Tagesbedarf", X1)) & 
             X1 != "") |> format_strToNum()
  t5 <- t5$X2 |> t() |> data.frame(row.names=name) |> `colnames<-`(names(vitamine)) 
  
  
  ### Sechste Tabelle: Mineralstoffe in mg
  t6 <- html_table(tables[[6]])[,c(1,2)] |> 
    filter(!(grepl("Tagesbedarf", X1)) & 
             X1 != "") |> format_strToNum()
  t6 <- t6$X2 |> t() |> data.frame(row.names=name) |> `colnames<-`(names(mineralstoffe)) 
  
  
  ### Spurenelemente in mikrogramm
  t7 <- html_table(tables[[7]])[,c(1,2)] |> 
    filter(!(grepl("Tagesbedarf", X1)) & 
             !(grepl("Richtwert", X1)) & 
             X1 != "") |> format_strToNum()
  t7 <- t7$X2 |> t() |> data.frame(row.names=name) |> `colnames<-`(names(spurenelemente)) 
  
  
  ### Kohlenhydrate
  t8 <- html_table(tables[[8]])[,c(1,2)] |> 
    filter(!(grepl("Broteinheiten", X1)) & 
             X1 != "") |> format_strToNum()
  t8 <- t8$X2 |> t() |> data.frame(row.names=name) |> `colnames<-`(names(kohlenhydrate)) 
  
  
  ### Aminosäuren in mg
  t9 <- html_table(tables[[9]])[,c(1,2)] |> 
    filter(!(grepl("Tagesbedarf", X1)) & 
             X1 != "") |> format_strToNum()
  t9 <- t9$X2 |> t() |> data.frame(row.names=name) |> `colnames<-`(names(aminos)) 
  
  
  ### Ballaststoffe in mg
  t10 <- html_table(tables[[10]])[,c(1,2)] |> 
    filter(X1 != "") |> format_strToNum()
  t10 <- t10$X2 |> t() |> data.frame(row.names=name) |> `colnames<-`(names(ballaststoffe)) 
  
  
  ### Alle Fettsäuren in mg
  t12 <- html_table(tables[[12]])[,c(1,2)] |> 
    filter(X1 != "") |> format_strToNum()
  t12 <- t12$X2 |> t() |> data.frame(row.names=name) |> `colnames<-`(names(fette)) 
  
  
  # verbinde alte und neue df
  makros <- rbind(makros, t2)
  vitamine <- rbind(vitamine, t5)
  mineralstoffe <- rbind(mineralstoffe, t6)
  spurenelemente <- rbind(spurenelemente, t7)
  kohlenhydrate <- rbind(kohlenhydrate, t8)
  aminos <- rbind(aminos, t9)
  ballaststoffe <- rbind(ballaststoffe, t10)
  fette <- rbind(fette, t12)

}





