from sqlalchemy import Column, Integer, String, ForeignKey, Boolean, Time, Date
from sqlalchemy.orm import relationship
from database import Base

class Categoria(Base):
    __tablename__ = "categoria"

    id_categoria = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, nullable=False)

class Producto(Base):
    __tablename__ = "producto"

    id_producto = Column(Integer, primary_key=True, index=True)
    id_categoria = Column(Integer, ForeignKey("categoria.id_categoria"),nullable=False)
    nombre = Column(String, nullable=False)
    tipo = Column(String, nullable=False)
    precio = Column(Integer, nullable=False)
    descripcion = Column(String, nullable=False)
    img = Column(String, nullable=False)

class Inventario(Base):
    __tablename__ = "inventario"

    id_inventario = Column(Integer,primary_key=True, index=True)
    id_usuario  = Column(Integer, ForeignKey("usuario.id_usuario"),nullable=False)
    id_producto = Column(Integer, ForeignKey("producto.id_producto"),nullable=False)
    cantidad = Column(Integer, nullable=True)
    equipado = Column(Boolean, nullable=True)

class Mascota(Base):
    __tablename__ = "mascota"

    id_mascota = Column(Integer, primary_key=True, index=True)
    id_usuario = Column(Integer, ForeignKey("usuario.id_usuario"))
    nombre = Column(String, nullable=False)
    Estado = Column(String, nullable=False)
    vida = Column(Integer, nullable=False)
    
class Racha(Base):
    __tablename__ = "racha"

    id_racha = Column(Integer, primary_key=True, index=True)
    id_tarea = Column(Integer, ForeignKey("tarea.id_tarea"), nullable=False)
    dias = Column(Integer, nullable=True)

class Tarea(Base):
    __tablename__ = "tarea"

    id_tarea =  Column(Integer, primary_key=True, index=True)
    id_usuario = Column(Integer, ForeignKey("usuario.id_usuario"))
    tipo = Column(String, nullable=False)
    nombre = Column(String, nullable=False)
    hora = Column(Time, nullable=False)
    fecha = Column(Date, nullable=False)
    prioridad = Column(Integer, nullable=False)
    
class Usuario(Base):
    __tablename__ = "usuario"

    id_usuario = Column(Integer, primary_key=True,index=True)
    correo = Column(String, nullable=False)
    contraseña = Column(String, nullable=False)
    dinero  = Column(Integer, nullable=True)
    