function drawTable() {
// $(function() {
  // alert('ok');
  $('#tbl').dataTable({
    "order": [], // disable INITIAL sort order
    "sDom": 'lrtip', // remove 'filtering element' - see: https://datatables.net/reference/option/dom
    // "ajax": {
    //   "url": "applications/index",
    //   "type": "GET"
    // },
    // "dataSrc": "planning_apps",
    // "columns": [
    //       { "data": "order" },
    //       { "data": "app_ref" },
    //       { "data": "app_code" },
    //       { "data": "app_status" },
    //       { "data": "app_address" },
    //       { "data": "app_description" },
    //       { "data": "app_agent" }
    //   ]
  });
// });


// $(function() {
  // Setup - add a text input to each footer cell
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
