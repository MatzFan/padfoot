function drawTable(appData) {
  $('#table-placeholder').html( '<table cellpadding="0" cellspacing="0" border="0" class="display" id="tbl"></table>' );
  $('#tbl').dataTable({
    // "deferRender": true, // for speed
    "order": [], // disable INITIAL sort order
    "sDom": "lrtip", // remove 'filtering element' - see: https://datatables.net/reference/option/dom
    "data": appData,
    "columns": [
      { "title": "1" },
      { "title": "1" },
      { "title": "1" },
      { "title": "1" },
      { "title": "1" },
      { "title": "1" },
      { "title": "1" },
      { "title": "1" },
      { "title": "1" },
    ]
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
