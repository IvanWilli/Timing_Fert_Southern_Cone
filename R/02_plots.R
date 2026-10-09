# plots for Southern Cone countries (ARG, BRA, CHL, URY)

library(tidyverse)
library(colorspace)
library(plotly)

# Figure 1: rates comparison between conditioned and not --------------------------------------

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
    mutate(País = "BRA", Tipo = "Yes")) 

ayear <- 2016
plot_cond_uncond_rates_2016 <- data_cond_uncond_rates %>% 
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

# Figure 2: period cumulated parity distribution------------------------------------------------

# bind fertility tables
ptfs <- bind_rows(
  lista_por_pais$CHL$CHLpft %>% mutate(País = "CHL"),
  lista_por_pais$URY$URYpft %>% mutate(País = "URY"),
  lista_por_pais$ARG$ARGpft %>% mutate(País = "ARG"),
  lista_por_pais$BRA$BRApft %>% mutate(País = "BRA")) %>% 
  rename(age = x) %>% 
  filter(Year %in% 2011:2023)

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

# Figure 3: cond rates in years 2011, 2017 y 2023 -----------------------------------------------------------------

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

# Figure 4: mean age and dispersion -------------------------------------------------------------------

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

# tabla
ptfs %>% 
  select(País, Year, age, `1` = b1x, `2` = b2x, `3` = b3x) %>%
  pivot_longer(`1`:`3`, names_to = "Orden", values_to = "value") %>% 
  summarise(` Edad Media` = sum(value*age)/sum(value),
            CV = (sum(value*age^2)/sum(value)-` Edad Media`^2)^.5/` Edad Media`, 
            .by = c(País, Year, Orden)) %>% 
  pivot_longer(` Edad Media`:CV, names_to = "Indicador", values_to = "Valor") %>% 
  pivot_wider(names_from = Orden, values_from = Valor) %>% 
  writexl::write_xlsx("otuputs/EdadesMedia_CV.xlsx")


# Figure 5: comparison against HFD -------------------------------------------

# load HFD data
HFD_pft <- read.table("inputs/HFD/pft.txt", skip = 2, header = T) |> 
  select(Code, Year, x, m1x, m2x, m3x, b1x, b2x, b3x, b4x, b5px) |> 
  mutate(
    age = as.integer(x), 
    m1x = as.numeric(m1x), m2x = as.numeric(m2x), m3x = as.numeric(m3x),
    b1x = as.numeric(b1x), b2x = as.numeric(b2x), b3x = as.numeric(b3x), b4x = as.numeric(b4x), b5px = as.numeric(b5px)) %>% 
  replace(is.na(.), 0) %>%
  filter(!is.na(m1x), age > 14, age < 50, Code != "CHL")
countries_HFD <- HFD_pft |> filter(Year >= 1980) |> distinct(Code) |> pull() |> dput()

# bind HFD and souther cone countries
age_cv_data <- bind_rows(
    HFD_pft %>% transmute(País = Code, Year, age, `1` = b1x, `2` = b2x, `3` = b3x, `4` = b4x, `5` = b5px),
    ptfs %>% transmute(País, Year, age, `1` = b1x, `2` = b2x, `3` = b3x, `4` = b4x, `5` = b5px)
  ) %>%
  mutate(T = `1`+`2`+`3`+`4`+`5`, .before = `4`) %>%
  filter(Year > 1980) |> select(-`4`, -`5`) %>%
  pivot_longer(`1`:`T`, names_to = "Orden", values_to = "value") %>% 
  filter(age %in% 15:49) %>%
  summarise(B = sum(value)/10000,
            `  Mean Age` = sum(value*age)/sum(value),
            ` CV` = (sum(value*age^2)/sum(value)-`  Mean Age`^2)^.5/`  Mean Age`, 
            .by = c(País, Year, Orden)) %>% 
  pivot_longer(B:` CV`)

# plot
b_not_t_limits <- range(age_cv_data$value[age_cv_data$name == "B" & age_cv_data$Orden != "T"], na.rm = TRUE)
edad_media_limits <- range(age_cv_data$value[age_cv_data$name == "  Mean Age"], na.rm = TRUE)
cv_limits <- range(age_cv_data$value[age_cv_data$name == " CV"], na.rm = TRUE)
plot_HFD_mean_age_cv_B <- age_cv_data %>% 
  filter(Year >= 1980) |> 
  ggplot(aes(Year, value)) +
  geom_line(data = . %>% filter(!País %in% c("ARG", "CHL", "BRA", "URY")), col = "grey", aes(group = País), alpha = .3) +
  geom_line(data = . %>% filter(País %in% c("ARG", "CHL", "BRA", "URY")), aes(col = País, group = País)) +
  theme_bw(base_size = 13) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()) +
  labs(y = "", x = "Year", col = "Country") +
  scale_color_manual(values = c("#598af5", "#71d110", "#fc634f", "#6fffff")) +
  ggh4x::facet_grid2(
    rows = vars(name), cols = vars(Orden),
    scales = "free_y", independent = "y", switch = "y") +
  ggh4x::facetted_pos_scales(
    y = list(
      name == "B" & Orden != "T" ~ scale_y_continuous(limits = b_not_t_limits),
      name == " Mean Age" ~ scale_y_continuous(limits = edad_media_limits),
      name == "CV" ~ scale_y_continuous(limits = cv_limits))
  )

