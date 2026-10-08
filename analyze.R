# analyze fertility tables for Southern Cone countries (ARG, BRA, CHL, URY) using HFD methodology

library(tidyverse)
library(colorspace)
library(plotly)



# plot tfr and adjusted measures -----------------------------------------



# plot: rates comparison between conditioned and not --------------------------------------

data_cond_uncond_rates <- bind_rows(
  lista_por_pais$ARG$ARGasfrRR %>% 
    select(Year, Age, m1x = ASFR1, m2x = ASFR2, m3x = ASFR3) %>%
    mutate(País = "ARG", Tipo = "No", Year = as.integer(Year)), 
  lista_por_pais$ARG$ARGpft %>% 
    select(Year, Age = x, m1x, m2x, m3x) %>% 
    mutate(País = "ARG", Tipo = "Yes"),
  lista_por_pais$CHL$CHLasfrRR %>% 
    select(Year, Age = x, m1x = ASFR1, m2x = ASFR2, m3x = ASFR3) %>%
    mutate(País = "CHL", Tipo = "No", Year = as.integer(Year)), 
  lista_por_pais$CHL$CHLpft %>% 
    select(Year, Age = x, m1x, m2x, m3x) %>% 
    mutate(País = "CHL", Tipo = "Yes"),
  lista_por_pais$URY$URYasfrRR %>% 
    select(Year, Age, m1x = ASFR1, m2x = ASFR2, m3x = ASFR3) %>%
    mutate(País = "URY", Tipo = "No", Year = as.integer(Year)), 
  lista_por_pais$URY$URYpft %>% 
    select(Year, Age = x, m1x, m2x, m3x) %>% 
    mutate(País = "URY", Tipo = "Yes"),
  lista_por_pais$BRA$BRAasfrRR %>%
    select(Year, Age, m1x = ASFR1, m2x = ASFR2, m3x = ASFR3) %>%
    mutate(País = "BRA", Tipo = "No", Year = as.integer(Year)),
  lista_por_pais$BRA$BRApft %>%
    select(Year, Age = x, m1x, m2x, m3x) %>%
    mutate(País = "BRA", Tipo = "Yes")
  ) 

ayear <- 2016
plot_cond_uncond_rates <- data_cond_uncond_rates_2016 %>% 
  rename(`m1(x)` = m1x, `m2(x)` = m2x, `m3(x)` = m3x) |> 
  filter(Year %in% ayear) %>% 
  pivot_longer(`m1(x)`:`m3(x)`, names_to = "order", values_to  ="mx") %>% 
  filter(mx < .2) %>% 
  ggplot(aes(Age, mx, col = Tipo)) +
  geom_line() +
  scale_x_continuous(limits = c(15, 45), breaks = seq(15, 45, 5), labels = seq(15, 45, 5)) +
  theme_bw(base_size = 13) + theme(panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank()) +
  labs(y = "mi(x)", x = "Age", col = "Conditional") +
  facet_grid(rows = vars(País), cols = vars(order))

ggsave("outputs/plots/plot_cond_uncond_rates_2016.png",
  plot_cond_uncond_rates_2016, width = 13, height = 10, dpi = 300)


# plot: cond rates in years 2011, 2017 y 2023 -----------------------------------------------------------------

# fertility tables
ptfs <- bind_rows(
  lista_por_pais$CHL$CHLpft %>% mutate(País = "CHL"),
  lista_por_pais$URY$URYpft %>% mutate(País = "URY"),
  lista_por_pais$ARG$ARGpft %>% mutate(País = "ARG"),
  lista_por_pais$BRA$BRApft %>% mutate(País = "BRA")) %>% 
  rename(age = x) %>% 
  filter(Year %in% 2011:2023)

