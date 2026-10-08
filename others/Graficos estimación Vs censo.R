
# COMPARACIÓN PARIDEZ
# Argentina 2022 - Chile 2024 - Uruguay 2023
# =========================================================

library(tidyverse)

# =========================================================
# FUNCIÓN PARA ARMAR GRÁFICOS
# =========================================================

grafico_paridez <- function(base,
                            variable_pop,
                            titulo_pais,
                            anio,
                            edad_min = 12,
                            edad_max = 55) {
  
  ggplot(
    base,
    aes(
      x = Age,
      y = .data[[variable_pop]],
      color = Fuente
    )
  ) +
    
    geom_line(linewidth = 1.2) +
    
    facet_wrap(
      ~Parity,
      ncol = 3,
      labeller = labeller(
        Parity = c(
          "0" = "0 hijos",
          "1" = "1 hijo",
          "2" = "2 hijos",
          "3" = "3 hijos",
          "4" = "4 hijos o más"
        )
      )
    ) +
    
    scale_color_manual(
      values = c(
        "Calculada" = "#E07A6A",
        "Censal"    = "#58C4C6"
      )
    ) +
    
    scale_x_continuous(
      breaks = seq(10, 55, 10),
      limits = c(edad_min, edad_max)
    ) +
    
    labs(
      title = paste0(titulo_pais, ", ", anio),
      x = "Edad",
      y = "Cantidad de mujeres",
      color = "Fuente"
    ) +
    
    theme_minimal(base_size = 11) +
    
    theme(
      
      # título
      plot.title = element_text(
        size = 14,
        hjust = 0,
        face = "plain"
      ),
      
      # títulos paneles
      strip.text = element_text(
        size = 11,
        face = "bold"
      ),
      
      # títulos ejes
      axis.title = element_text(
        size = 11,
        face = "bold"
      ),
      
      # texto ejes
      axis.text = element_text(
        size = 9
      ),
      
      # leyenda
      legend.position = "bottom",
      
      legend.title = element_text(
        size = 10,
        face = "bold"
      ),
      
      legend.text = element_text(
        size = 9
      ),
      
      # espacio paneles
      panel.spacing = unit(1, "lines"),
      
      # grid
      panel.grid.minor = element_blank()
    )
}

# =========================================================
# ARGENTINA 2022
# =========================================================

comparaARG2022 <- bind_rows(
  
  # -----------------------------
  # Distribución censal
  # -----------------------------
  
  read.table(
    "inputs/Argentina/ARGparity2022.txt",
    header = TRUE,
    na.strings = "."
  ) %>%
    
    mutate(
      Age = as.integer(Age),
      Parity = as.integer(Parity),
      Population = as.numeric(Population)
    ) %>%
    
    filter(!is.na(Age)) %>%
    
    summarise(
      pop2022 = sum(Population, na.rm = TRUE),
      .by = c(Age, Parity)
    ) %>%
    
    mutate(Fuente = "Censal"),
  
  # -----------------------------
  # Distribución calculada
  # -----------------------------
  
  ARGE[13, , ] %>%
    as.data.frame() %>%
    
    mutate(
      Age = 12:55,
      Fuente = "Calculada"
    ) %>%
    
    select(
      "0" = 1,
      "1" = 2,
      "2" = 3,
      "3" = 4,
      "4" = 5,
      Age,
      Fuente
    ) %>%
    
    pivot_longer(
      `0`:`4`,
      names_to = "Parity",
      values_to = "pop2022"
    ) %>%
    
    mutate(
      Parity = as.integer(Parity)
    )
)

# -----------------------------
# Tabla resumen
# -----------------------------

resumen_ARG2022 <- comparaARG2022 %>%
  
  summarise(
    pop2022 = sum(pop2022),
    .by = c(Parity, Fuente)
  ) %>%
  
  pivot_wider(
    names_from = Fuente,
    values_from = pop2022
  ) %>%
  
  mutate(
    Dif_abs = Censal - Calculada,
    Dif_rel = Dif_abs / Censal * 100
  )

