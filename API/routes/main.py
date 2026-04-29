from fastapi import FastAPI
from database import engine, Base
from routes import usuarios, mascotas, tareas, tienda

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="HabitApp API",
    description="API para gestión de hábitos con mascotas y recompensas",
    version="1.0.0",
)

app.include_router(usuarios.router)
app.include_router(mascotas.router)
app.include_router(tareas.router)
app.include_router(tienda.router)


@app.get("/", tags=["Root"])
def root():
    return {"mensaje": "HabitApp API funcionando ✅"}