plot_cond_rates_2011.2017.2023 <- ptfs %>%
  select(age, Country = País, Year, m1x, m2x, m3x) %>% 
  rename(`m1(x)` = m1x, `m2(x)` = m2x, `m3(x)` = m3x) |> 
  pivot_longer(`m1(x)`:`m3(x)`, names_to = "order", values_to = "mx") %>% 
  filter(age %in% 15:49, mx < .2, Year %in% c(2011, 2017, 2023)) %>% 
  ggplot(aes(age, mx, col = factor(Country), group = factor(Country))) +
  geom_line() +
  scale_x_continuous(limits = c(15, 45), breaks = seq(15, 45, 5), labels = seq(15, 45, 5)) +
  theme_bw(base_size = 13) + theme(panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank()) +
  labs(y = "mi(x)", x = "Age", col = "Country") +
  scale_color_manual(values = c("#598af5", "#71d110", "#fc634f", "#6fffff")) +
  facet_grid(rows = vars(order), cols = vars(Year), switch = "y") 

ggsave("outputs/plots/plot_cond_rates_2011.2017.2023.png",
  plot_cond_rates_2011.2017.2023, width = 13, height = 10, dpi = 300)


# plot: period cumulated parity distribution------------------------------------------------

plot_period_cumulated_parity <- ptfs %>%
  select(age, País, Year, l0x, l1x, l2x, b1x, b2x, b3x) %>% 
  filter(age >= 15, age < 50) %>% 
  mutate(Year = as.integer(Year)) %>% 
  mutate(`Q1(x)` = cumsum(b1x)/1e4, `Q2(x)` = cumsum(b2x)/1e4, `Q3(x)` = cumsum(b3x)/1e4, .by = c(País, Year)) %>% 
  pivot_longer(`Q1(x)`:`Q3(x)`, names_to = "Qix", values_to = "value") %>% 
  ggplot(aes(age, value, col = Year, group = Year)) +
  geom_line() +
  scale_y_continuous(breaks = seq(0, 1, .2), labels = seq(0, 1, .2)) +
  facet_grid(rows = vars(País), cols = vars(Qix)) +
  theme_bw(base_size = 13) +
  labs(y = "Qi(x)", x = "Age", col = "Year", y = "") +
  scale_colour_viridis_c(option = "B",direction = -1, labels = function(x) sprintf("%.0f", x))

ggsave("outputs/plots/plot_period_cumulated_parity.png",
  plot_period_cumulated_parity, width = 13, height = 10, dpi = 300)


# plot: mean age and dispersion -------------------------------------------------------------------

plot_mean_age_cv <- ptfs %>% 
  select(Country = País, Year, age, `1` = b1x, `2` = b2x, `3` = b3x) %>%
  pivot_longer(`1`:`3`, names_to = "Order", values_to = "value") %>% 
  summarise(` Mean Age` = sum(value*age)/sum(value),
            CV = (sum(value*age^2)/sum(value)-` Mean Age`^2)^.5/` Mean Age`, 
            .by = c(Country, Year, Order)) %>% 
  pivot_longer(` Mean Age`:CV) %>% 
  ggplot(aes(Year, value, col = Country, group = Country)) +
  geom_line() +
  theme_bw(base_size = 13) +
  labs(y = "", x = "Year", col = "Country") +
  scale_color_manual(values = c("#598af5", "#71d110", "#fc634f", "#6fffff")) +
  scale_x_continuous(breaks = seq(min(ptfs$Year, na.rm = TRUE), max(ptfs$Year, na.rm = TRUE), 1)) +
  scale_y_continuous(
    breaks = \(x) if (max(x, na.rm = TRUE) < 1) scales::breaks_width(.01)(x) else scales::breaks_width(1)(x)) +
  facet_grid(rows = vars(name),cols = vars(Order), scales = "free", switch = "y") +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_line(linewidth = .2),
        axis.text.x = element_text(angle = 90, vjust = .5, hjust = 1))

ggsave("outputs/plots/plot_mean_age_cv.png",
  plot_mean_age_cv, width = 13, height = 10, dpi = 300)

