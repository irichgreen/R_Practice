install.packages(c("idbr", "countrycode", "ggplot2", "devtools", "animation", "tidyr", "tweenr"))

library(devtools)
devtools::install_github("dgrtwo/gganimate")

library(idbr)
idb_api_key('eda821cd9a28ee2821ecd9f8bb8cfc6434d2f6e3')

library(countrycode)
countrycode('Canada', 'country.name', 'fips104')

ca1 <- idb1('CA', 2016)
head(ca1)

idb5('CA', 2016, concept = 'Fertility rates')

# image 1
library(idbr)
library(ggplot2)
library(dplyr)
library(gganimate)
library(animation)

male <- idb1('NI', 1990:2050, sex = 'male') %>%
  mutate(POP = POP * -1,
         SEX = 'Male')

female <- idb1('NI', 1990:2050, sex = 'female') %>%
  mutate(SEX = 'Female')

nigeria <- rbind(male, female)

# Animate it with gganimate

g1 <- ggplot(nigeria, aes(x = AGE, y = POP, fill = SEX, width = 1, frame = time)) +
  coord_fixed() +
  coord_flip() +
  geom_bar(data = subset(nigeria, SEX == "Female"), stat = "identity", position = 'identity') +
  geom_bar(data = subset(nigeria, SEX == "Male"), stat = "identity", position = 'identity') +
  scale_y_continuous(breaks = seq(-5000000, 5000000, 2500000),
                     labels = c('5m', '2.5m', '0', '2.5m', '5m'),
                     limits = c(min(nigeria$POP), max(nigeria$POP))) +
  theme_minimal(base_size = 14, base_family = "Tahoma") +
  scale_fill_manual(values = c('#98df8a', '#2ca02c')) +
  ggtitle('Population structure of Nigeria,') +
  ylab('Population') +
  xlab('Age') +
  theme(legend.position = "bottom", legend.title = element_blank()) +
  labs(caption = 'Chart by @kyle_e_walker | Data source: US Census Bureau IDB via the idbr R package') +
  guides(fill = guide_legend(reverse = TRUE))

gg_animate(g1, interval = 0.1, ani.width = 700, ani.height = 600)

# image 2
library(idbr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(countrycode)
library(gganimate)
library(tweenr)

ctrys <- countrycode(c('Russia', 'Ukraine', 'Belarus', 'Moldova', 'Georgia', 'Kazakhstan',
                       'Uzbekistan', 'Lithuania', 'Latvia', 'Estonia', 'Kyrgyzstan',
                       'Tajikistan', 'Turkmenistan', 'Armenia', 'Azerbaijan'),
                     'country.name', 'fips104')

full <- idb5(country = ctrys, year = 1989:2016,
             variables = c('E0_F', 'E0_M'), country_name = TRUE)

tmp <- full %>%
  filter(time == 1989) %>%
  arrange(E0_F)

ord <- as.character(as.vector(tmp$NAME))

dft <- full %>%
  mutate(diff = E0_F - E0_M, ease = 'cubic-in-out') %>%
  select(-FIPS) %>%
  rename(Male = E0_M, Female = E0_F) %>%
  tween_elements(time = 'time', group = 'NAME', ease = 'ease',
                 nframes = 500) %>%
  gather(Sex, value, Male, Female, -diff, -.group) %>%
  mutate(.group = factor(.group, levels = ord))


g <- ggplot() +
  geom_point(data = dft, aes(x = value, y = .group, color = Sex, frame = .frame),
             size = 14) +
  scale_color_manual(values = c('darkred', 'navy')) +
  geom_text(data = dft, aes(x = value, y = .group, frame = .frame,
                            label = as.character(round(dft$value, 1))),
            color = 'white', fontface = 'bold') +
  geom_text(data = dft, aes(x = 80, y = 1.5, frame = .frame,
                            label = round(dft$time, 0)), color = 'black', size = 12) +
  theme_minimal(base_size = 16, base_family = "Tahoma") +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()) +
  labs(y = '',
       x = '',
       color = '',
       caption = 'Data source: US Census Bureau IDB via the idbr R package; chart by @kyle_e_walker',
       title = 'Life expectancy at birth in the former USSR, 1989-2016')

gg_animate(g, interval = 0.05, ani.width = 750, ani.height = 650, title_frame = FALSE)
