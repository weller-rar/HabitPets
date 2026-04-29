from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from database import get_session
import models, schemas
from routes.auth import get_current_user
from datetime import date

router = APIRouter(prefix="/tareas", tags=["Tareas"])


# ─── Tareas ───────────────────────────────────────────────────────────────────

@router.post("/", response_model=schemas.TareaOut, status_code=status.HTTP_201_CREATED)
def crear_tarea(
    datos: schemas.TareaIn,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    tarea = models.Tarea(
        id_usuario=usuario_actual.id_usuario,
        tipo=datos.tipo,
        nombre=datos.nombre,
        hora=datos.hora,
        fecha=datos.fecha,
        prioridad=datos.prioridad,
    )
    db.add(tarea)
    db.commit()
    db.refresh(tarea)

    # Crear racha inicial en 0
    racha = models.Racha(id_tarea=tarea.id_tarea, dias=0)
    db.add(racha)
    db.commit()

    return tarea


@router.get("/", response_model=list[schemas.TareaOut])
def listar_tareas(
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    return db.query(models.Tarea).filter(
        models.Tarea.id_usuario == usuario_actual.id_usuario
    ).all()


@router.get("/hoy", response_model=list[schemas.TareaOut])
def tareas_de_hoy(
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    return db.query(models.Tarea).filter(
        models.Tarea.id_usuario == usuario_actual.id_usuario,
        models.Tarea.fecha == date.today(),
    ).all()


@router.get("/{id_tarea}", response_model=schemas.TareaOut)
def obtener_tarea(
    id_tarea: int,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    tarea = db.query(models.Tarea).filter(
        models.Tarea.id_tarea == id_tarea,
        models.Tarea.id_usuario == usuario_actual.id_usuario,
    ).first()
    if not tarea:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")
    return tarea


@router.put("/{id_tarea}", response_model=schemas.TareaOut)
def actualizar_tarea(
    id_tarea: int,
    datos: schemas.TareaIn,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    tarea = db.query(models.Tarea).filter(
        models.Tarea.id_tarea == id_tarea,
        models.Tarea.id_usuario == usuario_actual.id_usuario,
    ).first()
    if not tarea:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")

    for campo, valor in datos.model_dump().items():
        setattr(tarea, campo, valor)
    db.commit()
    db.refresh(tarea)
    return tarea


@router.delete("/{id_tarea}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_tarea(
    id_tarea: int,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    tarea = db.query(models.Tarea).filter(
        models.Tarea.id_tarea == id_tarea,
        models.Tarea.id_usuario == usuario_actual.id_usuario,
    ).first()
    if not tarea:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")
    db.delete(tarea)
    db.commit()


# ─── Rachas ───────────────────────────────────────────────────────────────────

@router.get("/{id_tarea}/racha", response_model=schemas.RachaCompleteOut)
def obtener_racha(
    id_tarea: int,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    tarea = db.query(models.Tarea).filter(
        models.Tarea.id_tarea == id_tarea,
        models.Tarea.id_usuario == usuario_actual.id_usuario,
    ).first()
    if not tarea:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")

    racha = db.query(models.Racha).filter(models.Racha.id_tarea == id_tarea).first()
    if not racha:
        raise HTTPException(status_code=404, detail="Racha no encontrada")
    return racha


@router.post("/{id_tarea}/racha/completar", response_model=schemas.RachaCompleteOut)
def completar_tarea(
    id_tarea: int,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    """Marca la tarea como completada hoy: suma 1 día a la racha."""
    tarea = db.query(models.Tarea).filter(
        models.Tarea.id_tarea == id_tarea,
        models.Tarea.id_usuario == usuario_actual.id_usuario,
    ).first()
    if not tarea:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")

    racha = db.query(models.Racha).filter(models.Racha.id_tarea == id_tarea).first()
    if not racha:
        racha = models.Racha(id_tarea=id_tarea, dias=0)
        db.add(racha)

    racha.dias = (racha.dias or 0) + 1
    db.commit()
    db.refresh(racha)
    return racha


@router.post("/{id_tarea}/racha/reiniciar", response_model=schemas.RachaCompleteOut)
def reiniciar_racha(
    id_tarea: int,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    """Reinicia la racha a 0 (cuando se falla un día)."""
    tarea = db.query(models.Tarea).filter(
        models.Tarea.id_tarea == id_tarea,
        models.Tarea.id_usuario == usuario_actual.id_usuario,
    ).first()
    if not tarea:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")

    racha = db.query(models.Racha).filter(models.Racha.id_tarea == id_tarea).first()
    if not racha:
        raise HTTPException(status_code=404, detail="Racha no encontrada")

    racha.dias = 0
    db.commit()
    db.refresh(racha)
    return racha
