library(elastic)

shakespeare <- system.file("examples", "shakespeare_data.json", package = "elastic")

docs_bulk(shakespeare)

plosdat <- system.file("examples", "plos_data.json", package = "elastic")
docs_bulk(plosdat)


connect(es_port = 9200)
Search(index = "shakespeare", size = 1)$hits$hits
