from pydantic import BaseModel, Field, EmailStr, DirectoryPath
from datetime import date, time

#---Usuario-------------------------------------------

class UsuarioIn(BaseModel):
    correo: EmailStr
    contraseña: str

class UsuarioOut(UsuarioIn):
    id_usuario: int
    dinero: int = None

#---Mascota--------------------------------------------

class MascotaIn(BaseModel):
    nombre: str = Field(min_length=3,max_length=20)

class MascotaOut(MascotaIn):
    id_mascota: int
    id_usuario: int
    estado: str
    vida: int

#---Tarea-----------------------------------------------

class TareaIn(BaseModel):
    tipo: str
    nombre: str = Field(min_length=3,max_length=20)
    hora: time
    fecha: date
    prioridad: str

class TareaOut(TareaIn):
    id_tarea: int
    id_usuario: int
       
#---Racha-----------------------------------------------

class RachaDiasOut(BaseModel):
    dias: int

class RachaCompleteOut(RachaDiasOut):
    id_racha: int
    id_tarea: int
    
#---Inventario------------------------------------------

class InventarioOut(BaseModel):
    cantidad: int = None
    equipado: bool = None
    
class InvetarioCompleteOut(InventarioOut):
    id_inventario: int
    id_usuario: int

#---Producto--------------------------------------------

class ProductoOut(BaseModel):
    nombre: str
    tipo: str
    precio: int
    descripcion: str
    img: DirectoryPath

class ProductoCompleteOut(ProductoOut):
    id_producto: int
    id_categoria: int

#---Categoria-------------------------------------------

class CategoriaOut(BaseModel):
    nombre: str

class CategoriaCompleteOut(CategoriaOut):
    id_categoria: int
