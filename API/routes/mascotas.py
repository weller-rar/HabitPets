from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from database import get_session
import models, schemas
from routes.auth import get_current_user

router = APIRouter(prefix="/mascotas", tags=["Mascotas"])

VIDA_INICIAL = 100
ESTADO_INICIAL = "feliz"


@router.post("/", response_model=schemas.MascotaOut, status_code=status.HTTP_201_CREATED)
def crear_mascota(
    datos: schemas.MascotaIn,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    existente = db.query(models.Mascota).filter(
        models.Mascota.id_usuario == usuario_actual.id_usuario
    ).first()
    if existente:
        raise HTTPException(status_code=400, detail="Ya tienes una mascota")

    mascota = models.Mascota(
        id_usuario=usuario_actual.id_usuario,
        nombre=datos.nombre,
        Estado=ESTADO_INICIAL,
        vida=VIDA_INICIAL,
    )
    db.add(mascota)
    db.commit()
    db.refresh(mascota)
    return mascota


@router.get("/", response_model=schemas.MascotaOut)
def obtener_mascota(
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    mascota = db.query(models.Mascota).filter(
        models.Mascota.id_usuario == usuario_actual.id_usuario
    ).first()
    if not mascota:
        raise HTTPException(status_code=404, detail="No tienes una mascota todavía")
    return mascota


@router.patch("/nombre", response_model=schemas.MascotaOut)
def renombrar_mascota(
    datos: schemas.MascotaIn,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    mascota = db.query(models.Mascota).filter(
        models.Mascota.id_usuario == usuario_actual.id_usuario
    ).first()
    if not mascota:
        raise HTTPException(status_code=404, detail="Mascota no encontrada")
    mascota.nombre = datos.nombre
    db.commit()
    db.refresh(mascota)
    return mascota


@router.patch("/vida", response_model=schemas.MascotaOut)
def actualizar_vida(
    cantidad: int,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    """Suma o resta vida a la mascota (positivo = curar, negativo = dañar)."""
    mascota = db.query(models.Mascota).filter(
        models.Mascota.id_usuario == usuario_actual.id_usuario
    ).first()
    if not mascota:
        raise HTTPException(status_code=404, detail="Mascota no encontrada")

    nueva_vida = max(0, min(VIDA_INICIAL, mascota.vida + cantidad))
    mascota.vida = nueva_vida

    if nueva_vida == 0:
        mascota.Estado = "muerta"
    elif nueva_vida < 30:
        mascota.Estado = "triste"
    elif nueva_vida < 70:
        mascota.Estado = "normal"
    else:
        mascota.Estado = "feliz"

    db.commit()
    db.refresh(mascota)
    return mascota


@router.delete("/", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_mascota(
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    mascota = db.query(models.Mascota).filter(
        models.Mascota.id_usuario == usuario_actual.id_usuario
    ).first()
    if not mascota:
        raise HTTPException(status_code=404, detail="Mascota no encontrada")
    db.delete(mascota)
    db.commit()