# diff in mean age
plot_conditional_not_mean_age <- bind_rows(
  ptfs %>% 
    select(Country = País, Year, age, `1` = b1x, `2` = b2x, `3` = b3x) %>%
    pivot_longer(`1`:`3`, names_to = "Order", values_to = "value") %>% 
    summarise(value = sum(value*age)/sum(value),
              .by = c(Country, Year, Order)) |> 
    mutate(Conditional = "Yes"),
  data_cond_uncond_rates |>
    filter(Tipo == "No") |> 
    mutate(Age = as.integer(Age)) |> 
    summarise(
      mac1 = sum(m1x*Age, na.rm = T)/sum(m1x, na.rm = T), 
      mac2 = sum(m2x*Age, na.rm = T)/sum(m2x, na.rm = T),
      mac3 = sum(m3x*Age, na.rm = T)/sum(m3x, na.rm = T), .by = c(Tipo, País, Year)) |> 
    pivot_longer(mac1:mac3) |> 
    mutate(Order = substr(name, 4, 4)) |> 
    rename(Country = País) |> 
    mutate(Conditional = "No")) |> 
  filter(Year %in% 2011:2023) |> 
  ggplot(aes(Year, value, col = Conditional, group = Conditional)) + 
  geom_line() + 
  theme_bw(base_size = 13) +
  facet_grid(cols = vars(Country), rows = vars(Order)) 

ggsave("outputs/plots/plot_conditional_not_mean_age.png",
  plot_conditional_not_mean_age, width = 13, height = 10, dpi = 300)

#############################################################################



# Period Fertility Index
ptfs %>%
  select(País, Year, age, b1x, b2x, b3x, b4x, b5px) %>% 
  pivot_longer(b1x:b5px, names_to = "bix", values_to = "value") %>% 
  filter(age %in% 15:49) %>%
  summarise(tfr = sum(value)/1e4, .by = c(País, Year)) %>% 
  ggplot(aes(Year, tfr, col = País, group = País)) +
  geom_line() +
  labs(y = "", x = "Edad", col = "Año") 
  
# Probabilidades condicionales por edad
ptfs %>%
  select(age, País, Year, q1x, q2x, q3x) %>% 
  pivot_longer(q1x:q3x, names_to = "qix", values_to = "value") %>% 
  filter(age %in% 15:49) %>% 
  ggplot(aes(age, value, col = Year, group = Year)) +
  geom_line() +
  facet_grid(rows = vars(País), cols = vars(qix), 
             switch = "y") +
  theme_minimal() +
  labs(y = "", x = "Edad", col = "Año") +
  scale_colour_gradient(
    low = "orange", high = "black",
    labels = scales::number_format(accuracy = 1)
  )

# Probabilidades condicionales en el tiempo
ptfs %>%
  select(age, País, Year, q1x, q2x, q3x) %>% 
  pivot_longer(q1x:q3x, names_to = "qix", values_to = "value") %>% 
  filter(age %in% 30:39) %>% 
  ggplot(aes(Year, value, col = age, group = age)) +
  geom_line() +
  facet_grid(rows = vars(País), cols = vars(qix), 
             switch = "y") +
  theme_minimal() +
  labs(y = "", x = "Año", col = "Edad") 



# grid orden 1. Simil graf 13 gran caída
ptfs %>%
  select(age, País, Year, q1x, q2x, q3x) %>% 
  pivot_longer(q1x:q3x, names_to = "qix", values_to = "value") %>% 
  filter(age >= 15, age < 45, qix == "q1x") %>% replace(is.na(.), 0) %>% 
  ggplot(aes(Year, age, z = value, fill = value)) +
  geom_tile() +
  facet_grid(cols = vars(País), switch = "y") +
  scale_fill_gradient(
    low = "white", high = "black",
    labels = scales::comma)  +
  coord_equal() +
  labs(y = "Edad", x = "Año", fill = "Valor") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(2010, 2022, 2),  labels = seq(2010, 2022, 2))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        panel.spacing = unit(0, "lines"))






