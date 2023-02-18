librarian::shelf("ggplot2")

# Lade Daten
load("meine_umgebung.RData")

### Normiere
# Range zum normieren
rg <- apply(makros[,-c(1,2)], 2, range)

# normiere
norm_makros <- apply(makros[,-c(1,2)], 1, function(rw){
  (rw - rg[1,])/(rg[2,]-rg[1,])}) |> 
  as.matrix() |> t() |> as.data.frame()

# füge name und kategorie wieder hinzu
norm_makros <- cbind(makros[,c(1,2)], norm_makros)

# erhalte ein sample-Lebensmittel 
smpl_name <- norm_makros$name |> sample(1)
smpl <- norm_makros[norm_makros$name==smpl_name,]

ggplot(data=norm_makros, mapping=aes(x=Kohlenhydrate, y=`Eiweiß, Proteingehalt`, color=Kategorie))+
  geom_point()+
  scale_color_manual(values = c("Früchte, Obst und Obsterzeugnisse" = "green",
                                "Sonstige Kategorien" = "grey"))+
  geom_point(data=smpl, aes(x=Kohlenhydrate, y=`Eiweiß, Proteingehalt`),
             color="red",
             size=3)
  #theme(legend.position="none")