# -----------------------------
# Gráfico
# -----------------------------

grafico_ARG2022 <- grafico_paridez(
  base = comparaARG2022,
  variable_pop = "pop2022",
  titulo_pais = "Argentina",
  anio = 2022
)

grafico_ARG2022

# =========================================================
# CHILE 2024
# =========================================================

censo_chl <- read.csv("inputs/Chile/censo2024.csv")

paridez_chl <- censo_chl %>%
  
  filter(
    edad %in% 12:55,
    p46a_tot_hijs_nac %in% 0:4
  ) %>%
  
  mutate(
    Age = as.integer(edad),
    Fuente = "Censal"
  ) %>%
  
  rename(
    Parity = p46a_tot_hijs_nac,
    pop2024 = n
  )

comparaCHL2024 <- bind_rows(
  
  # distribución censal
  paridez_chl,
  
  # distribución calculada
  CHLE[8, , ] %>%
    as.data.frame() %>%
    
    mutate(
      Age = 12:55,
      Fuente = "Calculada"
    ) %>%
    
    select(
      "0" = 1,
      "1" = 2,
      "2" = 3,
      "3" = 4,
      "4" = 5,
      Age,
      Fuente
    ) %>%
    
    pivot_longer(
      `0`:`4`,
      names_to = "Parity",
      values_to = "pop2024"
    ) %>%
    
    mutate(
      Parity = as.integer(Parity)
    )
)

# -----------------------------
# Tabla resumen
# -----------------------------

resumen_CHL2024 <- comparaCHL2024 %>%
  
  summarise(
    pop2024 = sum(pop2024),
    .by = c(Parity, Fuente)
  ) %>%
  
  pivot_wider(
    names_from = Fuente,
    values_from = pop2024
  ) %>%
  
  mutate(
    Dif_abs = Censal - Calculada,
    Dif_rel = Dif_abs / Censal * 100
  )

# -----------------------------
# Gráfico
# -----------------------------

grafico_CHL2024 <- grafico_paridez(
  base = comparaCHL2024,
  variable_pop = "pop2024",
  titulo_pais = "Chile",
  anio = 2024
)

grafico_CHL2024

# =========================================================
# URUGUAY 2023
# =========================================================

paridez_ury <- read.table(
  "inputs/Uruguay/URYparity_2023_nuevo.txt",
  header = TRUE
) %>%
  
  filter(
    Age != "TOT",
    as.integer(Age) %in% 14:49,
    Parity %in% 0:4
  ) %>%
  
  mutate(
    Age = as.integer(Age),
    Parity = as.integer(Parity),
    Population = as.numeric(Population)
  ) %>%
  
  summarise(
    pop2023 = sum(Population, na.rm = TRUE),
    .by = c(Age, Parity)
  ) %>%
  
  mutate(Fuente = "Censal")

comparaURY2023 <- bind_rows(
  
  # distribución censal
  paridez_ury,
  
  # distribución calculada
  URYE["2023", , ] %>%
    as.data.frame() %>%
    
    mutate(
      Age = 12:55,
      Fuente = "Calculada"
    ) %>%
    
    filter(Age %in% 14:49) %>%
    
    select(
      "0" = E0x,
      "1" = E1x,
      "2" = E2x,
      "3" = E3x,
      "4" = E4px,
      Age,
      Fuente
    ) %>%
    
    pivot_longer(
      `0`:`4`,
      names_to = "Parity",
      values_to = "pop2023"
    ) %>%
    
    mutate(
      Parity = as.integer(Parity)
    )
)

# -----------------------------
# Tabla resumen
# -----------------------------

resumen_URY2023 <- comparaURY2023 %>%
  
  summarise(
    pop2023 = sum(pop2023),
    .by = c(Parity, Fuente)
  ) %>%
  
  pivot_wider(
    names_from = Fuente,
    values_from = pop2023
  ) %>%
  
  mutate(
    Dif_abs = Censal - Calculada,
    Dif_rel = Dif_abs / Censal * 100
  )

