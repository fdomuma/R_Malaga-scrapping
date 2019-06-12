library(rvest)
library(dplyr)
library(ggplot2)

url<-"https://www.laliga.es/estadisticas-historicas/clasificacion/primera/"
temporada<-"2017-18"

enlaces<-vector()
A<-2000
for (i in 1:18){
  B<-sprintf("%02d", i)
  temporada[i]<-paste(A, B, sep="-")
  enlaces[i]<-paste(url, temporada[i], sep = "")
  A<-A+1
}


tabla <- list()
for (i in 1:length(enlaces)){
tabla[i]<-enlaces[i] %>%
  html() %>%
  html_nodes("div.container.main.table.clearfix table") %>%
  html_table()
tabla[[i]][[11]] <- temporada[i]
}


malaga <- lapply(tabla, function(tabla){
  tabla[grep("Málaga CF", tabla[[2]]),] 
})
malaga <- do.call("rbind", malaga)
malaga[,1] <- as.numeric(gsub("[^0-9\\.]", "", malaga[,1]))


ggplot(data=malaga, aes(y=reorder(-malaga[,1], malaga[,11]), x=malaga[,11])) + 
  geom_point() + geom_line()

order(malaga[,1], decreasing = F)
