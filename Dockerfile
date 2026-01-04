FROM python:3.11-slim

# Installation des dépendances système (nécessaire pour psycopg2 / Supabase)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Création de l'utilisateur
RUN useradd -m jupyter
USER jupyter
WORKDIR /home/jupyter

ENV PATH="/home/jupyter/.local/bin:${PATH}"

# Installation des dépendances Python
COPY --chown=jupyter:jupyter requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Copie du reste des fichiers
COPY --chown=jupyter:jupyter . .

# Exposition du port Jupyter
EXPOSE 8888

# Lancement sécurisé
# On utilise JUPYTER_TOKEN qui sera lu depuis vos variables d'environnement Render
CMD ["sh", "-c", "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --ServerApp.token=\"${JUPYTER_TOKEN}\" --ServerApp.password=''"]