# probabilidad a cada edad de que una mujer de 15 años de la cohorte hipotética tenga su primer y segundo hijo
ptfs %>%
  select(age, País, Year, l0x, l1x, l2x, b1x, b2x, b3x, b3x) %>% 
  filter(age >= 15, age < 50) %>% 
  mutate(Q1x = b1x/1e4, Q2x = b2x/1e4, Q3x = b3x/1e4) %>% 
  pivot_longer(Q1x:Q3x, names_to = "Qix", values_to = "value") %>% 
  ggplot(aes(age, value, col = Year, group = Year)) +
  facet_grid(rows = vars(País), cols = vars(Qix), 
             scales = "free", switch = "y") +
  geom_line() +
  theme_minimal() +
  labs(y = "", x = "Edad", col = "Año") +
  scale_colour_gradient(
    low = "darkgoldenrod3", high = "black",
    labels = scales::number_format(accuracy = 1)
  )





# tabla
ptfs %>% 
  select(País, Year, age, `1` = b1x, `2` = b2x, `3` = b3x) %>%
  pivot_longer(`1`:`3`, names_to = "Orden", values_to = "value") %>% 
  summarise(` Edad Media` = sum(value*age)/sum(value),
            CV = (sum(value*age^2)/sum(value)-` Edad Media`^2)^.5/` Edad Media`, 
            .by = c(País, Year, Orden)) %>% 
  pivot_longer(` Edad Media`:CV, names_to = "Indicador", values_to = "Valor") %>% 
  pivot_wider(names_from = Orden, values_from = Valor) %>% 
  writexl::write_xlsx("EdadesMedia_CV.xlsx")

# distancia entre edades media
ptfs %>% 
  select(País, Year, age, `1` = b1x, `2` = b2x, `3` = b3x) %>%
  pivot_longer(`1`:`3`, names_to = "Orden", values_to = "value") %>% 
  summarise(`Edad Media` = sum(value*age)/sum(value),
            .by = c(País, Year, Orden)) %>% 
  pivot_longer(`Edad Media`) %>% 
  filter(Orden < 3) %>% 
  ggplot(aes(Year, value, col = País)) +
  geom_line(aes(linetype = Orden)) +
  theme_minimal() +
  labs(y = "", x = "Año", col = "País") +
  scale_color_manual(values = c("darkgoldenrod3", "black", "red", "blue")) +
  facet_grid(rows = vars(name),scales = "free_y", switch = "y")

# simil graf 10 de gran caída
ptfs %>% 
  select(País, Year, age, q1x, q2x, q3x) %>%
  filter(age %in% seq(20, 40, 5), Year > 2010) %>% 
  pivot_longer(q1x:q3x, names_to = "qix", values_to = "value") %>% 
  # filter(País == "CHL", age == 15) %>% 
  mutate(value = value/value[Year == 2011]*100, .by = c(País, age, qix)) %>% 
  ggplot(aes(Year, value, col = factor(age))) +
  geom_line() +
  theme_minimal() +
  labs(y = "", x = "Año", col = "Edad") +
  # scale_fill_gradientn(colours = terrain.colors(5)) +
  facet_grid(rows = vars(País), cols = vars(qix),
             scales = "free_y", switch = "y")

# distribución de paridez de cohortes hipotéticas en cada año. 
# se ve el empalme entre fuentes de CHL
ptfs %>%
  select(age, País, Year, w0x, w1x, w2x, , w3x) %>% 
  pivot_longer(w0x:w3x, names_to = "wix", values_to = "value") %>% 
  filter(age >= 15, age < 45, wix %in% c("w1x", "w2x")) %>% 
  ggplot(aes(Year, age, z = value, fill = value)) +
  geom_tile() +
  facet_grid(cols = vars(País), rows = vars(wix), switch = "y") +
  scale_fill_gradient(
    low = "white", high = "black",
    labels = scales::comma)  +
  coord_equal() +
  labs(y = "Edad", x = "Año", fill = "Valor") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(2010, 2022, 2),  labels = seq(2010, 2022, 2))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        panel.spacing = unit(0, "lines"))



