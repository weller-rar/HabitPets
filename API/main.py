from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware # <-- 1. NUEVA IMPORTACIÓN
from pydantic import BaseModel
from typing import List

app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Permite que cualquier App se conecte
    allow_credentials=True,
    allow_methods=["*"], # Permite POST, GET, OPTIONS, etc.
    allow_headers=["*"], # Permite todos los encabezados (headers)
)

class Tarea(BaseModel):
    icono: str
    titulo: str
    hora: str

db_tareas = []

@app.get("/")
def read_root():
    return {"message": "API de HabitPets funcionando"}

@app.post("/login")
def login(user: dict):
    if user.get("username") == "admin" and user.get("password") == "12345":
        return {"status": "ok", "message": "Bienvenido"}
    return {"status": "error", "message": "Credenciales incorrectas"}

@app.post("/tareas")
def guardar_tarea(tarea: Tarea):
    db_tareas.append(tarea)
    return {"message": "Tarea guardada con éxito", "tarea": tarea}

@app.get("/tareas", response_model=List[Tarea])
def obtener_tareas():
    return db_tareas