# Nube De Palabras de R-Ladies

En septiembre de 2018 se realizó en Buenos Aires la primera edición de LatinR, la [Conferencia Latinoamericana de Investigación y Desarrollo en R](https://github.com/LatinR/presentaciones-LatinR2018). Durante la conferencia tuve la posibilidad de compartir con los asistentes la iniciativa de R-Ladies junto con [Laura Acion](http://lacion.rbind.io/) y [Bea Hernandez](https://twitter.com/chucheria).  


![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/imagen.png)

En esa [presentación](https://github.com/LatinR/presentaciones-LatinR2018/blob/master/presentaciones-orales/LatinR2018_RLadies.pptx) utilizamos una nube de palabras para contar que tipo de temas se trabajan en los meetups de R-Ladies en Latinoamérica.

![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/ROriginal.png)

En un principio utilicé R para generar el listado de palabras, pero no para generar la nube; como soy una R-Lady no podía dejar de intentar realizar todo el proceso utilizando R. 

Aqui cuento como hice esa nube de palabras usando el paquete **meetupr**, *desarrollado por R-Ladies*.

## Nube de palabras con los meetups de RLadies

**Objetivo**: dibujar una nube de palabras con los temas tratados en los eventos de R-Ladies *en todo el mundo* que sea lo más parecida posible a la realizada para la presentación de LatinR.

La fuente de datos son *las palabras que se utilizan en los títulos de los eventos* y se utilizó el paquete **meetupr** para obtener esa información.

## Links que utilicé:
Este listado de recursos fueron muy útiles para poder realizar la nube de palabras.

- https://www.tidytextmining.com/tidytext.html (información para trabajar con el texto de los títulos y como hacer nubes de palabras)
- https://github.com/Lchiffon/wordcloud2 (paquete para realizar la nube de palabras)
- https://jvera.rbind.io/post/2017/10/16/spanish-stopwords-for-tidytext-package/ (stop words en español)
- https://www.r-graph-gallery.com/196-the-wordcloud2-library/ (código de ejemplo para hacer nubes de palabras)
- https://github.com/rladies/meetupr (paquete para acceder a los datos de los meetups)

Links con soluciones a problemas encontrados durante la realización de la nube de palabras:
- https://github.com/Lchiffon/wordcloud2/issues/12
- https://github.com/tidyverse/purrr/issues/389

## Paquetes que utilicé:

Este es el código para instalar los paquetes necesarios:

```
install.packages("tidyverse")
install.packages("purrr")
install.packages("devtools")
devtools::install_github("rladies/meetupr")
install.packages("wordcloud2")
install.packages("tidytext")
install.packages("tm")  (Para tener stop_words en otros idiomas además de inglés)
```

## El código

Cargamos los paquetes necesarios:

```
library(meetupr)
library(purrr)
library(dplyr)
library(tidyr)
library(wordcloud2)
library(tidytext)
```

y luego necesitamos generar una API Key de Meetup y asignarla de la siguiente manera (más detalles [aquí](https://github.com/rladies/meetupr)):

```
Sys.setenv(MEETUP_KEY = 'Aca va tu API Key de Meetup')
```
Luego, es necesario generar una función que "espere" entre una llamada a la API y otra, para evitar errores de *time out* (gracias a [Jenny Bryan](https://twitter.com/jennybryan) por este código)

```
slowly <- function(f, delay = 0.5) {
  
  function(...) {
    
    Sys.sleep(delay)
    
    f(...)
    
  }
  
}
```
Finalmente, se debe prepar un listado de *stop words* en varios idiomas (R-Ladies está presente en más de 40 países) para sacarlos de la nube de palabras (¿Se podrá hacer de manera más sencilla?).  Las *stop wors* son palabras como artículos, preposiciones, conectores, por ejemplo: *la*, *el*, *con*, etc.
```
idiomas <- list('spanish', 'portuguese', 'french', 'danish', 'dutch', 'finnish', 'german', 'hungarian', 'italian', 'norwegian', 'russian', 'swedish')

variosIdiomas_stop_words <- idiomas %>% 
  map(tm::stopwords) %>%
  flatten_dfc() %>% 
  gather(var, word) %>%
  bind_rows(stop_words) %>%
  select(word, lexicon)
```
El segundo paso es obtener los títulos de todos los meetups de R-Ladies alrededor del mundo, para esto utilicé el código de la [Shiny App de R-Ladies](https://github.com/rladies/rshinylady), el cual obtiene todos los grupos de R-Ladies y limpia los resultados:
```
all_rladies_groups <- find_groups(text = "r-ladies")

rladies_groups <- all_rladies_groups[grep(pattern = "rladies|r-ladies", 
                                          x = all_rladies_groups$name,
                                          ignore.case = TRUE), ]


```
Con el listado de todos los grupos, obtengo todos los eventos ya realizados (aquí utilizamos la función de Jenny):  

```
eventos <- rladies_groups$urlname %>%
  map(slowly(safely(get_events)), event_status='past') %>% transpose()
```

En **eventos** queda una lista con todos los datos de todos los eventos realizados: nombre, fecha, lugar, descripción....y una carralada de datos más.  Por el momento la lista tiene dos elementos: uno con los resultados correctos y otro con los errores, se genera un error cuando no hay eventos pasados en el grupo.  Como sólo interesa la información almacenada en resultados, filtramos esa información: 

```
eventos_todos_juntos <- eventos$result %>% map(bind_rows) %>% transpose()
```

La nube de palabras original fue armada con los títulos de los meetups, asi que generamos una lista con esa información, que se encuentra en el atributo name (*nombre*):

```
nombres <- eventos_todos_juntos$name 
is_ok <- nombres %>% map_lgl(is_null)
```
Para los meetups que tienen nombre, los títulos quedan como columnas, asi que se pasan a filas y se separan en palabras.  Con esta lista de palabras se sacan los *stop words* en varios idiomas (dataframe **variosIdiomas_stop_words**) y retenemos todas las palabras que tienen al menos 3 ocurrencias (si no quedan 1400 palabras)
```
names <- nombres[!is_ok] %>% 
  flatten_dfc() %>% 
  gather(variable, titulo) %>%
  unnest_tokens(word, titulo) %>%
  anti_join(variosIdiomas_stop_words) %>%
  count(word) %>%
  filter(n>2)
```

## Los primeros resultados:

Y por fin, se puede generar la primera nube de palabras!!!:

```
wordcloud2(names, size = 1, minRotation = -pi/6, maxRotation = -pi/6,
                  color = "random-light", backgroundColor = "grey")

```
![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/NubeDePalabras1.png)

![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/nubeDepalabras2.png)


## Con forma de R

Ahora el desafío fue darle la forma de la letra **R**, los primeros intentos no funcionarion, pero se resolvió instalando el paquete wordcloud2 desde github y no desde CRAN, el código cambia la función a utilizar:

```
letterCloud(names,  word = "R", color='random-light', backgroundColor="#223564")
```

![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/ConFormaDeR.png)


Casi llegamos al objetivo, filtramos más palabras para que se noten mejor en la nube de palabras (nos quedamos con las que aparecen 9 veces o más) y personalizamos la paleta de colores con los cuatro colores de base que se utilizaron en la imagen original:
```
names <- nombres[!is_ok] %>% 
  flatten_dfc() %>% 
  gather(variable, titulo) %>%
  unnest_tokens(word, titulo) %>%
  anti_join(variosIdiomas_stop_words) %>%
  count(word) %>%
  filter(n>9)

colorlist <- c('#f7e4be', '#f0f4bc', '#9a80a4', '#848da6')
```
Como hay que repetir los colores por la cantidad de palabras que se deben graficar, utilizamos este código (el número está puesto a a mano para probar, en el To Do List: realizar el calculo por la cantidad de palabras)
```
colores <- rep(list(colorlist), 68) 
colorlist <- unlist(colores)
```
Generamos la nube de palabras:
```
letterCloud(names,  word = "R", color=colorlist, backgroundColor="#223564")
```
y... aquí está: 

![alt tag](https://github.com/yabellini/NubeDePalabras/blob/master/RConColoresLatinR.png)

Esta opción es la que mas se parece a la R original utilizada en la presentación (nada mal!)

Finalmente, este código busca dar la forma de la nube de palabras de acuerdo a una imagen, pero sigue sin funcionar:
```
wordcloud2(names, figPath = "rlogo1.png", size = 0.4, color = "skyblue")
```
Si alguien encuentra una manera de hacer funcionar este código sería genial que lo compartiera!

# Como sigue:

Ahora estoy trabajando en separar las palabras de acuerdo al idioma y realizar una nube de palabras por cada lenguaje que se habla en la comunidad de R-Ladies.

Espero les haya gustado tanto como a mi me gustó hacer este ejercicio.  Se puede acceder a todo el código [aqui](https://github.com/yabellini/NubeDePalabras/blob/master/NubeDePalabras.R)
