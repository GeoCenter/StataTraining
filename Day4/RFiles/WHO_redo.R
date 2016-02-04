
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
library(stringr)

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


dfTotals = df %>% 
  select(region, contains("_total")) %>% 
  gather(disease, numDeaths, -region) 

dfTotals  = dfTotals %>% 
  mutate(disease = str_replace(dfTotals$disease, "_total", ""))



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
  select(-Check, -Total, -contains("_total")) %>% 
  gather(disease, pct, -region)

# Reorder levels
df$disease = factor(df$disease, levels = c("Neonatal",
                    "Pneumonia", "Diarrhea",
                    "Other", "Malaria",
                    "Measles", "Injuries", "HIV/AIDS"))

dfHeat = df %>% filter(region != "total")

deathByDisease = df %>% filter(region == "total")


everything  = full_join(dfHeat, dfTotals, by =  c("region", "disease")) %>% 
  mutate(pct = pct/100)

everything$disease = factor(everything$disease, levels = rev(c("Neonatal",
                                                               "Pneumonia", "Diarrhea",
                                                               "Other", "Malaria",
                                                               "Measles", "Injuries", "HIV/AIDS")))
everything$region = factor(everything$region, levels = (c("Africa", "S. East Asia",
                                             "Middle East", "Asia/Oceania",
                                             "Americas", "Europe", "total")))

# Plot heatmap ------------------------------------------------------------
dfHeat = dfHeat %>% 
  mutate(colHeat = ifelse(pct > 15, "white", grey50K))


ggplot(dfHeat, aes(y = region, x = disease, fill = pct, label = paste0(pct, "%"))) +
  geom_tile(colour = grey30K, size = 0.35) +
  geom_text(aes(colour = colHeat), family = "Segoe UI", size = 5) + 
  scale_colour_identity() +
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


# Total -------------------------------------------------------------------



ggplot(dfTotals, aes(y = numDeaths, x = region, fill = disease)) + 
  geom_bar(position = "dodge", stat = "identity")

ggplot(dfTotals%>% filter(region != "total"), aes(y = numDeaths, x = disease)) + 
  geom_bar(position = "dodge", stat = "identity") +
  facet_wrap(~region)


# Dot plots ---------------------------------------------------------------


ggplot(dfTotals, aes(x = numDeaths, y = region, colour = disease)) +
  geom_point()


ggplot(dfHeat, aes(x = pct, y = region, colour = disease)) +
  geom_point()


ggplot(dfHeat, aes(x = pct, y = disease, colour = disease)) +
  geom_segment(aes(xend = 0, yend = disease)) + 
  geom_point() +
  facet_wrap(~region)

ggplot(dfTotals %>% filter(region != "total"), aes(x = numDeaths, y = disease, colour = disease)) +
  geom_point() +
  facet_wrap(~region)
  

ggplot(everything %>% filter(region != "total"), 
       aes(x = pct, y = disease, colour = numDeaths, size = numDeaths)) +
  geom_segment(aes(xend = 0, yend = disease), size = 0.5) + 
  geom_point() +
  geom_text(aes(label = paste0(signif(numDeaths, 1), " million")),
            family = "Segoe UI Light",
            data = everything %>% filter(disease == "Pneumonia", region != "total"),
            size = 4, hjust = 0,
            position = position_nudge(x = 0.05)) +
  scale_size(range = c(0.5, 8),
             name = "number of deaths (millions)") + 
  scale_color_gradientn(guide = FALSE,
    colours = brewer.pal(9, "Blues")[5:9]) + 
  scale_x_continuous(labels = scales::percent, 
                     breaks = c(0, 0.20, 0.4),
                     minor_breaks = seq(0, 0.5, 0.1),
                     limits = c(0, 0.5)) +
  scale_y_discrete(expand = c(0, 1.2)) +
  xlab("share of deaths, by region") +
  ylab("") +
  facet_wrap(~region) +
  theme_bw() +
  theme(
    text = element_text(family = 'Segoe UI Light'),
    axis.text = element_text(size = 16, color = grey50K, family = 'Segoe UI Light'),
    title =  element_text(size = 18, family = 'Segoe UI', hjust = 0, color = grey60K),
    axis.title.y =  element_text(size = 20, color = grey50K, family = 'Segoe UI Semilight', hjust = 0.5, vjust = 1),
    axis.title.x =  element_text(size = 20, color = grey50K, family = 'Segoe UI Semilight', hjust = 0.5, vjust = -0.25),
    strip.text = element_text(size=13, color = grey50K, family = 'Segoe UI Semilight'),
    legend.text = element_text(size = 13),
    legend.key = element_blank(),
    strip.background = element_blank(),
    panel.grid.major = element_line(size = 0.2, color = grey50K),
    panel.grid.minor = element_line(size = 0.2, color = grey30K),      panel.grid.minor.y = element_blank(),
              panel.grid.major.y = element_blank())



# Mini bar of by diseas ---------------------------------------------------

deathByDisease = deathByDisease %>% 
  mutate(colBar = ifelse(disease == "Pneumonia", brewer.pal(9,"Blues")[8], grey30K))

ggplot(deathByDisease, aes(x = disease, y = pct, fill = colBar, colour = colBar)) +
  # geom_bar(aes(x = disease, y = totalDeaths$Total), stat = "identity", fill = "#dddddd") +
  geom_bar(stat = "identity", size = 0) +
  geom_text(aes(label = round(pct,1)), 
            size = 7,
            position = position_nudge(y = 0.2),
            family = "Segoe UI Semilight") +
  scale_fill_identity() +
  scale_color_identity() +
  theme_bw() +
  theme(
    text = element_text(family = 'Segoe UI Light', colour = grey60K),
    rect = element_blank(),
    plot.background = element_blank(),
    axis.text = element_text(size = 12,  color = grey60K),
    axis.text.y = element_blank(),
    title =  element_text(size = 15, family = "Segoe UI", hjust = 0, color = grey90K),
    axis.title = element_blank(), 
    axis.line = element_blank(),
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

