librarian::shelf("ggplot2")


save.image("meine_umgebung.RData")

# Später, in einer neuen Sitzung:
load("meine_umgebung.RData")




ggplot(data=vitamine, mapping=aes(makros$`Energie (kcal)`, spurenelemente$Zink, color=makros$Kategorie))+
  geom_point()+
  scale_x_log10() +
  scale_y_log10()+
  scale_color_manual(values = c("Fleisch (Rind, Kalb, Schwein, Hammel, Lamm)" = "red", 
                                "Wurst, Fleischwaren" = "darkred",
                                "Eier und Eierprodukte, Teigwaren"="yellow",
                                "Fische, Krusten-, Schalen-, Weichtiere"="blue",
                                "Gemüse und Gemüseerzeugnisse"="green",
                                "Hülsenfrüchte (reif), Schalenobst, Öl- und andere Samen" = "darkgreen",
                                "other" = "grey"))
  #theme(legend.position="none")


