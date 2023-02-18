import csv
from bs4 import BeautifulSoup
from selenium import webdriver as wd
import time

# CHROME öffnen
driver = wd.Chrome(r'C:\Users\user00\Documents\selenium webdriver chrome\chromedriver.exe')

# Seite laden
url = ["https://www.naehrwertrechner.de/naehrwerttabelle/suche.php?quelle=naehrwertrechner&order=popularity&reihenfolge=DESC&results=1000&",
       "https://www.naehrwertrechner.de/naehrwerttabelle/suche.php?quelle=naehrwertrechner&rubrik=Brot-+und+Kleingeb%C3%A4ck&konzentrate=0&getrocknete=0&gewuerze=0&order=popularity&reihenfolge=DESC&results=100",
       "https://www.naehrwertrechner.de/naehrwerttabelle/suche.php?quelle=naehrwertrechner&rubrik=Cerealien%2C+Getreide+und+Getreideprodukte%2C+Reis&konzentrate=0&getrocknete=0&gewuerze=0&order=popularity&reihenfolge=DESC&results=100",
       "https://www.naehrwertrechner.de/naehrwerttabelle/suche.php?quelle=naehrwertrechner&rubrik=Wurst%2C+Fleischwaren&konzentrate=0&getrocknete=0&gewuerze=0&order=popularity&reihenfolge=DESC&results=500",
       "https://www.naehrwertrechner.de/naehrwerttabelle/suche.php?quelle=naehrwertrechner&rubrik=&aggregatszustand=&ernaehrungsform=&konzentrate=0&getrocknete=0&gewuerze=0&pref=&order=popularity&reihenfolge=DESC&results=1000&naehrwertampel=1",
       "https://www.naehrwertrechner.de/naehrwerttabelle/suche.php?quelle=naehrwertrechner&rubrik=S%C3%BC%C3%9Fwaren%2C+Zucker%2C+Bonbons%2C+Schokolade%2C+Brotaufstrich+s%C3%BC%C3%9F%2C+Eis&aggregatszustand=&ernaehrungsform=&konzentrate=0&gewuerze=0&pref=&order=popularity&reihenfolge=DESC&results=1000&naehrwertampel=0&nw%5B0%5D=&vg%5B0%5D=&mg%5B0%5D=&nw%5B1%5D=&vg%5B1%5D=&mg%5B1%5D=&nw%5B2%5D=&vg%5B2%5D=&mg%5B2%5D=&nw%5B3%5D=&vg%5B3%5D=&mg%5B3%5D=&nw%5B4%5D=&vg%5B4%5D=&mg%5B4%5D=",
       "https://www.naehrwertrechner.de/naehrwerttabelle/suche.php?suchbegriff=&quelle=naehrwertrechner&rubrik=Kartoffeln+und+Kartoffelerzeugnisse%2C+st%C3%A4rkereiche+Pflanzenteile%2C+Pilze&aggregatszustand=&ernaehrungsform=&konzentrate=0&gewuerze=0&pref=&order=popularity&reihenfolge=DESC&results=1000&naehrwertampel=0&nw%5B0%5D=&vg%5B0%5D=&mg%5B0%5D=&nw%5B1%5D=&vg%5B1%5D=&mg%5B1%5D=&nw%5B2%5D=&vg%5B2%5D=&mg%5B2%5D=&nw%5B3%5D=&vg%5B3%5D=&mg%5B3%5D=&nw%5B4%5D=&vg%5B4%5D=&mg%5B4%5D=",
       "https://www.naehrwertrechner.de/naehrwerttabelle/suche.php?suchbegriff=&quelle=naehrwertrechner&rubrik=&aggregatszustand=essen&ernaehrungsform=&highprotein=1&konzentrate=0&getrocknete=0&gewuerze=0&pref=&order=popularity&reihenfolge=DESC&results=1000&naehrwertampel=0&nw%5B0%5D=&vg%5B0%5D=&mg%5B0%5D=&nw%5B1%5D=&vg%5B1%5D=&mg%5B1%5D=&nw%5B2%5D=&vg%5B2%5D=&mg%5B2%5D=&nw%5B3%5D=&vg%5B3%5D=&mg%5B3%5D=&nw%5B4%5D=&vg%5B4%5D=&mg%5B4%5D="
       ]

urls = list()
for i in range(len(url)):
    driver.get(url[i])
    time.sleep(5)
    # Mit BeautifulSoup alle URLs laden, in .csv speichern und Chrome schließen
    soup = BeautifulSoup(driver.page_source, "html5lib")
    urls.append(list({a['href'] for a in soup('a') if "naehrwerte" in str(a)}))
driver.close()

urls = list(set([item for sublist in urls for item in sublist]))

# .csv-Datei zum Schreiben öffnen
with open("urls.csv", "w", newline="") as csvfile:
    # Erstellen Sie einen CSV-Writer
    writer = csv.writer(csvfile)

    # Überschrift in die .csv-Datei
    writer.writerow(["URL"])

    # jede URL in eine neue Zeile der .csv-Datei
    for url in urls:
        writer.writerow(["https://www.naehrwertrechner.de"+url])

# .csv Datei schließen
csvfile.close()
