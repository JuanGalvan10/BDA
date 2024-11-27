$(document).ready(function(){
    $.getJSON('/data/status_de_clientes', function(data){
        Highcharts.chart('status_de_clientes',{
            chart: {type: 'pie',
            spacing: [10, 10, 10, 10],
            marginTop: 0},
            title: {text: null},
            series: [{name: 'Status', colorByPoint: true, size: '70%', data: data}]
        });
    })
});

    $.getJSON('/data/status_de_reservas', function(data){
        Highcharts.chart('status_de_reservas',{
            chart: {type: 'pie',
            spacing: [10, 10, 10, 10],
            marginTop: 0},
            title: {text: null},
            series: [{name: 'Status', colorByPoint: true, size: '70%', data: data}]
        });
    });

    $.getJSON('/data/platillos_stock', function(data){
        Highcharts.chart('platillos_stock',{
            chart: {type: 'column'},
            title: {text: null},
            xAxis: {title: { text: 'idPlatillo' }},
            yAxis: {title: { text: 'Cantidad en Stock' }},
            series: [{name: 'Platillos', colorByPoint: true, size: '70%', data: data}]
        });
    });

    $.getJSON('/data/compras_por_categoria', function(data){
        Highcharts.chart('compras_por_categoria',{
            chart: {type: 'column'},
            title: {text: null},
            series: [{name: 'Categorias', colorByPoint: true, size: '70%', data: data}]
        });
    });

    $.getJSON('/data/ventas_por_mes', function(data){
        Highcharts.chart('ventas_por_mes',{
            chart: {type: 'pie'},
            title: {text: null},
            series: [{name: 'Ventas', colorByPoint: true, size: '70%', data: data}]
        });
    });

    $.getJSON('/data/ventas_por_dia', function(data){
        Highcharts.chart('ventas_por_dia', {
            chart: { type: 'column' },
            title: { text: null},
            xAxis: { categories: data.map(d => d.fecha_entrega), title: { text: 'Fecha de Entrega' }},
            yAxis: {title: { text: 'Ventas Totales' }},
            series: [{ name: 'Ventas', colorByPoint: true, size: '70%', data: data.map(d => d.Ventas_totales) }]
        });
    });

    $.getJSON('/data/usuarios_activos', function(data){
        Highcharts.chart('usuarios_activos',{
            chart: {type: 'donut'},
            title: {text: null},
            series: [{name: 'Usuarios', colorByPoint: true, size: '70%', data: data}]
        });
    });

    $.getJSON('/data/resenas_calif', function(data){
        Highcharts.chart('resenas_calif',{
            chart: {type: 'column'},
            title: {text: null},
            xAxis: {title: { text: 'Cant Reseñas' }},
            yAxis: {title: { text: 'Puntuacion' }},
            series: [{name: 'Reseñas', colorByPoint: true, size: '70%', data: data}]
        });
    });

    $.getJSON('/data/promedio_resenas_calif', function(data){
        Highcharts.chart('promedio_resenas_calif',{
            chart: {type: 'pie'},
            title: {text: null},
            series: [{name: 'Reseñas', colorByPoint: true, size: '70%', data: data}]
        });
    });