from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from database import get_session
import models, schemas
from routes.auth import get_current_user

router = APIRouter(tags=["Tienda"])


# ─── Categorías ───────────────────────────────────────────────────────────────

@router.get("/categorias", response_model=list[schemas.CategoriaCompleteOut])
def listar_categorias(db: Session = Depends(get_session)):
    return db.query(models.Categoria).all()


@router.get("/categorias/{id_categoria}", response_model=schemas.CategoriaCompleteOut)
def obtener_categoria(id_categoria: int, db: Session = Depends(get_session)):
    categoria = db.query(models.Categoria).filter(
        models.Categoria.id_categoria == id_categoria
    ).first()
    if not categoria:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    return categoria


# ─── Productos ────────────────────────────────────────────────────────────────

@router.get("/productos", response_model=list[schemas.ProductoCompleteOut])
def listar_productos(
    id_categoria: int = None,
    db: Session = Depends(get_session),
):
    query = db.query(models.Producto)
    if id_categoria:
        query = query.filter(models.Producto.id_categoria == id_categoria)
    return query.all()


@router.get("/productos/{id_producto}", response_model=schemas.ProductoCompleteOut)
def obtener_producto(id_producto: int, db: Session = Depends(get_session)):
    producto = db.query(models.Producto).filter(
        models.Producto.id_producto == id_producto
    ).first()
    if not producto:
        raise HTTPException(status_code=404, detail="Producto no encontrado")
    return producto


# ─── Inventario ───────────────────────────────────────────────────────────────

@router.get("/inventario", response_model=list[schemas.InvetarioCompleteOut])
def listar_inventario(
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    return db.query(models.Inventario).filter(
        models.Inventario.id_usuario == usuario_actual.id_usuario
    ).all()


@router.post("/inventario/comprar/{id_producto}", response_model=schemas.InvetarioCompleteOut)
def comprar_producto(
    id_producto: int,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    producto = db.query(models.Producto).filter(
        models.Producto.id_producto == id_producto
    ).first()
    if not producto:
        raise HTTPException(status_code=404, detail="Producto no encontrado")

    if usuario_actual.dinero < producto.precio:
        raise HTTPException(status_code=400, detail="Dinero insuficiente")

    ya_tiene = db.query(models.Inventario).filter(
        models.Inventario.id_usuario == usuario_actual.id_usuario,
        models.Inventario.id_producto == id_producto,
    ).first()
    if ya_tiene:
        raise HTTPException(status_code=400, detail="Ya tienes este producto")

    usuario_actual.dinero -= producto.precio

    item = models.Inventario(
        id_usuario=usuario_actual.id_usuario,
        id_producto=id_producto,
        cantidad=1,
        equipado=False,
    )
    db.add(item)
    db.commit()
    db.refresh(item)
    return item


@router.patch("/inventario/{id_inventario}/equipar", response_model=schemas.InvetarioCompleteOut)
def equipar_item(
    id_inventario: int,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    item = db.query(models.Inventario).filter(
        models.Inventario.id_inventario == id_inventario,
        models.Inventario.id_usuario == usuario_actual.id_usuario,
    ).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item no encontrado en tu inventario")

    item.equipado = not item.equipado  # toggle equipado/desequipado
    db.commit()
    db.refresh(item)
    return item


@router.delete("/inventario/{id_inventario}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_item(
    id_inventario: int,
    db: Session = Depends(get_session),
    usuario_actual: models.Usuario = Depends(get_current_user),
):
    item = db.query(models.Inventario).filter(
        models.Inventario.id_inventario == id_inventario,
        models.Inventario.id_usuario == usuario_actual.id_usuario,
    ).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item no encontrado")
    db.delete(item)
    db.commit()
