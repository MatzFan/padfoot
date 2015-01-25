function drawTable(data) {
  var columns = data.columns;
  var appData = data.app_data;
  $('#table-placeholder').html( "<table class='table table-striped table-condensed' data-toggle='table' id='tbl'></table>" );
  $('#tbl').dataTable({
    "deferRender": true, // for speed
    "order": [], // disable INITIAL sort order
    "sDom": "lrtip", // remove 'filtering element' - see: https://datatables.net/reference/option/dom
    "data": appData,
    "columns": columns,
    "columnDefs": [{
      "targets": [ 0 ], // hide 'order' column
      "visible": false,
      "searchable": false
    }]
  });

  $('#tbl tfoot th').each( function () {
    var title = $('#tbl thead th').eq( $(this).index() ).text();
     $(this).html( '<input type="text" placeholder="'+title+'" />' );
  });
  // DataTable
  var table = $('#tbl').DataTable();
  // Apply the search
  table.columns().eq( 0 ).each( function ( colIdx ) {
    $( 'input', table.column( colIdx ).footer() ).on( 'keyup change', function () {
      table
        .column( colIdx )
        .search( this.value )
        .draw();
    });
  });
}
