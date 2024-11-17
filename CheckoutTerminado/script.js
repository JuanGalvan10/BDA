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
