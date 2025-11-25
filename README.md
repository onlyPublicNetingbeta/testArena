
---

# 1) Justificación técnica corta 
- **Cubit**: reduce boilerplate, suficiente para estados `loading/success/error`. Mantiene tests simples y clara separación UI-lógica.
- **Hive**: persistencia sin SQL, ideal para objetos (ItemModel). Buen rendimiento y fácil snapshot.
- **Go Router**: rutas nombradas simples y manejo de parámetros (`/prefs/:id`).
- **Repositorio + Services**: separa responsabilidades y facilita pruebas unitarias/mocks.

---

# 2) Checklist de entrega 
- [ ] Código compilable en Flutter 3.27.0
- [ ] `item_model.g.dart` generado con build_runner

---