# -----------------------------
# Gráfico
# -----------------------------

grafico_URY2023 <- grafico_paridez(
  base = comparaURY2023,
  variable_pop = "pop2023",
  titulo_pais = "Uruguay",
  anio = 2023,
  edad_min = 14,
  edad_max = 49
)

grafico_URY2023

# =========================================================
# EXPORTAR GRÁFICOS
# =========================================================

ggsave(
  "outputs/plots/grafico_ARG2022.png",
  grafico_ARG2022,
  width = 12,
  height = 7,
  dpi = 300
)

ggsave(
  "outputs/plots/grafico_CHL2024.png",
  grafico_CHL2024,
  width = 12,
  height = 7,
  dpi = 300
)

ggsave(
  "outputs/plots/grafico_URY2023.png",
  grafico_URY2023,
  width = 12,
  height = 7,
  dpi = 300
)

# =========================================================
# Probabilidades condicionales país
# 2011 - 2017 - 2021
# Formato similar imagen adjunta
# =========================================================

library(tidyverse)

# ---------------------------------------------------------
# Base
# ---------------------------------------------------------

graf_qx <- ptfs %>%
  
  select(age, País, Year, q1x, q2x, q3x) %>%
  
  pivot_longer(
    q1x:q3x,
    names_to = "qix",
    values_to = "value"
  ) %>%
  
  filter(
    age %in% 15:49,
    value < .2,
    Year %in% c(2011, 2017, 2023)
  ) %>%
  
  mutate(
    
    País = factor(
      País,
      levels = c("ARG", "BRA", "CHL", "URY")
    ),
    
    qix = factor(
      qix,
      levels = c("q1x", "q2x", "q3x"),
      labels = c("q1x", "q2x", "q3x")
    )
  )

# ---------------------------------------------------------
# Gráfico
# ---------------------------------------------------------

grafico_qx <- ggplot(
  graf_qx,
  aes(
    x = age,
    y = value,
    color = qix,
    group = qix
  )
) +
  
  geom_line(linewidth = 0.75) +
  
  # paneles
  facet_grid(
    rows = vars(País),
    cols = vars(Year),
    switch = "y"
  ) +
  
  # colores similares imagen
  scale_color_manual(
    values = c(
      "q1x" = "darkgoldenrod3",
      "q2x" = "black",
      "q3x" = "#F04B42"
    )
  ) +
  
  # ejes
  scale_x_continuous(
    breaks = seq(20, 50, 10)
  ) +
  
  scale_y_continuous(
    limits = c(0, 0.20),
    breaks = seq(0, 0.20, 0.05)
  ) +
  
  # etiquetas
  labs(
    x = "Edad",
    y = NULL,
    color = "País"
  ) +
  
  # tema
  theme_minimal(base_size = 9) +
  
  theme(
    
    # títulos columnas
    strip.text.x = element_text(
      size = 11,
      face = "plain"
    ),
    
    # títulos filas
    strip.text.y = element_text(
      size = 11,
      angle = 0,
      face = "plain"
    ),
    
    # leyenda
    legend.position = "right",
    
    legend.title = element_text(
      size = 11,
      face = "plain"
    ),
    
    legend.text = element_text(
      size = 10
    ),
    
    # ejes
    axis.title = element_text(
      size = 12
    ),
    
    axis.text = element_text(
      size = 9
    ),
    
    # grid
    panel.grid.minor = element_blank(),
    
    # espacio paneles
    panel.spacing = unit(0.8, "lines")
  )

# ---------------------------------------------------------
# Mostrar gráfico
# ---------------------------------------------------------

grafico_qx

# ---------------------------------------------------------
# Guardar
# ---------------------------------------------------------

# ggsave(
#   "outputs/plots/grafico_probabilidades_condicionales.png",
#   grafico_qx,
#   width = 13,
#   height = 10,
#   dpi = 300
# )
