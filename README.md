# NubeDePalabras
## Nube de palabras con los meetups de RLadies

Objetivo: dibujar una nube de palabras con los temas tratados en los eventos de R-Ladies en todo el mundo.
En un principio tomar las palabras que se utilizan en los títulos de los eventos.

## Links que utilicé:
- https://github.com/tidyverse/purrr/issues/389
- https://www.tidytextmining.com/tidytext.html 
- https://github.com/Lchiffon/wordcloud2 
- https://jvera.rbind.io/post/2017/10/16/spanish-stopwords-for-tidytext-package/ (stop words en español)
- https://www.r-graph-gallery.com/196-the-wordcloud2-library/

## Paquetes que utilicé:

```
install.packages("tidyverse")
install.packages("purrr")
install.packages("dplyr")
install.packages("devtools")
devtools::install_github("rladies/meetupr")
install.packages("wordcloud2")
install.packages("tidytext")
install.packages("tm")  (Para tener stop_words en otros idiomas además de inglés)
```
## Los primeros resultados:

![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/NubeDePalabras1.png)

![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/nubeDepalabras2.png)


