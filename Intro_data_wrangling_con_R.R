# Instalación de librerías importantes
install.packages("data.table")
install.packages("tidyverse")
install.packages("openxlsx")

# Truco para comentar y descomentar lineas: Ctrl+C

# Cargamos librerias importantes:
library(data.table)
library(tidyverse)
library(openxlsx)

# Usaremos el dataset "iris"
head(x = iris, n = 10) # Cabecera
class(iris) # Verificamos el tipo de objeto con el que estamos trabajando
dim(iris) # Dimensiones del dataframe
nrow(iris) # Número de filas
ncol(iris) # Número de columnas
names(iris) # Nombres de las columnas
str(iris) # Descripción de los datos. Nótese que hay 1 variable categórica
plot(iris) # Panel gráfico de los datos
View(iris) # Visualizar como Excel!

## Principios de R base:
# Separamos una columna como si fuera un vector:
iris$Species
class(iris$Species)
unique(iris$Species)

# Resumen descriptivo general de los datos (recordar Estadística):
summary(iris)

# Si le damos un vector, únicamente hará un resumen sobre este vector:
summary(iris$Species)
summary(iris$Sepal.Length)

# Nótese que tidyverse tiene una función similar a 'str':
str(iris)
glimpse(iris) # Es más ordenado y elegante :)

## 1) Subsetting de columnas: 

# Sólo columnas:
# Con R base:
iris[,"Species"] # OJO CON EL ELEMENTO EN EL SEGUNDO ESPACIO
iris[,5]
# Con tidyverse:
select(.data = iris, Species)

# Con R base para múltiples columnas:
iris[,c("Sepal.Length","Species")]
# Con tidyverse:
select(.data = iris, Sepal.Length, Species)
# Una mejor forma con tidyverse :D:
iris %>% select(Sepal.Length, Species)

### El operador "pipe" (%>%) es MUY POTENTE. Permite encadenar
### funciones en orden lógico, como si hiciéramos un proceso
### paso-a-paso (somos Industriales, ¿verdad?)

### Ejemplo:
### Se entiende intuitivamente que primero seleccionamos  columnas,
### luego "mutamos" (se verá luego), filtramos(se verá luego), y 
### removemos una columna (con el signo negativo)
iris %>% 
  select(Sepal.Length, Sepal.Width) %>% 
  mutate(new_Sepal.Length = Sepal.Length + 5000) %>% 
  filter(Sepal.Width < 3) %>% 
  select(-Sepal.Length)

### A partir de ahora, se utilizará el "%>%" cada vez que llamemos
### funciones de tidyverse, como una buena práctica

# 2) Subsetting de filas:

# Primero veremos el "corte" de filas indexadas (con números)
## R base:
iris[4,] # Cuarta fila
iris[1:20,] # Filas 1 a 20
# Tidyverse:
iris %>% slice(4)
iris %>% slice(1:20)

# Ahora veremos el "filtrado" de datos según condiciones de columnas:
## R base:
iris[iris$Species == "setosa",]
iris[iris$Sepal.Width < 3,]
### Importante: "iris$Species == 'setosa'" es una "máscara". Esto
### significa que es un vector de valores BOOLEANOS (TRUE o FALSE)
iris$Species == "setosa" # Observamos en la consola el vector booleano
iris$Sepal.Width < 3 # Observamos en la consola el vector booleano

## Tidyverse:
iris %>% filter(Species == "setosa")
iris %>% filter(Sepal.Width < 3)

# Filtrado según múltiples condiciones:
## R base:
iris[iris$Species == "setosa" & iris$Sepal.Width < 3,] # Nótese el "&"
## Tidyverse:
iris %>% filter(Species == "setosa", Sepal.Width < 3) # La "," funciona como "&"

# Filtrado usando condiciones "OR":
## R base:
iris[iris$Species == "setosa"&iris$Species == "versicolor"] # Este va a fallar
                                                            # pues se trata de
                                                            # la misma columna
iris[iris$Species == "setosa" | iris$Species == "versicolor"] # Nótese el "|"
## Tidyverse:
iris %>% filter(Species == "setosa", Species == "versicolor") # Este va a fallar
iris %>% filter(Species == "setosa" | Species == "versicolor") # Nótese el "|"

### Conclusión: trabajen los filtros con diferentes columnas separados por comas,
### y los filtros con una misma columna dentro del mismo espacio, separados por
### un "|".

# 3) Ordenamiento (sorting)
## R base:
sort(iris$Sepal.Length) # ordenamiento ascendente
sort(iris$Sepal.Length, decreasing = TRUE) # ordenamiento descendente

### Esto funciona bien cuando utilizamos vectores, pero usualmente
### (en realidad, siempre) utilizamos tablas grandes de datos, así
### que lo que buscamos es ORDENAR TODAS LAS FILAS EN FUNCIÓN A
### CIERTAS COLUMNAS, tal como en Excel.

## Tidyverse al rescate!
iris %>% arrange(Sepal.Length) # Ordenamiento ascendente
iris %>% arrange(desc(Sepal.Length)) # Ordenamiento descendente

# 4) Creando nuevas columnas y modificando columnas existentes:
tabla_dummy <- iris

## R base:
tabla_dummy$Sepal.Length ; tabla_dummy$Sepal.Length + 5
tabla_dummy$NUEVA_COLUMNA <- tabla_dummy$Sepal.Length + 5
tabla_dummy$NUEVA_COLUMNA

tabla_dummy$NUEVA_COLUMNA <- 15
tabla_dummy$NUEVA_COLUMNA

## Tidyverse:
tabla_dummy <- iris

tabla_dummy <- tabla_dummy %>% 
  mutate(NUEVA_COLUMNA = Sepal.Length+ 5)
tabla_dummy

tabla_dummy <- tabla_dummy %>% 
  mutate(NUEVA_COLUMNA = 15)
tabla_dummy

# 5) Mezclando:
iris %>% 
  select(Sepal.Length, Sepal.Width) %>% 
  mutate(new_Sepal.Length = Sepal.Length + 5000) %>% 
  filter(Sepal.Width < 3) %>% 
  select(-Sepal.Length)

### Ahora se entiende qué hace lo de arriba, ¿verdad?

# 6) Agregando información:
tabla_dummy <- iris

### A continuación: Agrupamos, sumarizamos números, y desagrupamos
agregacion <- tabla_dummy %>% 
  group_by(Species) %>% 
  summarise(media_Sepal.Length = mean(Sepal.Length),
            media_Sepal.Width = mean(Sepal.Width),
            SUMA_COLUMNAS_NUEVAS = media_Sepal.Length + media_Sepal.Width,
            CANTIDAD_REGISTROS = n()) %>% 
  ungroup()

View(agregacion)

























