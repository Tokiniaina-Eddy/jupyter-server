FROM python:3.11-slim

# Installation des dépendances système
RUN apt-get update && apt-get install -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/*

# Création d'un utilisateur non-root pour la sécurité
RUN useradd -m jupyter
USER jupyter
WORKDIR /home/jupyter

# Installation des packages Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copie du dossier de travail (facultatif si vous utilisez un disque persistant)
COPY --chown=jupyter:jupyter . .

# Exposition du port
EXPOSE 8888

# Lancement de JupyterLab avec sécurité par Token
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.token=''", "--ServerApp.password=''"]