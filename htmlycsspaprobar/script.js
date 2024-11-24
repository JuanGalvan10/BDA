function increment() {
    const quantityInput = document.getElementById('quantity');
    let value = parseInt(quantityInput.value, 10);
    quantityInput.value = value + 1;
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

document.addEventListener('DOMContentLoaded', () => {
    const envioElement = document.getElementById('costo-envio');
    const totalElement = document.getElementById('total');
    const subtotalElement = document.getElementById('subtotal');
    const entregaDomicilioRadio = document.getElementById('flexRadioDefault2');
    const recogerRestauranteRadio = document.getElementById('recoger_restaurante');

    const subtotal = parseFloat(subtotalElement.textContent.replace('$', ''));
    console.log("Subtotal inicial:", subtotal);

    function actualizarCosto() {
        let costoEnvio = 0;

        if (entregaDomicilioRadio.checked) {
            costoEnvio = 50; 
        }
        envioElement.textContent = `$${costoEnvio.toFixed(2)}`;
        totalElement.textContent = `$${(subtotal + costoEnvio).toFixed(2)}`;
    }
    entregaDomicilioRadio.addEventListener('change', actualizarCosto);
    recogerRestauranteRadio.addEventListener('change', actualizarCosto);
    actualizarCosto();
});