
library(meetupr)
library(purrr)
library(dplyr)
library(tidyr)
library(wordcloud2)
library(tidytext)

Sys.setenv(MEETUP_KEY = 'Aca va tu API Key de Meetup)

#Función para que no de error de time out para la llamadas al método de meetupr
#Código de Jeny Brian
slowly <- function(f, delay = 0.5) {
  
  function(...) {
    
    Sys.sleep(delay)
    
    f(...)
    
  }
  
}


#preparo un listado de stopwords en varios idiomas para sacarlos de la nube de palabras
# No tengo idea si esto se puede hacer de otra manera más sencilla, `pero funciona

idiomas <- list('spanish', 'portuguese', 'french', 'danish', 'dutch', 'finnish', 'german', 'hungarian', 'italian', 'norwegian', 'russian', 'swedish')

variosIdiomas_stop_words <- idiomas %>% 
  map(tm::stopwords) %>%
  flatten_dfc() %>% 
  gather(var, word) %>%
  bind_rows(stop_words) %>%
  select(word, lexicon)


#Código ya escrito en la Shiny App de R-Ladies
#Obteniendo todos los grupos de R-Ladies
all_rladies_groups <- find_groups(text = "r-ladies")

# Cleanup
rladies_groups <- all_rladies_groups[grep(pattern = "rladies|r-ladies", 
                                          x = all_rladies_groups$name,
                                          ignore.case = TRUE), ]


#fin código de la Shinny App de r-Ladies

#Obtengo todos los eventos ya realizados. Get all the past meetups 
eventos <- rladies_groups$urlname %>%
  map(slowly(safely(get_events)), event_status='past') %>% transpose()

#En eventos me queda una lista con todos los datos de los eventos: nombre, fecha, lugar, descripción, y una carralada de datos más.  Por el momento
#la lista tiene dos elementos: uno con los resultados correctos y otro con los errores.  Da error cuando no hay eventos pasados en el grupo.

#Sólo me interesa la información que tenemos en resultados. Asi que me quedo con esa información
eventos_todos_juntos <- eventos$result %>% map(bind_rows) %>% transpose()

#Para una primera prueba solo quiero los nombres de los meetups.
#Get only the names from the meetups
nombres <- eventos_todos_juntos$name 
#Keep the records with some name
is_ok <- nombres %>% map_lgl(is_null)
#Para los que tienen nombre, me quedan los títulos como columnas, los paso a filas, los separo en palabras 
# y saco los stop_words en varios idiomas y me quedo con todas las palabras que tienen al menos 3 ocurrencias (si no quedan 1400 palabras)

names <- nombres[!is_ok] %>% 
  flatten_dfc() %>% 
  gather(variable, titulo) %>%
  unnest_tokens(word, titulo) %>%
  anti_join(variosIdiomas_stop_words) %>%
  count(word) %>%
  filter(n>2)



wordcloud2(names, size = 1, minRotation = -pi/6, maxRotation = -pi/6,
                  color = "random-light", backgroundColor = "grey")


#intento de forma de R, no logro hacerlo funcionar

names <- nombres[!is_ok] %>% 
  flatten_dfc() %>% 
  gather(variable, titulo) %>%
  unnest_tokens(word, titulo) %>%
  anti_join(variosIdiomas_stop_words) %>%
  count(word) %>%
  filter(n>9)


letterCloud(names,  word = "R", color='random-light' , backgroundColor="black")

wordcloud2(names, figPath = "rlogo1.png", size = 0.4, color = "skyblue", backgroundColor="black")
