library(tidyverse)
library(colorspace)
library(plotly)
library(geomtextpath)

# load estimates
ptfs <- read.csv("outputs/ptfs.csv") 

# load HFD data
HFD_pft <- read.table("inputs/HFD/pft.txt", skip = 2, header = T) |> 
  select(Code, Year, x, m1x, m2x, m3x, b1x, b2x, b3x, b4x, b5px) |> 
  mutate(age = as.integer(x), 
        m1x = as.numeric(m1x), m2x = as.numeric(m2x), m3x = as.numeric(m3x),
      b1x = as.numeric(b1x), b2x = as.numeric(b2x), b3x = as.numeric(b3x), b4x = as.numeric(b4x), b5px = as.numeric(b5px)) %>% 
  replace(is.na(.), 0) %>%
  filter(!is.na(m1x), age > 14, age < 50, Code != "CHL")

# bind
age_cv_data <- bind_rows(
  HFD_pft %>% transmute(País = Code, Year, age, `1` = b1x, `2` = b2x, `3` = b3x, `4` = b4x, `5` = b5px),
  ptfs %>% transmute(País, Year, age, `1` = b1x, `2` = b2x, `3` = b3x, `4` = b4x, `5` = b5px)) %>%
  mutate(T = `1`+`2`+`3`+`4`+`5`, .before = `4`) %>%
  filter(Year > 1980) |> select(-`4`, -`5`) %>%
  pivot_longer(`1`:`T`, names_to = "Orden", values_to = "value") %>% 
  filter(age %in% 15:49) %>%
  summarise(B = sum(value)/10000,
            ` Mean Age` = sum(value*age)/sum(value),
            `CV` = (sum(value*age^2)/sum(value)-` Mean Age`^2)^.5/` Mean Age`, 
            .by = c(País, Year, Orden)) %>% 
  pivot_longer(B:`CV`)

# plot
b_not_t_limits <- range(age_cv_data$value[age_cv_data$name == "B" & age_cv_data$Orden != "T"], na.rm = TRUE)
edad_media_limits <- range(age_cv_data$value[age_cv_data$name == " Mean Age"], na.rm = TRUE)
cv_limits <- range(age_cv_data$value[age_cv_data$name == "CV"], na.rm = TRUE)
plot_HFD_mean_age_cv_B <- age_cv_data %>% 
  filter(Year >= 1990) |> 
  ggplot(aes(Year, value)) +
  geom_line(data = . %>% filter(!País %in% c("ARG", "CHL", "BRA", "URY")), col = "grey", aes(group = País), alpha = .3) +
  # geom_line(data = . %>% filter(País %in% c("ESP", "JPN", "SWE")), col = "black", aes(group = País), alpha = .3) +
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
