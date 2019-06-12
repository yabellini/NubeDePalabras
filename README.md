# Nube De Palabras de R-Ladies

En septiembre de 2018 se realizó en Buenos Aires la primera edición de LatinR, la [Conferencia Latinoamericana de Investigación y Desarrollo en R](https://github.com/LatinR/presentaciones-LatinR2018). Durante la conferencia tuve la posibilidad de compartir con los asistentes la iniciativa de R-Ladies junto con [Laura Acion](http://lacion.rbind.io/) y [Bea Hernandez](https://twitter.com/chucheria).  


![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/imagen.png)

En esa [presentación](https://github.com/LatinR/presentaciones-LatinR2018/blob/master/presentaciones-orales/LatinR2018_RLadies.pptx) utilizamos una nube de palabras para contar que tipo de temas se trabajan en los meetups de R-Ladies en Latinoamérica.

En un principio utilicé R para generar el listado de palabras, pero no para generar la nube; pero como soy una R-Lady no podía dejar de intentar realizar todo el proceso utilizando R. 

Aqui cuento como hice esa nube de palabras usando el paquete meetupr, desarrollado por R-Ladies.

## Nube de palabras con los meetups de RLadies

Objetivo: dibujar una nube de palabras con los temas tratados en los eventos de R-Ladies *en todo el mundo* que sea lo mas parecida posible a la realizada para la presentación de LatinR.

La fuente de datos son *las palabras que se utilizan en los títulos de los eventos*.

## Links que utilicé:
Este listado de recursos fueron muy útiles para poder realizar la nube de palabras.

- https://github.com/tidyverse/purrr/issues/389
- https://www.tidytextmining.com/tidytext.html 
- https://github.com/Lchiffon/wordcloud2 
- https://jvera.rbind.io/post/2017/10/16/spanish-stopwords-for-tidytext-package/ (stop words en español)
- https://www.r-graph-gallery.com/196-the-wordcloud2-library/
- https://github.com/Lchiffon/wordcloud2/issues/12

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

## El código

## Los primeros resultados:

![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/NubeDePalabras1.png)

![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/nubeDepalabras2.png)

## Con forma de R

![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/ConFormaDeR.png)

![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/RConColoresLatinR.png)

