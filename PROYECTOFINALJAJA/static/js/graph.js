$(document).ready(function(){
    $.getJSON('/data/status_de_clientes', function(data){
        Highcharts.chart('status_de_clientes',{
            chart: {type: 'pie'},
            title: {text: 'Status de Clientes'},
            series: [{name: 'Status', colorByPoint: true, data: data}]
        });
    });
});

    $.getJSON('/data/resenas_calif', function(data){
        Highcharts.chart('resenas_calif',{
            chart: {type: 'bar'},
            title: {text: 'Calificaciones de Reseñas'},
            series: [{name: 'Status', colorByPoint: true, data: data}]
        });
    });

    $.getJSON('/data/status_de_reservas', function(data){
        Highcharts.chart('status_de_reservas',{
            chart: {type: 'pie'},
            title: {text: 'Reservas Actualizadas a la Fecha'},
            series: [{name: 'Status', colorByPoint: true, data: data}]
        });
    });

    $.getJSON('/data/platillos_stock', function(data){
        Highcharts.chart('platillos_stock',{
            chart: {type: 'column'},
            title: {text: 'Inventario Actualizado'},
            series: [{name: 'Status', colorByPoint: true, data: data}]
        });
    });

    $.getJSON('/data/ventas_por_dia', function(data){
        Highcharts.chart('ventas_por_dia', {
            chart: { type: 'column' },
            title: { text: 'Ventas totales por día' },
            xAxis: { categories: data.map(d => d.fecha_entrega), title: { text: 'Fecha de Entrega' }},
            yAxis: {title: { text: 'Ventas Totales' }},
            series: [{ name: 'Ventas', data: data.map(d => d.Ventas_totales) }]
        });
    });
    
    $.getJSON('/data/compras_por_categoria', function(data){
        Highcharts.chart('compras_por_categoria',{
            chart: {type: 'column'},
            title: {text: 'Compras Por Categoria'},
            xAxis: {type: 'category'},
            yAxis: {title: {text: 'Total de Compras'}},
            series: [{name: 'Categorias', data: data}]
        });
    });