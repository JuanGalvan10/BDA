document.addEventListener("DOMContentLoaded", function () {
    const hamBurger = document.querySelector(".toggle-btn");
    const sidebar = document.querySelector("#sidebar");

    if (hamBurger && sidebar) {
        hamBurger.addEventListener("click", function () {
            sidebar.classList.toggle("expand");
        });
    } else {
        console.error("Elementos no encontrados: revisa las clases o IDs.");
    }
});

$('#myModal').on('shown.bs.modal', function () {
    $('#myInput').trigger('focus')
})

let archivoSeleccionado = null;

window.configurarArrastrarSoltar = () => {
    const areaArrastrarSoltar = document.getElementById('area-arrastrar-soltar');

    areaArrastrarSoltar.addEventListener('dragover', (event) => {
        event.preventDefault();
        areaArrastrarSoltar.style.borderColor = 'green';
    });

    areaArrastrarSoltar.addEventListener('dragleave', () => {
        areaArrastrarSoltar.style.borderColor = '#ced4da';
    });

    areaArrastrarSoltar.addEventListener('drop', (event) => {
        event.preventDefault();
        const archivos = event.dataTransfer.files;
        if (archivos.length > 0) {
            archivoSeleccionado = archivos[0];
            document.getElementById('mensaje-arrastre').textContent = `Archivo seleccionado: ${archivoSeleccionado.name}`;
            areaArrastrarSoltar.style.borderColor = '#ced4da';
        }
    });
};

window.guardarImagen = () => {
    if (!archivoSeleccionado) {
        alert('Selecciona una imagen antes de guardar.');
        return;
    }
    const formularioDatos = new FormData();
    formularioDatos.append('imagen', archivoSeleccionado);

    fetch('/subir-imagen', {
        method: 'POST',
        body: formularioDatos
    })
    .then(respuesta => respuesta.json())
    .then(datos => {
        if (datos.url_imagen) {
            const urlImagen = datos.url_imagen;
            alert(`Imagen guardada con éxito. URL: ${urlImagen}`);
            console.log(`URL de la imagen: ${urlImagen}`);
        } else {
            alert('Error al guardar la imagen.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Error al guardar la imagen.');
    });
};
