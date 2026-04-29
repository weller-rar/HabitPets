from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from database import get_session
import models, schemas
from routes.auth import hash_password, verify_password, create_access_token, get_current_user

router = APIRouter(prefix="/usuarios", tags=["Usuarios"])


@router.post("/registro", response_model=schemas.UsuarioOut, status_code=status.HTTP_201_CREATED)
def registrar_usuario(datos: schemas.UsuarioIn, db: Session = Depends(get_session)):
    existente = db.query(models.Usuario).filter(models.Usuario.correo == datos.correo).first()
    if existente:
        raise HTTPException(status_code=400, detail="El correo ya está registrado")

    nuevo = models.Usuario(
        correo=datos.correo,
        contraseña=hash_password(datos.contraseña),
        dinero=0,
    )
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo


@router.post("/login")
def login(form: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_session)):
    usuario = db.query(models.Usuario).filter(models.Usuario.correo == form.username).first()
    if not usuario or not verify_password(form.password, usuario.contraseña):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Correo o contraseña incorrectos",
            headers={"WWW-Authenticate": "Bearer"},
        )
    token = create_access_token({"sub": str(usuario.id_usuario)})
    return {"access_token": token, "token_type": "bearer"}


@router.get("/me", response_model=schemas.UsuarioOut)
def obtener_perfil(usuario_actual: models.Usuario = Depends(get_current_user)):
    return usuario_actual


@router.patch("/me/dinero", response_model=schemas.UsuarioOut)
def actualizar_dinero(
    cantidad: int,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    if cantidad < 0 and abs(cantidad) > usuario_actual.dinero:
        raise HTTPException(status_code=400, detail="Saldo insuficiente")
    usuario_actual.dinero += cantidad
    db.commit()
    db.refresh(usuario_actual)
    return usuario_actual