ggsave("outputs/plots/plot_HFD_mean_age_cv_B.png",
  plot_HFD_mean_age_cv_B, width = 13, height = 10, dpi = 300)

#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################
############################ OTHER PLOTS ####################################

# plots: checks inputs ------------------------------------------------------------------

# total input births
table_input_births <- bind_rows(
  ARGBirthsTR %>% mutate(Country = "ARG"),
  CHLBirthsTR %>% mutate(Country = "CHL"),
  BRABirthsTR %>% mutate(Country = "BRA"),
  URYBirthsTR %>% mutate(Country = "URY")) %>% 
  summarise(N = sum(Total), .by = c(Country, Year)) %>% 
  pivot_wider(names_from = Country, values_from = N)
print(table_input_births)

# distribución de nacimientos por orden
plot_births_order_distribution <- bind_rows(
  BRABirthsTR %>% 
    mutate(B1 = as.integer(B1), B2 = as.integer(B2), B3 = as.integer(B3),
           Country = "BRA") %>% 
    select(Country, Year, B1, B2, B3) %>% 
    pivot_longer(B1:B3, names_to = "Parity", values_to = "Births") %>%
    summarise(Births = sum(Births), .by = c(Parity, Country, Year)) %>% 
    mutate(pBirths = Births/sum(Births), .by = c(Country, Year)),
  ARGBirthsTR %>% 
    mutate(B1 = as.integer(B1), B2 = as.integer(B2), B3 = as.integer(B3),
           Country = "ARG") %>% 
    select(Country, Year, B1, B2, B3) %>% 
    pivot_longer(B1:B3, names_to = "Parity", values_to = "Births") %>%
    summarise(Births = sum(Births), .by = c(Parity, Country, Year)) %>% 
    mutate(pBirths = Births/sum(Births), .by = c(Country, Year)),
  CHLBirthsTR %>% 
    mutate(B1 = as.integer(B1), B2 = as.integer(B2), B3 = as.integer(B3),
           Country = "CHL") %>% 
    select(Country, Year, B1, B2, B3) %>% 
    pivot_longer(B1:B3, names_to = "Parity", values_to = "Births") %>%
    summarise(Births = sum(Births), .by = c(Parity, Country, Year)) %>% 
    mutate(pBirths = Births/sum(Births), .by = c(Country, Year)),
  URYBirthsTR %>% 
    mutate(B1 = as.integer(B1), B2 = as.integer(B2), B3 = as.integer(B3),
           Country = "URY") %>% 
    select(Country, Year, B1, B2, B3) %>% 
    pivot_longer(B1:B3, names_to = "Parity", values_to = "Births") %>%
    summarise(Births = sum(Births), .by = c(Parity, Country, Year)) %>% 
    mutate(pBirths = Births/sum(Births), .by = c(Country, Year))
  ) %>% 
  ggplot(aes(Year, pBirths, fill = Parity)) +
  geom_area() +
  ggtitle("Distr de nacs por orden") +
  facet_wrap(~Country)

ggsave("outputs/plots/plot_censal_parity.png",
  plot_censal_parity, width = 13, height = 10, dpi = 300)

# tfr implicit in input data
plot_tfr <- bind_rows(
  ARGtfr %>% select(Year, TFR) %>% mutate(País = "ARG"),
  CHLtfr %>% select(Year, TFR) %>% mutate(País = "CHL"),
  URYtfr %>% select(Year, TFR) %>% mutate(País = "URY"),
  BRAtfr %>% select(Year, TFR) %>% mutate(País = "BRA")) %>%
  filter(Year %in% 2010:2023) %>%
  ggplot(aes(Year, TFR, col = País, group = País)) + geom_line()+
  ggtitle("TFR. Input data for countries") +
  theme_bw(base_size = 13)

ggsave("outputs/plots/plot_tfr.png",
  plot_tfr, width = 13, height = 10, dpi = 300)

