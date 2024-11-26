function increment() {
    const quantityInput = document.getElementById('quantity');
    let value = parseInt(quantityInput.value, 10);
    if (value < 10) {
        quantityInput.value = value + 1;
    }
}

function decrement() {
    const quantityInput = document.getElementById('quantity');
    let value = parseInt(quantityInput.value, 10);
    if (value >= 1) {
        quantityInput.value = value - 1;
    }
}

$('#myModal').on('shown.bs.modal', function () {
    $('#myInput').trigger('focus')
})

$(document).ready(function(){
    $('#fecha').change(function(){
        const fechaSeleccionada = $(this).val();
        
        if (!fechaSeleccionada) return;

        $.ajax({
            type: 'POST',
            url: '/horas_disponibles',
            data: { fecha: fechaSeleccionada },
            success: function(data){
                $('#horas-disponibles').html(data);
            },
            error: function(){
                alert('No se cargaron las horas');
            }
        });
    });
});

document.addEventListener('DOMContentLoaded', function () {
    const fechaInput = document.getElementById('fecha');
    const today = new Date().toISOString().split('T')[0]; 
    fechaInput.setAttribute('min', today); 
});

document.addEventListener('DOMContentLoaded', () => {
    const fechaInput = document.getElementById('fecha');
    const personasInput = document.getElementById('num_personas');
    const horaInput = document.getElementById('btn-hora');
    const temaInput = document.getElementById('txt-reserva');

    const datoFecha = document.getElementById('dia-reserva');
    const datoPersonas = document.getElementById('cant-reserva');
    const datoHora = document.getElementById('hora-reserva');
    const datoTema = document.getElementById('tema-reserva');

    fechaInput.addEventListener('change', () => {
        const fechaSeleccionada = fechaInput.value;
        datoFecha.textContent = `Dia: ${fechaSeleccionada}`
    });

    personasInput.addEventListener('input', () => {
        const numPersonas = personasInput.value;
        datoPersonas.textContent = `Personas: ${numPersonas}`
    });
    const botonesHora = document.querySelectorAll('.btn-hora');
    botonesHora.forEach((boton) => {
        boton.addEventListener('click', () => {
            const horaSeleccionada = boton.value;
            datoHora.textContent = `Hora: ${horaSeleccionada}`;
        });
    });
});
document.addEventListener('DOMContentLoaded', () => {
  const temaInput = document.getElementById('txt-reserva'); 
  const datoTema = document.getElementById('tema-reserva'); 

  datoTema.textContent = 'Tema: Ingresa un tema';

  temaInput.addEventListener('input', () => {
      const tema = temaInput.value.trim(); 
      datoTema.textContent = tema
          ? `Tema: ${tema}` 
          : 'Tema: Ingresa un tema'; 
  });
});

function openNav() {
document.getElementById("mySidenav").style.width = "250px";
}

function closeNav() {
document.getElementById("mySidenav").style.width = "0";
}

function scrollleft(){
document.getElementById("scrolling-text").style.left = '100%';
setTimeout(scrollleft, 25);
}
scrollleft();
