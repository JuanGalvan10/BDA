function increment() {
    const quantityInput = document.getElementById('quantity');
    let value = parseInt(quantityInput.value, 10);
    quantityInput.value = value + 1;
}

function decrement() {
    const quantityInput = document.getElementById('quantity');
    let value = parseInt(quantityInput.value, 10);
    if (value > 1) {
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
            url: '/horas-disponibles',
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
