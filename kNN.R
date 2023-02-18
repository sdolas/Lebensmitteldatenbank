librarian::shelf("rvest", "RSelenium", "dplyr", "stringr", "tidyverse")


# Funktion um df zu normieren
normiere <- function(df){
  
  # finde character-Datentyp in den Spalten
  character_cols <- sapply(df, is.character)
  
  # Range zum normieren
  rg <- apply(df[,!character_cols], 2, range)
  
  # normiere
  norm_df <- apply(df[,!character_cols], 1, function(row){
    (row - rg[1,])/(rg[2,]-rg[1,])}) |> 
    as.matrix() |> t() |> as.data.frame()
  
  # füge name und kategorie wieder hinzu
  norm_df <- cbind(df[,character_cols], norm_df)
  
  # return norm_df
  norm_df
}

calc_knn <- function(norm_df, smpl="rdm", k=100){
  
  # finde character-Datentyp in den Spalten
  character_cols <- sapply(norm_df, is.character)
  
  # wenn sample-Item auf random gesetzt ist:
  if (smpl=="rdm"){
    # erhalte ein sample-Lebensmittel 
    smpl_name <- norm_df$name |> sample(1)
    smpl <- norm_df[norm_df$name==smpl_name,]
    }
  
  # Berechne die quadrierten Differenzen zwischen Trainings-Data Lebensmitteln und dem Sample
  tmp <- apply(norm_df[,!character_cols], 1, function(rw) {
    (rw - smpl[1,!character_cols])^2}) |> 
    do.call(what=rbind)
  
  # entferne alle spalten die NA's beinhalten, wenn man die Summe bilden würde:
  tmp <- tmp[,colSums(is.na(tmp))==0]
  
  # summiere reihenweise alle spaltenwerte und ziehe die Wurzel:
  tmp$distance <- sqrt(rowSums(tmp))
  
  # füge character-Spalten wieder hinzu
  tmp <- cbind(norm_df[,character_cols], tmp)
  
  # sortiere nach distance
  tmp <- tmp[order(tmp$distance),]
  
  # erhalte Anteil knn in Prozent
  prop.tbl <- tmp[tmp$distance != 0,"Kategorie"] |> head(k) |> 
    as.factor() |> summary() |> as.matrix() |> prop.table() |> as.data.frame()
  
  # erstelle und sortiere knn-df
  knn <- cbind(Kategorie = rownames(prop.tbl), prop.tbl) |> `row.names<-`(NULL)
  knn <- knn[order(knn$V1, decreasing = T),]
  
  #return sample and knn
  list(smpl_name, knn)
}
  
# Lade Daten
load("tabellen.RData")

#put all data frames into list
df_list <- list(makros, 
                mineralstoffe, 
                spurenelemente,
                aminos,
                fette,
                vitamine)  

# kombiniere alle dataframes nach name
df <- df_list |>  reduce(full_join, by='name')

# erhalte normierte Werte
norm_df <- normiere(df)

# berechne knn
knn <- calc_knn(norm_df)
knn

save.image("tabellen.RData")

