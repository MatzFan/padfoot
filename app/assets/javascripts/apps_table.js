function drawTable(data, callback) {
  var columns = data.columns;
  var appData = data.app_data;
  $('#tbl').dataTable({
    "deferRender": true, // for speed
    "order": [], // disable INITIAL sort order
    "sDom": "lrtip", // remove 'filtering element' - see: https://datatables.net/reference/option/dom
    "data": appData,
    "columns": columns,
    "columnDefs": [{ // hide 'order' column
      "targets": [ 0 ],
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
  callback();
}
