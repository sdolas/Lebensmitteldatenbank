import torch
import torch.nn as nn
import pandas as pd
import numpy as np
from locale import atof, setlocale, LC_NUMERIC

# Laden Sie die Lebensmittel-Daten in einen Pandas-DataFrame
df = pd.read_csv("Tabellen/makros.csv", encoding="latin1", decimal=",", sep=";")

# Trennen Sie die Daten in Eingaben und Labels
X = df[["Energie (kcal)", "Fett", "Eiweiß, Proteingehalt"]].values
Y = df["Kategorie"].values

# Konvertieren Sie die Daten in Tensoren
X = torch.Tensor(X)
Y = torch.Tensor(Y)


# Definieren Sie das Klassifikationsmodell
class Classifier(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc1 = nn.Linear(3, 4)
        self.fc2 = nn.Linear(4, 2)

    def forward(self, x):
        x = self.fc1(x)
        x = self.fc2(x)
        return x


# Erstellen Sie eine Instanz des Modells
model = Classifier()

# Definieren Sie die Loss-Funktion und den Optimierer
loss_function = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(model.parameters(), lr=0.01)

# Trainieren Sie das Modell
for epoch in range(100):
    # Berechnen Sie die Vorhersagen
    y_pred = model(X)

    # Berechnen Sie die Loss
    loss = loss_function(y_pred, Y)

    # Bereinigen Sie die Gradienten
    optimizer.zero_grad()

    # Berechnen Sie die Gradienten
    loss.backward()

    # Aktualisieren Sie die Gewichte
    optimizer.step()

    # Ausgabe der Loss jede 10. Epoche
    if epoch % 10 == 0:
        print(f"Epoche {epoch}, Loss: {loss.item():.4f}")

# Testen Sie das Modell auf einem Beispiel
example = torch.Tensor([[100, 5, 10]])
prediction = model(example)
prediction_class = prediction.argmax().item()
print(f"Prediction for example: {prediction_class}")
