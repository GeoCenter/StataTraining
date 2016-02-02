
# Intro -------------------------------------------------------------------
# Create a re-envisioned graphic of the WHO's ugly map on causes of
# childhood death.
# http://www.who.int/bulletin/volumes/86/5/07-048769/en/

library(readxl)
library(ggplot2)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(extrafont)

loadfonts()



# Colors ------------------------------------------------------------------

grey90K = '#414042'
grey60K = '#808285'
grey50K = '#939598'
grey30K = '#BCBEC0'
grey15K = '#DCDDDE'
grey10K = '#E6E7E8'

# Import data -------------------------------------------------------------


# Import estimates of the WHO map
# Percents and total numbers were read off the chart and converted to raw deaths.
# As such, these numbers aren't accurate but should be about right.
df = read_excel(path = "~/GitHub/StataTraining/Day4/Data/WHO_estimates.xlsx")

# Resort factors to get in a reasonable order.
df$region = factor(df$region, levels = rev(c("Africa", "S. East Asia",
                                         "Middle East", "Asia/Oceania",
                                         "Americas", "Europe", "total")))



deathByRegion = df %>% select(region, Total) 

totalDeaths = deathByRegion %>% 
  filter(region == "total") %>% 
  select(Total)

totalPneumonia = df %>% 
  select(region, Pneumonia_total) 

totalPneumonia = full_join(totalPneumonia, deathByRegion, by = "region")%>% 
  filter(region != "total") %>%
  select(region, deaths = Pneumonia_total, Total) %>% 
  mutate(pct = paste0((deaths/Total)*100, "%"))



# Remove goo and tidy
df = df %>% 
  select(-Check, -Total, -Pneumonia_total) %>% 
  gather(disease, pct, -region)

# Reorder levels
df$disease = factor(df$disease, levels = c("Neonatal",
                    "Pneumonia", "Diarrhea",
                    "Other", "Malaria",
                    "Measles", "Injuries", "HIV/AIDS"))

dfHeat = df %>% filter(region != "total")

deathByDisease = df %>% filter(region == "total")


# Plot heatmap ------------------------------------------------------------

ggplot(dfHeat, aes(y = region, x = disease, fill = pct)) +
  geom_tile(colour = grey30K) +
  scale_fill_gradientn(colours = brewer.pal(9, "YlGnBu"),
                      name = "percent of total deaths") +
  ggtitle("Pneumonia is the second leading cause of death of children under 5") +
  theme(
    title =  element_text(size = 16, hjust = 0, color = grey90K,
                          family = 'Segoe UI'),
    text =  element_text(size = 12, hjust = 0, color = grey60K,
                          family = 'Segoe UI Light'),
    axis.title = element_blank(),
    axis.text = element_text(size = 12, hjust = 0.5, 
                             color = grey60K, family = 'Segoe UI Light'),
    axis.ticks = element_blank(),
    panel.border = element_blank(),
    plot.margin = rep(unit(0, units = 'points'),4),
    panel.grid = element_blank(),
    panel.background = element_blank(), 
    plot.background = element_blank()
  )



# Plot bar: total disease by region ---------------------------------------
ggplot(deathByRegion %>% filter(region !="total"), aes(x = region, y = Total)) +
  # geom_bar(aes(x = region, y = totalDeaths$Total), stat = "identity", fill = "#dddddd") +
  geom_bar(stat = "identity") + 
  coord_flip() +
  theme_bw() +
  theme(
    text = element_text(family = 'Segoe UI Light', colour = grey60K),
    rect = element_blank(),
    plot.background = element_blank(),
    axis.text = element_text(size = 12,  color = grey60K),
    title =  element_text(size = 15, family = "Segoe UI", hjust = 0, color = grey90K),
    axis.title.x =  element_text(size = 14, family = "Segoe UI Semilight", color = grey60K, hjust = 0.5, vjust = -0.25),
    axis.title.y = element_blank(), 
    axis.line = element_line(size = 0.2, color = grey60K),
    axis.line.y = element_blank(),
    # axis.ticks = element_blank()
    strip.text = element_text(size=14, face = 'bold', hjust = 0.05, vjust = -2.5, color = '#4D525A'),
    legend.position = 'none',
    strip.background = element_blank(),
    axis.ticks = element_blank(),
    panel.margin = unit(3, 'lines'),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.x = element_line(size = 0.1, color = '#bababa'))


