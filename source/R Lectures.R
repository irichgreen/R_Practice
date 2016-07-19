library(ggplot2)
?mpg
head(mpg)
str(mpg)
summary(mpg)
qplot(displ, hwy, data = mpg)
qplot(displ, hwy, colour = class, data = mpg)

qplot(displ, hwy, colour = class, data = mpg) + facet_grid(. ~ cyl)
qplot(displ, hwy, colour = class, data = mpg) + facet_grid(drv ~ .)
qplot(displ, hwy, colour = class, data = mpg) + facet_grid(drv ~ cyl)
qplot(displ, hwy, colour = class, data = mpg) + facet_wrap(~ class)

qplot(cty, hwy, data = mpg)
qplot(cty, hwy, data = mpg, geom = "jitter")
qplot(class, hwy, data = mpg)
qplot(reorder(class, hwy), hwy, data = mpg)
qplot(reorder(class, hwy), hwy, data = mpg, geom = "jitter")
qplot(reorder(class, hwy), hwy, data = mpg, geom = "boxplot")
qplot(reorder(class, hwy), hwy, data = mpg, geom = c("jitter", "boxplot"))


# With only one variable, qplot guesses that
# you want a bar chart or histogram
qplot(cut, data = diamonds)
qplot(carat, data = diamonds)
# Change binwidth:
qplot(carat, data = diamonds, binwidth = 1)
qplot(carat, data = diamonds, binwidth = 0.1)
qplot(carat, data = diamonds, binwidth = 0.01)
resolution(diamonds$carat)
last_plot() + xlim(0, 3)

qplot(table, data = diamonds, binwidth = 1)
# To zoom in on a plot region use xlim() and ylim()
qplot(table, data = diamonds, binwidth = 1) +
    xlim(50, 70)
qplot(table, data = diamonds, binwidth = 0.1) +
    xlim(50, 70)
qplot(table, data = diamonds, binwidth = 0.1) +
    xlim(50, 70) + ylim(0, 50)
# Note that this type of zooming discards data
# outside of the plot regions. See
# ?coord_cartesian() for an alternative

qplot(depth, data = diamonds, binwidth = 0.2)
qplot(depth, data = diamonds, binwidth = 0.2,
      fill = cut) + xlim(55, 70)
qplot(depth, data = diamonds, binwidth = 0.2) + xlim(55, 70) + facet_wrap(~ cut)
qplot(price, data = diamonds, binwidth = 500) + facet_wrap(~ cut)

# Large distances make comparisons hard
qplot(price, data = diamonds, binwidth = 500) +
    facet_wrap(~ cut)
# Stacked heights hard to compare
qplot(price, data = diamonds, binwidth = 500, fill = cut)
# Much better - but still have differing relative abundance
qplot(price, data = diamonds, binwidth = 500,
      geom = "freqpoly", colour = cut)
# Instead of displaying count on y-axis, display density
# .. indicates that variable isn't in original data
qplot(price, ..density.., data = diamonds, binwidth = 500,
      geom = "freqpoly", colour = cut)
# To use with histogram, you need to be explicit
qplot(price, ..density.., data = diamonds, binwidth = 500,
      geom = "histogram") + facet_wrap(~ cut)


# There are two ways to add additional geoms
# 1) A vector of geom names:
qplot(price, carat, data = diamonds,
      geom = c("point", "smooth"))
# 2) Add on extra geoms
qplot(price, carat, data = diamonds) + geom_smooth()
# This is how you get help about a specific geom:
# ?geom_smooth


# To set aesthetics to a particular value, you need
# to wrap that value in I()
qplot(price, carat, data = diamonds, colour = "blue")
qplot(price, carat, data = diamonds, colour = I("blue"))
# Practical application: varying alpha
qplot(carat, price, data = diamonds, alpha = I(1/10))
qplot(carat, price, data = diamonds, alpha = I(1/50))
qplot(carat, price, data = diamonds, alpha = I(1/100))
qplot(carat, price, data = diamonds, alpha = I(1/250))

qplot(table, price, data = diamonds)
qplot(table, price, data = diamonds,
      geom = "boxplot")
# Need to specify grouping variable: what determines
# which observations go into each boxplot
qplot(table, price, data = diamonds,
      geom = "boxplot", group = round_any(table, 1))
qplot(table, price, data = diamonds,
      geom = "boxplot", group = round_any(table, 1)) +
    xlim(50, 70)

qplot(x, y, data = diamonds)


x <- sample(1:10)
y <- setNames(x, letters[1:10])

x
y
x[1:4]
x[x == 5]
y[order(y)]
x[]
x[-1]
y["a"]
x[x]
x[x > 2 & x < 9]
x[sample(10)]
x[order(x)]
x[-(1:5)]
x["a"]
y[letters[10:1]]
x[x < 2 | x >= 8]
x[-1:5]
x[0]

# Everything
str(diamonds[, ])
# Positive integers & nothing
diamonds[1:6, ] # same as head(diamonds)
diamonds[, 1:4] # watch out!
# Two positive integers in rows & columns
diamonds[1:10, 1:4]
# Repeating input repeats output
diamonds[c(1,1,1,2,2), 1:4]
# Negative integers drop values
diamonds[-(1:53900), -1]

# Use logical comparisons to describe which valuesyou want. Comparison functions:
    # < > <= >= != == %in%
x_big <- diamonds$x > 10
head(x_big)
sum(x_big)
mean(x_big)
table(x_big)
diamonds$x[x_big]
diamonds[x_big, ]