# censal parity distribution by age
plot_censal_parity <- bind_rows(
  URYparity %>% mutate(Age = as.integer(Age), PopName = "URY 2011"),
  CHLparity %>% mutate(Age = as.integer(Age), PopName = "CHL 2017"),
  ARGparity %>% mutate(Age = as.integer(Age), PopName = "ARG 2010"),
  BRAparity %>% mutate(Age = as.integer(Age), PopName = "BRA 2010")) %>% 
  select(PopName, Age, Parity, Population) %>% 
  mutate(Parity = pmin(3, Parity)) %>% 
  summarise(pop = sum(Population, na.rm = T), .by = c(PopName, Age, Parity)) %>% 
  mutate(distr = pop/sum(pop), .by = c(c(PopName, Age))) %>% 
  ggplot(aes(Age, distr, col = PopName)) +
  geom_line() + labs(col = "País") +
  facet_wrap(~Parity) +
  theme_bw(base_size = 13) +
  ggtitle("Age distribution of parity. Census data for countries") 

ggsave("outputs/plots/plot_births_order_distribution.png",
  plot_births_order_distribution, width = 13, height = 10, dpi = 300)

# plot: check parity distribution with arrived census -----------------------------------------------

# fertility tables
ptfs <- bind_rows(
  lista_por_pais$CHL$CHLpft %>% mutate(País = "CHL"),
  lista_por_pais$URY$URYpft %>% mutate(País = "URY"),
  lista_por_pais$ARG$ARGpft %>% mutate(País = "ARG"),
  lista_por_pais$BRA$BRApft %>% mutate(País = "BRA")) %>% 
  rename(age = x) %>% 
  filter(Year %in% 2011:2023)
source("R/aux_Graficos estimación Vs censo.R")

# other plots ------------------------------------------------------------

# mean age conditional and not conditional
plot_cond_not_mean_age <- bind_rows(
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
  ggtitle("Conditional and not conditional mean age") +
  facet_grid(cols = vars(Country), rows = vars(Order)) 
  
# Probabilidades condicionales por edad
ptfs %>%
  select(age, País, Year, m1x, m2x, m3x) %>% 
  pivot_longer(m1x:m3x, names_to = "mix", values_to = "value") %>% 
  filter(age %in% 15:49) %>% 
  ggplot(aes(age, value, col = Year, group = Year)) +
  geom_line() +
  facet_grid(rows = vars(País), cols = vars(mix), 
             switch = "y") +
  theme_bw(base_size = 13) +
  labs(
    y = "", x = "Edad", col = "Año",
    title = "Tasas condicionadas por edad según año") +
  scale_colour_gradient(
    low = "orange", high = "black",
    labels = scales::number_format(accuracy = 1))

# Probabilidades condicionales en el tiempo
ptfs %>%
  select(age, País, Year, m1x, m2x, m3x) %>% 
  pivot_longer(m1x:m3x, names_to = "mix", values_to = "value") %>% 
  filter(age %in% 20:39) %>% 
  ggplot(aes(Year, value, col = age, group = age)) +
  geom_line() +
  facet_grid(rows = vars(País), cols = vars(mix), switch = "y") +
  theme_bw(base_size = 13) +
  labs(
    y = "", x = "Año", col = "Edad",
    title = "Tasas condicionadas por año según edad") +
  scale_colour_gradient(
    low = "orange", high = "black",
    labels = scales::number_format(accuracy = 1))

# grid orden 1. Simil graf 13 gran caída
ptfs %>%
  select(age, País, Year, m1x, m2x, m3x) %>% 
  pivot_longer(m1x:m3x, names_to = "mix", values_to = "value") %>% 
  filter(age >= 15, age < 45, mix == "m1x") %>% replace(is.na(.), 0) %>% 
  ggplot(aes(Year, age, z = value, fill = value)) +
  geom_tile() +
  facet_grid(cols = vars(País), switch = "y") +
  scale_fill_gradient(
    low = "white", high = "black",
    labels = scales::comma)  +
  coord_equal() +
  labs(y = "Edad", x = "Año", fill = "Valor") +
   theme_bw(base_size = 13) +
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
   theme_bw(base_size = 13) +
  labs(y = "", x = "Edad", col = "Año") +
  scale_colour_gradient(
    low = "darkgoldenrod3", high = "black",
    labels = scales::number_format(accuracy = 1)
  )

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
  select(País, Year, age, m1x, m2x, m3x) %>%
  filter(age %in% seq(20, 40, 5), Year > 2010) %>% 
  pivot_longer(m1x:m3x, names_to = "mix", values_to = "value") %>% 
  # filter(País == "CHL", age == 15) %>% 
  mutate(value = value/value[Year == 2011]*100, .by = c(País, age, mix)) %>% 
  ggplot(aes(Year, value, col = factor(age))) +
  geom_line() +
  theme_minimal() +
  labs(y = "", x = "Año", col = "Edad") +
  # scale_fill_gradientn(colours = terrain.colors(5)) +
  facet_grid(rows = vars(País), cols = vars(mix),
             scales = "free_y", switch = "y")

# distribución de paridez de cohortes hipotéticas en cada año. 
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