ggplot(deathByRegion %>% filter(region !="total"), aes(y = region, x = 1, 
                                                       size = Total, label = round(Total, 1))) +
  geom_point(colour = grey30K) + 
  geom_text(colour = 'white', size = 4, family = "Segoe UI Semilight") +
  scale_size(range = c(7, 20), limits = c(0, 4.5)) +
  theme_void() +
  theme(legend.position = 'none')



ggplot(deathByDisease, aes(x = disease, y = 1, 
                               size = pct, label = round(pct, 1))) +
  geom_point(colour = grey30K) + 
  geom_text(colour = 'white', size = 4, family = "Segoe UI Semilight") +
  scale_size(range = c(7, 20),
             limits = c(0, 4.5)) +
  theme_void() +
  theme(legend.position = 'none')


ggplot(deathByDisease, aes(x = disease, y = pct)) +
  # geom_bar(aes(x = disease, y = totalDeaths$Total), stat = "identity", fill = "#dddddd") +
  geom_bar(stat = "identity", fill = grey30K) +
  scale_y_reverse() +
  theme_bw() +
  theme(
    text = element_text(family = 'Segoe UI Light', colour = grey60K),
    rect = element_blank(),
    plot.background = element_blank(),
    axis.text = element_text(size = 12,  color = grey60K),
    title =  element_text(size = 15, family = "Segoe UI", hjust = 0, color = grey90K),
    axis.title.x =  element_text(size = 14, family = "Segoe UI Semilight", color = grey60K, hjust = 0.5, vjust = -0.25),
    axis.title.y = element_blank(), 
    axis.line = element_line(size = 0.2, color = grey60K),
    # axis.line.y = element_blank(),
    strip.text = element_text(size=14, face = 'bold', hjust = 0.05, vjust = -2.5, color = '#4D525A'),
    legend.position = 'none',
    strip.background = element_blank(),
    axis.ticks = element_blank(),
    panel.margin = unit(3, 'lines'),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(size = 0.1, color = '#bababa'))


# Pneumonia relative to rest ----------------------------------------------
totalPneumonia$region = factor(totalPneumonia$region, levels = rev(c("Africa", "S. East Asia",
                                                                 "Middle East", "Asia/Oceania",
                                                                 "Americas", "Europe")))


ggplot(totalPneumonia, aes(x = region, y = deaths, label = pct)) +
  geom_bar(aes(x = region, y = Total), 
           stat = "identity", fill = "#dddddd") +
  geom_bar(stat = "identity", fill = "dodgerblue") +
  annotate(geom = "text", x = 6, y = 4, label = "total deaths", 
           family = 'Segoe UI Light', colour = grey60K, size = 4) +
  annotate(geom = "text", x = 6, y = 1.7, label = "from pneumonia", 
           family = 'Segoe UI Light', colour = "dodgerblue", size = 4) +
  theme(panel.background = element_blank(),
        text = element_text(family = 'Segoe UI Light', colour = grey60K),
        rect = element_blank(),
        plot.background = element_blank(),
        axis.text = element_text(size = 12,  color = grey60K),
        title =  element_text(size = 13, family = "Segoe UI", hjust = 0.5, color = grey90K),
        axis.title.x =  element_text(size = 14, family = "Segoe UI Semilight", color = grey60K, hjust = 0.5, vjust = -0.25),
        axis.title.y = element_blank(), 
        axis.line = element_line(size = 0.2, color = grey60K),
        axis.line.y = element_blank(),
        # axis.ticks = element_blank()
        strip.text = element_text(size=14, face = 'bold', hjust = 0.05, vjust = -2.5, color = '#4D525A'),
        legend.position = 'none',
        strip.background = element_blank(),
        axis.ticks = element_blank(),
        panel.margin = unit(3, 'lines'),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_line(size = 0.1, color = '#bababa'), 
        panel.ontop = TRUE) +
  geom_text(position = position_nudge(y = 0.2), 
            colour = "dodgerblue", family = 'Segoe UI Semilight') +
  ylab("deaths of children under 5 (in millions)") +
  ggtitle("Child deaths from pneumonia are most common in Africa, S.E. Asia, and the Middle East") + 
  coord_flip()

